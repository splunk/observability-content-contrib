#!/usr/bin/env python3
"""
Apply Splunk On-Call inventory to a target org using remapping.json.

Dry-run by default. Pass --apply to execute writes.

Usage:
    python3 apply.py
    python3 apply.py -h
    python3 apply.py --apply --inventory inventory --remapping inventory/remapping.json
"""

from __future__ import annotations

import argparse
import sys

from utils.cli import print_help_and_exit_if_requested


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Apply Splunk On-Call inventory to target org.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--apply", action="store_true", help="Execute writes (default is dry-run).")
    parser.add_argument("--inventory", default="inventory", help="Inventory directory path.")
    parser.add_argument("--remapping", default="inventory/remapping.json", help="Remapping file path.")
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)

import json
import logging
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

import requests

from utils.env_loader import PROJECT_ROOT, load_dotenv
from utils.http_client import BaseVictorOpsClient
from utils.io import load_json

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%H:%M:%S")
log = logging.getLogger(__name__)


def post_succeeded(code: int, result: Any = None) -> bool:
    return code in (200, 201) and result is not None


class RemappingContext:
    def __init__(self, remapping: Dict[str, Dict[str, Any]]):
        self.remapping = remapping

    def map_value(self, category: str, source: str) -> Optional[str]:
        mappings = self.remapping.get(category, {})
        if source not in mappings:
            return source
        target = mappings[source]
        if target is None:
            return None
        return str(target)

    def is_skipped(self, category: str, source: str) -> bool:
        mappings = self.remapping.get(category, {})
        return source in mappings and mappings[source] is None


class ApplyClient(BaseVictorOpsClient):
    def __init__(self, api_id: str, api_key: str, org_slug: str, dry_run: bool = True):
        super().__init__(
            api_id,
            api_key,
            org_slug,
            retry_total=3,
            retry_backoff=1,
            allowed_methods=["GET", "POST"],
            extra_headers={"Content-Type": "application/json"},
        )
        self.dry_run = dry_run

    def get(self, endpoint: str, allow_404: bool = False) -> Tuple[Optional[Any], int]:
        url = self._url(endpoint, self.base_v1)
        self.rate_limiter.wait()
        if self.dry_run and not allow_404:
            log.debug(f"DRY-RUN GET {url}")
        resp = self.session.get(url, timeout=30)
        if resp.status_code == 404 and allow_404:
            return None, 404
        if resp.status_code != 200:
            log.error(f"GET {url} -> {resp.status_code}: {resp.text[:200]}")
            return None, resp.status_code
        return resp.json(), resp.status_code

    def post(self, endpoint: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        url = self._url(endpoint, self.base_v1)
        self.rate_limiter.wait()
        if self.dry_run:
            log.info(f"DRY-RUN POST {url}")
            return {"dry_run": True, "endpoint": endpoint, "payload": payload}, 200
        resp = self.session.post(url, json=payload, timeout=30)
        if resp.status_code not in (200, 201):
            log.error(f"POST {url} -> {resp.status_code}: {resp.text[:200]}")
            return None, resp.status_code
        try:
            return resp.json(), resp.status_code
        except ValueError:
            return {}, resp.status_code

    def post_once(self, endpoint: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        """POST without urllib3 retries so a single error response is logged."""
        url = self._url(endpoint, self.base_v1)
        self.rate_limiter.wait()
        if self.dry_run:
            log.info(f"DRY-RUN POST {url}")
            return {"dry_run": True, "endpoint": endpoint, "payload": payload}, 200
        resp = requests.post(url, json=payload, headers=dict(self.session.headers), timeout=30)
        if resp.status_code not in (200, 201):
            log.error(f"POST {url} -> {resp.status_code}: {resp.text}")
            return None, resp.status_code
        try:
            return resp.json(), resp.status_code
        except ValueError:
            return {}, resp.status_code


class ApplyPipeline:
    def __init__(
        self,
        client: ApplyClient,
        inventory_dir: Path,
        remapping: RemappingContext,
        report_path: Path,
    ):
        self.client = client
        self.inventory_dir = inventory_dir
        self.remapping = remapping
        self.report_path = report_path
        self.team_slug_map: Dict[str, str] = {}
        self.policy_slug_map: Dict[str, str] = {}
        self.rtg_slug_map: Dict[str, str] = {}
        self.rtg_label_by_source_slug: Dict[str, str] = {}
        self.policy_team_map: Dict[str, str] = {}
        self.stats: Dict[str, Dict[str, int]] = {}
        self.failures: Dict[str, List[str]] = {}

    def _load_json(self, name: str) -> Any:
        return load_json(self.inventory_dir / f"{name}.json")

    def _bump(self, step: str, outcome: str) -> None:
        self.stats.setdefault(step, {"created": 0, "skipped": 0, "failed": 0, "warned": 0})
        self.stats[step][outcome] += 1

    def _record_failure(self, step: str, detail: str) -> None:
        self.failures.setdefault(step, []).append(detail)

    def run(self) -> Dict[str, Any]:
        self._index_policy_metadata()
        self._index_rotation_group_labels()
        steps: List[Tuple[str, Callable[[], None]]] = [
            ("users", self.apply_users),
            ("teams", self.apply_teams),
            ("members", self.apply_members),
            ("admins", self.apply_admins),
            ("rotations", self.apply_rotations),
            ("escalation_policies", self.apply_escalation_policies),
            ("routing_keys", self.apply_routing_keys),
            ("alert_rules", self.apply_alert_rules),
        ]
        self._run_steps(steps)
        return self._write_report()

    def _run_steps(self, steps: List[Tuple[str, Callable[[], None]]]) -> None:
        for name, func in steps:
            log.info("=" * 60)
            log.info(f"Apply step: {name}")
            func()

    def _write_report(self) -> Dict[str, Any]:
        report = {
            "org_slug": self.client.org_slug,
            "applied_at": datetime.now(timezone.utc).isoformat(),
            "dry_run": self.client.dry_run,
            "stats": self.stats,
            "failures": self.failures,
            "slug_maps": {
                "teams": self.team_slug_map,
                "escalation_policies": self.policy_slug_map,
                "rotation_groups": self.rtg_slug_map,
            },
        }
        self.report_path.parent.mkdir(parents=True, exist_ok=True)
        self.report_path.write_text(json.dumps(report, indent=2))
        log.info(f"Apply report written to {self.report_path}")
        return report

    def _index_policy_metadata(self) -> None:
        grouped = self._load_json("escalation_policies_inventory") or {}
        if not isinstance(grouped, dict):
            return
        for team_slug, policies in grouped.items():
            for entry in policies:
                policy = entry.get("policy", {})
                slug = policy.get("slug")
                if slug:
                    self.policy_team_map[slug] = team_slug

    def _index_rotation_group_labels(self) -> None:
        details = self._load_json("escalation_policy_details_inventory") or {}
        if not isinstance(details, dict):
            return
        for _policy_slug, steps in details.items():
            if not isinstance(steps, list):
                continue
            for step in steps:
                for entry in step.get("entries", []):
                    if entry.get("executionType") not in (
                        "rotation_group",
                        "rotation_group_next",
                        "rotation_group_previous",
                    ):
                        continue
                    rg = entry.get("rotationGroup", {})
                    slug = rg.get("slug")
                    label = rg.get("label")
                    if slug and label:
                        self.rtg_label_by_source_slug[slug] = label

    def apply_users(self) -> None:
        users = self._load_json("users_inventory") or []
        for user in users:
            if not isinstance(user, dict):
                continue
            source_username = user.get("username")
            if not source_username or self.remapping.is_skipped("users", source_username):
                self._bump("users", "skipped")
                continue
            target_username = self.remapping.map_value("users", source_username)
            source_email = user.get("email") or f"{target_username}@example.com"
            if self.remapping.is_skipped("emails", source_email):
                self._bump("users", "skipped")
                continue
            target_email = self.remapping.map_value("emails", source_email)
            existing, status = self.client.get(f"user/{target_username}", allow_404=True)
            if status == 200 and existing:
                log.info(f"  SKIP user exists: {target_username}")
                self._bump("users", "skipped")
                continue
            payload = {
                "firstName": user.get("firstName", ""),
                "lastName": user.get("lastName", ""),
                "username": target_username,
                "email": target_email,
            }
            result, code = self.client.post("user", payload)
            if post_succeeded(code, result):
                self._bump("users", "created")
            else:
                log.error(
                    f"  FAILED user create: {source_username} -> {target_username} (HTTP {code})"
                )
                self._record_failure("users", f"{source_username}->{target_username}")
                self._bump("users", "failed")

    def _list_teams(self) -> List[Dict[str, Any]]:
        data, status = self.client.get("team", allow_404=True)
        if status != 200:
            return []
        if isinstance(data, list):
            return [t for t in data if isinstance(t, dict)]
        if isinstance(data, dict):
            teams = data.get("teams")
            if isinstance(teams, list):
                return [t for t in teams if isinstance(t, dict)]
        return []

    def _existing_routing_keys(self) -> Set[str]:
        data, status = self.client.get("org/routing-keys", allow_404=True)
        if status != 200:
            return set()
        if isinstance(data, list):
            items = data
        elif isinstance(data, dict):
            items = data.get("routingKeys") or []
        else:
            items = []
        return {rk.get("routingKey") for rk in items if isinstance(rk, dict) and rk.get("routingKey")}

    @staticmethod
    def _alert_rule_signature(alert_field: Any, match_value: Any, rank: Any) -> Tuple[Any, Any, Any]:
        return (alert_field, match_value, rank)

    def _existing_alert_rule_signatures(self) -> Set[Tuple[Any, Any, Any]]:
        data, status = self.client.get("alertRules", allow_404=True)
        if status != 200:
            return set()
        if isinstance(data, list):
            items = data
        elif isinstance(data, dict):
            items = data.get("alertRules") or []
        else:
            items = []
        signatures: Set[Tuple[Any, Any, Any]] = set()
        for rule in items:
            if isinstance(rule, dict):
                signatures.add(
                    self._alert_rule_signature(
                        rule.get("alertField"),
                        rule.get("alertValueMatch", ""),
                        rule.get("rank", 1),
                    )
                )
        return signatures

    def apply_teams(self) -> None:
        teams = self._load_json("teams_inventory") or []
        existing_by_name = {t.get("name"): t.get("slug") for t in self._list_teams() if t.get("name")}

        for team in teams:
            if not isinstance(team, dict):
                continue
            source_slug = team.get("slug")
            name = team.get("name")
            if not source_slug or not name or self.remapping.is_skipped("teams", source_slug):
                self._bump("teams", "skipped")
                continue
            if name in existing_by_name:
                self.team_slug_map[source_slug] = existing_by_name[name]
                log.info(f"  SKIP team exists: {name} -> {existing_by_name[name]}")
                self._bump("teams", "skipped")
                continue
            payload = {"name": name}
            if team.get("description"):
                payload["description"] = team["description"]
            result, code = self.client.post("team", payload)
            if post_succeeded(code, result):
                target_slug = result.get("slug", source_slug)
                self.team_slug_map[source_slug] = target_slug
                existing_by_name[name] = target_slug
                self._bump("teams", "created")
            else:
                self._bump("teams", "failed")

    def _target_team_slug(self, source_slug: str) -> Optional[str]:
        if self.remapping.is_skipped("teams", source_slug):
            return None
        return self.team_slug_map.get(source_slug, self.remapping.map_value("teams", source_slug))

    def apply_members(self) -> None:
        members_by_team = self._load_json("team_members_inventory") or {}
        if not isinstance(members_by_team, dict):
            return
        for source_team, members in members_by_team.items():
            target_team = self._target_team_slug(source_team)
            if not target_team:
                continue
            for member in members:
                if not isinstance(member, dict):
                    continue
                source_user = member.get("username")
                if not source_user or self.remapping.is_skipped("users", source_user):
                    self._bump("members", "skipped")
                    continue
                target_user = self.remapping.map_value("users", source_user)
                team_members, status = self.client.get(f"team/{target_team}/members", allow_404=True)
                if status == 200 and isinstance(team_members, dict):
                    current = {m.get("username") for m in team_members.get("members", []) if isinstance(m, dict)}
                    if target_user in current:
                        self._bump("members", "skipped")
                        continue
                result, code = self.client.post(f"team/{target_team}/members", {"username": target_user})
                if post_succeeded(code, result):
                    self._bump("members", "created")
                else:
                    self._bump("members", "failed")

    def apply_admins(self) -> None:
        """Team admin assignment has no public POST endpoint — record for manual follow-up."""
        admins_by_team = self._load_json("team_admins_inventory") or {}
        if not isinstance(admins_by_team, dict):
            return
        for source_team, admins in admins_by_team.items():
            if self.remapping.is_skipped("teams", source_team):
                continue
            if not admins:
                continue
            log.warning(
                f"  Team admins for '{source_team}' cannot be applied via API — configure in target UI."
            )
            self._bump("admins", "warned")

    def _iso_to_epoch_ms(self, value: Any) -> int:
        if isinstance(value, (int, float)):
            return int(value)
        if not isinstance(value, str) or not value:
            return 0
        try:
            dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
            return int(dt.timestamp() * 1000)
        except ValueError:
            return 0

    def _build_rotation_payload(self, rotation: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        shifts_out = []
        rotation_label = rotation.get("label", "rotation")
        for shift in rotation.get("shifts", []):
            if not isinstance(shift, dict):
                continue
            usernames = []
            for member in shift.get("shiftMembers", []):
                if not isinstance(member, dict):
                    continue
                source_user = member.get("username")
                if source_user and not self.remapping.is_skipped("users", source_user):
                    usernames.append(self.remapping.map_value("users", source_user))
            if not usernames:
                log.warning(
                    f"  Skipping shift '{shift.get('label', 'shift')}' in rotation "
                    f"'{rotation_label}': no remapped members after filtering skipped users."
                )
                continue
            shift_payload = {
                "label": shift.get("label", "shift"),
                "timezone": shift.get("timezone", "UTC"),
                "start": self._iso_to_epoch_ms(shift.get("start")),
                "duration": min(int(shift.get("duration", 7)), 90),
                "shifttype": shift.get("shifttype", "std"),
                "mask": shift.get("mask", {}),
                "usernames": usernames,
            }
            if shift.get("mask2"):
                shift_payload["mask2"] = shift["mask2"]
            if shift.get("mask3"):
                shift_payload["mask3"] = shift["mask3"]
            shifts_out.append(shift_payload)
        if not shifts_out:
            log.warning(
                f"  Skipping rotation '{rotation_label}': no valid shifts remain after filtering."
            )
            return None
        return {"label": rotation_label, "shifts": shifts_out}

    def _refresh_rtg_map_for_team(self, source_team: str, target_team: str) -> None:
        data, status = self.client.get(f"teams/{target_team}/rotations", allow_404=True)
        if status != 200 or not isinstance(data, dict):
            return
        label_to_target = {
            g.get("label"): g.get("slug")
            for g in data.get("rotationGroups", [])
            if isinstance(g, dict) and g.get("label") and g.get("slug")
        }
        details = self._load_json("escalation_policy_details_inventory") or {}
        for policy_slug, steps in (details or {}).items():
            if self.policy_team_map.get(policy_slug) != source_team:
                continue
            for step in steps or []:
                for entry in step.get("entries", []):
                    rg = entry.get("rotationGroup", {})
                    source_rtg = rg.get("slug")
                    source_label = rg.get("label")
                    if source_rtg and source_label and source_label in label_to_target:
                        self.rtg_slug_map[source_rtg] = label_to_target[source_label]

    def apply_rotations(self) -> None:
        rotations_by_team = self._load_json("rotation_definitions_inventory") or {}
        if not isinstance(rotations_by_team, dict):
            return

        for source_team, payload in rotations_by_team.items():
            target_team = self._target_team_slug(source_team)
            if not target_team or not isinstance(payload, dict):
                continue
            for rotation in payload.get("rotations", []):
                if not isinstance(rotation, dict):
                    continue
                label = rotation.get("label", "")
                existing, status = self.client.get(f"teams/{target_team}/rotations", allow_404=True)
                if status == 200 and isinstance(existing, dict):
                    labels = {g.get("label") for g in existing.get("rotationGroups", []) if isinstance(g, dict)}
                    if label in labels:
                        self._bump("rotations", "skipped")
                        self._refresh_rtg_map_for_team(source_team, target_team)
                        continue
                body = self._build_rotation_payload(rotation)
                if body is None:
                    self._bump("rotations", "skipped")
                    continue
                result, code = self.client.post_once(f"teams/{target_team}/rotations", body)
                if post_succeeded(code, result):
                    self._bump("rotations", "created")
                else:
                    log.error(
                        f"  FAILED rotation '{label}' on team {target_team} (HTTP {code})"
                    )
                    log.error(f"  Rotation POST payload: {json.dumps(body)[:4000]}")
                    self._record_failure("rotations", f"{label}@{target_team}")
                    self._bump("rotations", "failed")
            self._refresh_rtg_map_for_team(source_team, target_team)

    def _transform_policy_entry(self, entry: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        execution_type = entry.get("executionType")
        if execution_type == "webhook":
            log.warning("  Skipping webhook escalation entry (outbound webhooks are deferred).")
            self._bump("escalation_policies", "warned")
            return None
        transformed: Dict[str, Any] = {"executionType": execution_type}
        if execution_type in ("rotation_group", "rotation_group_next", "rotation_group_previous"):
            rg = entry.get("rotationGroup", {})
            source_slug = rg.get("slug")
            if not source_slug:
                return None
            target_slug = self.rtg_slug_map.get(source_slug)
            if not target_slug:
                log.error(
                    f"  Skipping rotation_group entry: source rotation '{source_slug}' "
                    f"({rg.get('label', '')}) is not mapped on target — apply rotations first."
                )
                self._bump("escalation_policies", "warned")
                return None
            transformed["rotationGroup"] = {"slug": target_slug}
        elif execution_type == "user":
            user = entry.get("user", {})
            source_user = user.get("username")
            if source_user and self.remapping.is_skipped("users", source_user):
                return None
            transformed["user"] = {"username": self.remapping.map_value("users", source_user or "")}
        elif execution_type == "email":
            source_address = entry.get("email", {}).get("address", "")
            if not source_address:
                return None
            if self.remapping.is_skipped("emails", source_address):
                return None
            transformed["email"] = {"address": self.remapping.map_value("emails", source_address)}
        elif execution_type == "policy_routing":
            target = entry.get("targetPolicy", {})
            source_policy = target.get("policySlug")
            if not source_policy:
                return None
            target_policy = self.policy_slug_map.get(source_policy)
            if not target_policy:
                log.error(
                    f"  Skipping policy_routing entry: source policy '{source_policy}' "
                    "is not on target — apply escalation policies first."
                )
                self._bump("escalation_policies", "warned")
                return None
            transformed["targetPolicy"] = {"policySlug": target_policy}
        else:
            return None
        return transformed

    def _policy_sort_order(self, policy_slugs: List[str], details: Dict[str, Any]) -> List[str]:
        deps: Dict[str, Set[str]] = {slug: set() for slug in policy_slugs}
        for slug in policy_slugs:
            for step in details.get(slug, []) or []:
                for entry in step.get("entries", []):
                    if entry.get("executionType") == "policy_routing":
                        dep = entry.get("targetPolicy", {}).get("policySlug")
                        if dep and dep in deps and dep != slug:
                            deps[slug].add(dep)
        ordered: List[str] = []
        remaining = set(policy_slugs)
        while remaining:
            ready = sorted(s for s in remaining if not deps[s] - set(ordered))
            if not ready:
                ordered.extend(sorted(remaining))
                break
            ordered.extend(ready)
            remaining -= set(ready)
        return ordered

    def _policy_rotation_groups_mapped(self, source_slug: str, details: Dict[str, Any]) -> bool:
        for step in details.get(source_slug, []) or []:
            for entry in step.get("entries", []):
                if entry.get("executionType") not in (
                    "rotation_group",
                    "rotation_group_next",
                    "rotation_group_previous",
                ):
                    continue
                source_rtg = entry.get("rotationGroup", {}).get("slug")
                if source_rtg and source_rtg not in self.rtg_slug_map:
                    label = entry.get("rotationGroup", {}).get("label", "")
                    log.error(
                        f"  Cannot apply policy '{source_slug}': rotation group "
                        f"'{source_rtg}' ({label}) not mapped on target — apply rotations first."
                    )
                    return False
        return True

    def apply_escalation_policies(self) -> None:
        grouped = self._load_json("escalation_policies_inventory") or {}
        details = self._load_json("escalation_policy_details_inventory") or {}
        if not isinstance(grouped, dict) or not isinstance(details, dict):
            return

        all_slugs: List[str] = []
        policy_names: Dict[str, str] = {}
        for _team, policies in grouped.items():
            for entry in policies:
                policy = entry.get("policy", {})
                slug = policy.get("slug")
                if slug:
                    all_slugs.append(slug)
                    policy_names[slug] = policy.get("name", slug)

        for source_slug in self._policy_sort_order(all_slugs, details):
            if self.remapping.is_skipped("escalation_policies", source_slug):
                self._bump("escalation_policies", "skipped")
                continue
            source_team = self.policy_team_map.get(source_slug)
            if not source_team or self.remapping.is_skipped("teams", source_team):
                self._bump("escalation_policies", "skipped")
                continue
            target_team = self._target_team_slug(source_team)
            if not target_team:
                self._bump("escalation_policies", "failed")
                continue

            target_policy_slug = self.remapping.map_value("escalation_policies", source_slug)
            if not target_policy_slug:
                self._bump("escalation_policies", "skipped")
                continue
            existing, status = self.client.get(f"policies/{target_policy_slug}", allow_404=True)
            if status == 200 and existing:
                self.policy_slug_map[source_slug] = existing.get("slug", target_policy_slug)
                self._bump("escalation_policies", "skipped")
                continue

            if not self._policy_rotation_groups_mapped(source_slug, details):
                self._record_failure("escalation_policies", source_slug)
                self._bump("escalation_policies", "failed")
                continue

            steps_out = []
            for step in details.get(source_slug, []) or []:
                entries_out = []
                for entry in step.get("entries", []):
                    transformed = self._transform_policy_entry(entry)
                    if transformed:
                        entries_out.append(transformed)
                if entries_out:
                    steps_out.append({"timeout": step.get("timeout", 0), "entries": entries_out})
            if not steps_out:
                self._bump("escalation_policies", "skipped")
                continue

            payload = {
                "name": policy_names.get(source_slug, source_slug),
                "teamSlug": target_team,
                "ignoreCustomPagingPolicies": False,
                "steps": steps_out,
            }
            result, code = self.client.post("policies", payload)
            if post_succeeded(code, result):
                self.policy_slug_map[source_slug] = result.get("slug", target_policy_slug)
                self._bump("escalation_policies", "created")
            else:
                self._bump("escalation_policies", "failed")

    def apply_routing_keys(self) -> None:
        routing_keys = self._load_json("routing_keys_inventory") or []
        existing_keys = self._existing_routing_keys()
        for rk in routing_keys:
            if not isinstance(rk, dict):
                continue
            source_name = rk.get("routingKey")
            if not source_name or self.remapping.is_skipped("routing_keys", source_name):
                self._bump("routing_keys", "skipped")
                continue
            target_name = self.remapping.map_value("routing_keys", source_name)
            if target_name in existing_keys:
                log.info(f"  SKIP routing key exists: {target_name}")
                self._bump("routing_keys", "skipped")
                continue
            targets = []
            for target in rk.get("targets", []):
                source_policy = target.get("policySlug")
                if not source_policy:
                    url = target.get("policyUrl") or target.get("_policyUrl") or ""
                    source_policy = url.rstrip("/").split("/")[-1] if url else ""
                if not source_policy or self.remapping.is_skipped("escalation_policies", source_policy):
                    continue
                target_policy = self.policy_slug_map.get(source_policy)
                if not target_policy:
                    log.error(
                        f"  Routing key '{target_name}' targets policy '{source_policy}' "
                        "which is not on target — apply escalation policies first."
                    )
                    continue
                targets.append(target_policy)
            if not targets:
                log.warning(
                    f"  Skipping routing key '{target_name}': no target policies available."
                )
                self._bump("routing_keys", "skipped")
                continue
            payload = {"routingKey": target_name, "targets": targets}
            result, code = self.client.post("org/routing-keys", payload)
            if post_succeeded(code, result):
                existing_keys.add(target_name)
                self._bump("routing_keys", "created")
            else:
                self._bump("routing_keys", "failed")

    def apply_alert_rules(self) -> None:
        rules = self._load_json("alert_rules_inventory") or []
        existing_signatures = self._existing_alert_rule_signatures()
        for rule in rules:
            if not isinstance(rule, dict):
                continue
            rule_id = str(rule.get("id", ""))
            if not rule_id or self.remapping.is_skipped("alert_rules", rule_id):
                self._bump("alert_rules", "skipped")
                continue
            match_value = rule.get("alertValueMatch", "")
            if rule.get("alertField") == "routing_key" and match_value:
                match_value = self.remapping.map_value("routing_keys", match_value) or match_value
            rank = rule.get("rank", 1)
            signature = self._alert_rule_signature(rule.get("alertField"), match_value, rank)
            if signature in existing_signatures:
                log.info(f"  SKIP alert rule exists: {signature}")
                self._bump("alert_rules", "skipped")
                continue
            payload = {
                "alertField": rule.get("alertField"),
                "alertValueMatch": match_value,
                "matchType": rule.get("matchType", "WILDCARD"),
                "rank": rank,
                "stopFlag": rule.get("stopFlag", False),
                "notes": rule.get("notes", ""),
            }
            if rule.get("annotations"):
                payload["annotations"] = rule["annotations"]
            result, code = self.client.post("alertRules", payload)
            if post_succeeded(code, result):
                existing_signatures.add(signature)
                self._bump("alert_rules", "created")
            else:
                self._bump("alert_rules", "failed")


def main(argv: list[str] | None = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    env_path = load_dotenv()
    if env_path:
        log.info(f"Loaded environment from {env_path}")
    else:
        log.warning(f"No .env file found at {PROJECT_ROOT / '.env'}")

    required = {
        "TARGET_SPLUNK_ONCALL_API_ID": os.getenv("TARGET_SPLUNK_ONCALL_API_ID"),
        "TARGET_SPLUNK_ONCALL_API_KEY": os.getenv("TARGET_SPLUNK_ONCALL_API_KEY"),
        "TARGET_SPLUNK_ONCALL_ORG_SLUG": os.getenv("TARGET_SPLUNK_ONCALL_ORG_SLUG"),
    }
    missing = [name for name, value in required.items() if not value]
    if missing:
        log.critical("Missing target org credentials:")
        for name in missing:
            log.critical(f"  - {name}")
        log.critical(
            "Add TARGET_SPLUNK_ONCALL_API_ID, TARGET_SPLUNK_ONCALL_API_KEY, and "
            "TARGET_SPLUNK_ONCALL_ORG_SLUG to your .env (see .env.example)."
        )
        sys.exit(1)

    api_id = required["TARGET_SPLUNK_ONCALL_API_ID"]
    api_key = required["TARGET_SPLUNK_ONCALL_API_KEY"]
    org_slug = required["TARGET_SPLUNK_ONCALL_ORG_SLUG"]

    remapping_path = Path(args.remapping)
    if not remapping_path.exists():
        log.critical(f"Remapping file not found: {remapping_path}")
        sys.exit(1)

    remapping_data = json.loads(remapping_path.read_text())
    client = ApplyClient(api_id, api_key, org_slug, dry_run=not args.apply)
    pipeline = ApplyPipeline(
        client,
        Path(args.inventory),
        RemappingContext(remapping_data),
        Path(args.inventory) / "apply_report.json",
    )

    mode = "APPLY" if args.apply else "DRY-RUN"
    log.info(f"Starting apply pipeline ({mode}) for org '{org_slug}'")
    pipeline.run()


if __name__ == "__main__":
    main()
