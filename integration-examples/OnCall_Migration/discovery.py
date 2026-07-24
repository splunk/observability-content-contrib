#!/usr/bin/env python3
"""
Export discoverable Splunk On-Call (VictorOps) configuration from the source org to JSON.

Usage:
    cp .env.example .env   # set SOURCE_SPLUNK_ONCALL_API_ID, API_KEY, ORG_SLUG
    python3 discovery.py
    python3 discovery.py -h
    python3 discovery.py --inventory inventory
    python3 discovery.py --teams team-1234,team-5678,team-9012
    python3 discovery.py --teams-file inventory/team_scope.txt

    # uv (with project .venv):
    uv run python3 discovery.py

    # uv (ephemeral, no venv):
    uv run --with requests python3 discovery.py

Output: inventory/*.json, inventory_summary.md, discovery_metadata.json

Next steps: validate_inventory.py, generate_remapping.py, validate_apply.py, apply.py
"""

import argparse
import sys

from utils.cli import print_help_and_exit_if_requested


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Export discoverable Splunk On-Call config from the source org to JSON.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--inventory", default="inventory", help="Output directory for inventory JSON.")
    team_group = parser.add_mutually_exclusive_group()
    team_group.add_argument(
        "--teams",
        help="Comma-separated team slugs to export (not display names).",
    )
    team_group.add_argument(
        "--teams-file",
        help="Path to file with one team slug per line (# comments allowed).",
    )
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)

import itertools
import json
import logging
import os
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

import requests

from utils.env_loader import PROJECT_ROOT, load_dotenv
from utils.exceptions import ApiError, NetworkError
from utils.http_client import BaseVictorOpsClient
from utils.summary_reporter import SummaryReporter
from utils.migration_types import InventoryCounts
from utils.team_scope import (
    collect_usernames,
    expand_policy_closure,
    filter_alert_rules,
    filter_overrides,
    filter_policy_details,
    filter_routing_keys,
    filter_teams,
    filter_users,
    group_policies_by_team,
    parse_teams_arg,
    parse_teams_file,
    routing_key_names,
    seed_policy_slugs,
    team_slugs_for_policies,
    unknown_team_slugs,
)

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%H:%M:%S")
log = logging.getLogger(__name__)


class VictorOpsClient(BaseVictorOpsClient):
    """Encapsulates API session, base URLs, rate limiting, and generic fetching."""
    def __init__(self, api_id: str, api_key: str, org_slug: str):
        super().__init__(
            api_id,
            api_key,
            org_slug,
            retry_total=6,
            retry_backoff=2,
            allowed_methods=["GET"],
        )

    def get(self, endpoint: str, params: Optional[Dict] = None, use_v2: bool = False, paginate: bool = True, required: bool = False) -> Any:
        base_url = self.base_v2 if use_v2 else self.base_v1
        url = self._url(endpoint, base_url)

        merged = []
        is_list_response = False
        current_params = params.copy() if params else {}
        if paginate:
            current_params.setdefault("limit", 100)
            current_params.setdefault("offset", 0)

        while url:
            self.rate_limiter.wait()
            try:
                resp = self.session.get(url, params=current_params, timeout=30)
            except requests.RequestException as exc:
                log.error(f"Network Error: {url} - {exc}")
                raise NetworkError(f"Failed to fetch {url}: {exc}") from exc

            if resp.status_code == 404:
                msg = f"Endpoint not found (404): {url}"
                if required:
                    log.critical(msg)
                    raise ApiError(msg)
                log.warning(f"Not Found (404) for {url}, skipping.")
                return None

            if resp.status_code != 200:
                log.error(f"HTTP {resp.status_code} {url} - {resp.text[:200]}")
                resp.raise_for_status()

            data = resp.json()

            if isinstance(data, list):
                if not paginate:
                    return data
                is_list_response = True
                merged.extend(data)
                break

            if isinstance(data, dict):
                list_keys = [k for k, v in data.items() if isinstance(v, list)]
                if list_keys and paginate:
                    if len(list_keys) > 1:
                        # Multi-list dict (e.g. contact-methods) returned intact to prevent data loss
                        return data

                    is_list_response = True
                    primary_key = next(
                        (k for k in list_keys if data[k] and isinstance(data[k][0], dict)),
                        list_keys[0],
                    )
                    page_items = data[primary_key]
                    merged.extend(page_items)

                    next_url = data.get("nextPage") or data.get("next_page") or data.get("next")
                    if next_url:
                        url = self._url(next_url, base_url)
                        current_params = {}
                        continue

                    limit = current_params.get("limit", 100)
                    if page_items and len(page_items) == limit and isinstance(page_items[0], dict):
                        current_params["offset"] = current_params.get("offset", 0) + limit
                        continue
                    break
                return data

            url = None

        return merged if is_list_response else data


class DiscoveryPipeline:
    """Orchestrates the data extraction logic using VictorOpsClient."""
    def __init__(
        self,
        client: VictorOpsClient,
        output_dir: Path,
        reporter: Optional[SummaryReporter] = None,
        requested_team_slugs: Optional[List[str]] = None,
    ):
        self.client = client
        self.output_dir = output_dir
        self.inventory_counts: InventoryCounts = {}
        self.reporter = reporter or SummaryReporter(output_dir, client.org_slug, self.inventory_counts)
        self.requested_team_slugs = requested_team_slugs
        self.scope_metadata: Optional[Dict[str, Any]] = None

    def save_json(self, name: str, data: Any):
        self.output_dir.mkdir(parents=True, exist_ok=True)
        path = self.output_dir / f"{name}.json"

        # Atomic writes prevent corrupted half-states
        temp_path = path.with_suffix('.tmp')
        temp_path.write_text(json.dumps(data, indent=2))
        temp_path.replace(path)

        if isinstance(data, list):
            log.info(f"  -> Saved {len(data)} items to {path.name}")
        elif isinstance(data, dict):
            log.info(f"  -> Saved {len(data)} entities to {path.name}")
        else:
            log.info(f"  -> Saved to {path.name}")

    def extract_list(self, data: Any, key: str = "") -> List[Any]:
        if data is None:
            return []
        if isinstance(data, list):
            if data and isinstance(data[0], list):
                return list(itertools.chain.from_iterable(data))
            return data
        if isinstance(data, dict):
            return data.get(key, []) or []
        return []

    def parse_timestamp(self, ts: str) -> Optional[datetime]:
        if not ts:
            return None
        try:
            return datetime.fromisoformat(ts.replace("Z", "+00:00"))
        except ValueError:
            log.warning(f"Invalid timestamp format: {ts}")
            return None

    def is_override_active(self, override: Dict, now: datetime) -> bool:
        end_ts = override.get("end")
        if not end_ts:
            return True
        end_dt = self.parse_timestamp(end_ts)
        if not end_dt:
            log.warning(f"Skip Override {override.get('publicId')}: treating invalid end timestamp as inactive.")
            return False
        return end_dt > now

    def fetch_per_entity_concurrent(
        self,
        entities: List[Dict],
        id_key: str,
        endpoint_factory: Callable[[str], str],
        label: str,
        use_v2: bool = False,
        paginate: bool = True,
    ) -> Dict[str, Any]:
        """Concurrent per-entity fetching controlled by thread-safe rate limiter."""
        results = {}
        skipped = 0

        def fetch(entity):
            entity_id = entity.get(id_key)
            if not entity_id:
                return None, None
            data = self.client.get(
                endpoint_factory(entity_id), use_v2=use_v2, paginate=paginate
            )
            return entity_id, data

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(fetch, e): e for e in entities}
            for i, future in enumerate(as_completed(futures), 1):
                entity_id, data = future.result()
                if entity_id:
                    if data is not None:
                        results[entity_id] = data
                    else:
                        log.debug(f"No data for {label} '{entity_id}'")
                else:
                    skipped += 1
                if i % 25 == 0 or i == len(entities):
                    log.info(f"  [{i}/{len(entities)}] {label} fetched")

        if skipped:
            log.warning(f"  -> Skipped {skipped} {label}s with no '{id_key}' identifier.")
        return results

    def get_scheduled_overrides(self) -> Dict[str, List[Any]]:
        log.info("Fetching Scheduled Overrides...")
        now = datetime.now(timezone.utc)
        raw_list = self.extract_list(self.client.get("overrides", required=True), "overrides")

        grouped = {}
        total_active = 0

        for override in raw_list:
            if not isinstance(override, dict):
                continue
            if not self.is_override_active(override, now):
                continue

            total_active += 1
            teamslugs = [
                assignment.get("team") for assignment in override.get("assignments", [])
                if isinstance(assignment, dict) and assignment.get("team")
            ]
            if not teamslugs:
                grouped.setdefault("_unassigned", []).append(override)
                continue
            for teamslug in sorted(teamslugs):
                grouped.setdefault(teamslug, []).append(override)

        log.info(f"  -> Override summary: {len(raw_list)} fetched, {total_active} active kept, {len(grouped)} team buckets.")
        return grouped

    def run(self) -> Dict[str, Any]:
        start_time = time.monotonic()
        log.info("=" * 60)
        log.info(f"Splunk On-Call Discovery | Org: {self.client.org_slug}")
        log.info(f"Output directory: {self.output_dir.resolve()}")
        if self.requested_team_slugs:
            log.info(f"Team scope: {', '.join(self.requested_team_slugs)}")
        log.info("=" * 60)

        if self.requested_team_slugs:
            self._run_scoped()
        else:
            users, teams = self._process_global_entities()
            self._process_user_scoped_entities(users)
            policies_list = self._process_team_scoped_entities(teams)
            if policies_list is not None:
                self._process_policy_details(policies_list)

        elapsed = time.monotonic() - start_time
        self._finalize_run(elapsed)
        return self.inventory_counts

    def _fetch_team_members(self, teams: List[Any]) -> Dict[str, Any]:
        log.info("Fetching Team Members...")
        return self.fetch_per_entity_concurrent(
            teams, "slug", lambda t: f"team/{t}/members", "team"
        )

    def _fetch_team_admins(self, teams: List[Any]) -> Dict[str, Any]:
        log.info("Fetching Team Admins...")
        return self.fetch_per_entity_concurrent(
            teams, "slug", lambda t: f"team/{t}/admins", "team"
        )

    def _fetch_rotations(self, teams: List[Any]) -> Dict[str, Any]:
        log.info("Fetching Team Rotation Definitions...")
        return self.fetch_per_entity_concurrent(
            teams,
            "slug",
            lambda t: f"team/{t}/rotations",
            "team",
            use_v2=True,
            paginate=False,
        )

    def _fetch_schedules(self, teams: List[Any]) -> Dict[str, Any]:
        log.info("Fetching On-Call Schedules v2...")
        return self.fetch_per_entity_concurrent(
            teams, "slug", lambda t: f"team/{t}/oncall/schedule", "team", use_v2=True
        )

    def _fetch_policies_list(self) -> List[Any]:
        log.info("Fetching Escalation Policies summaries...")
        policies_raw = self.client.get("policies", required=True)
        return self.extract_list(policies_raw, "policies")

    def _fetch_policy_details(self, policy_slugs: Set[str]) -> Dict[str, Any]:
        if not policy_slugs:
            return {}
        slugs_sorted = sorted(policy_slugs)
        log.info(f"Fetching {len(slugs_sorted)} policy details...")
        return self.fetch_per_entity_concurrent(
            [{"slug": slug} for slug in slugs_sorted],
            "slug",
            lambda slug: f"policies/{slug}",
            "policy",
        )

    def _fetch_user_contact_methods(self, users: List[Any]) -> Dict[str, Any]:
        log.info("Fetching User Contact Methods...")
        return self.fetch_per_entity_concurrent(
            users, "username", lambda u: f"user/{u}/contact-methods", "user"
        )

    def _fetch_user_paging_policies(self, users: List[Any]) -> Dict[str, Any]:
        log.info("Fetching User Paging Policies...")
        return self.fetch_per_entity_concurrent(
            users, "username", lambda u: f"user/{u}/policies", "user"
        )

    def _run_scoped(self) -> None:
        requested = self.requested_team_slugs or []
        requested_set = set(requested)

        log.info("[Phase 1/4] Fetching global entities...")
        all_users = self.extract_list(self.client.get("user", required=True), "users")
        all_teams = self.extract_list(self.client.get("team", required=True), "teams")
        all_routing_keys = self.extract_list(
            self.client.get("org/routing-keys", required=True), "routingKeys"
        )
        all_rules = self.extract_list(self.client.get("alertRules", required=True), "rules")
        policies_list = self._fetch_policies_list()

        unknown = unknown_team_slugs(requested, all_teams)
        if unknown:
            log.critical(f"Unknown team slug(s): {', '.join(unknown)}")
            sys.exit(1)

        team_slugs = set(requested_set)
        teams_for_fetch = filter_teams(all_teams, team_slugs)

        log.info(f"\n[Phase 3/4] Fetching team-scoped entities ({len(teams_for_fetch)} teams)...")
        team_members = self._fetch_team_members(teams_for_fetch)
        team_admins = self._fetch_team_admins(teams_for_fetch)
        rotations = self._fetch_rotations(teams_for_fetch)

        seed_slugs = seed_policy_slugs(policies_list, team_slugs)
        policy_details = self._fetch_policy_details(seed_slugs)
        expanded_policies = expand_policy_closure(policy_details, seed_slugs)

        missing_details = expanded_policies - set(policy_details.keys())
        if missing_details:
            policy_details.update(self._fetch_policy_details(missing_details))
            expanded_policies = expand_policy_closure(policy_details, seed_slugs)

        expanded_teams = team_slugs_for_policies(policies_list, expanded_policies)
        added_teams = expanded_teams - team_slugs
        if added_teams:
            log.info(f"Policy closure added team slug(s): {', '.join(sorted(added_teams))}")
            extra_teams = filter_teams(all_teams, added_teams)
            team_members.update(self._fetch_team_members(extra_teams))
            team_admins.update(self._fetch_team_admins(extra_teams))
            rotations.update(self._fetch_rotations(extra_teams))
            team_slugs |= added_teams

        teams_for_fetch = filter_teams(all_teams, team_slugs)
        schedules = self._fetch_schedules(teams_for_fetch)
        overrides = filter_overrides(self.get_scheduled_overrides(), team_slugs)

        usernames = collect_usernames(
            team_members,
            rotations,
            team_slugs,
            admins_by_team=team_admins,
            policy_details=policy_details,
            policy_slugs=expanded_policies,
        )
        users = filter_users(all_users, usernames)
        log.info(f"Scoped user set: {len(users)} user(s) from {len(team_slugs)} team(s)")

        filtered_routing_keys = filter_routing_keys(all_routing_keys, expanded_policies)
        filtered_rules = filter_alert_rules(all_rules, routing_key_names(filtered_routing_keys))

        grouped_policies = group_policies_by_team(policies_list, team_slugs, expanded_policies)
        policy_details = filter_policy_details(policy_details, expanded_policies)
        teams = filter_teams(all_teams, team_slugs)

        log.info(f"\n[Phase 2/4] Fetching user-scoped entities ({len(users)} users)...")
        if users:
            contact_methods = self._fetch_user_contact_methods(users)
            paging_policies = self._fetch_user_paging_policies(users)
        else:
            log.warning("[Phase 2/4] No users in scope — skipping user-scoped entities.")
            contact_methods = {}
            paging_policies = {}

        log.info("\n[Phase 4/4] Scoped export complete — saving filtered inventory...")

        self.save_json("users_inventory", users)
        self.inventory_counts["users_inventory"] = len(users)
        self.save_json("teams_inventory", teams)
        self.inventory_counts["teams_inventory"] = len(teams)
        self.save_json("routing_keys_inventory", filtered_routing_keys)
        self.inventory_counts["routing_keys_inventory"] = len(filtered_routing_keys)
        self.save_json("alert_rules_inventory", filtered_rules)
        self.inventory_counts["alert_rules_inventory"] = len(filtered_rules)
        self.save_json("outbound_webhooks_inventory", [])
        self.inventory_counts["outbound_webhooks_inventory"] = 0
        self.inventory_counts["integrations_inventory"] = 0

        self.save_json("contact_methods_inventory", contact_methods)
        self.inventory_counts["contact_methods_inventory"] = len(contact_methods)
        self.save_json("paging_policies_inventory", paging_policies)
        self.inventory_counts["paging_policies_inventory"] = len(paging_policies)

        self.save_json("team_members_inventory", team_members)
        self.inventory_counts["team_members_inventory"] = len(team_members)
        self.save_json("team_admins_inventory", team_admins)
        self.inventory_counts["team_admins_inventory"] = len(team_admins)
        self.save_json("rotation_definitions_inventory", rotations)
        self.inventory_counts["rotation_definitions_inventory"] = len(rotations)
        self.save_json("escalation_policies_inventory", grouped_policies)
        self.inventory_counts["escalation_policies_inventory"] = len(grouped_policies)
        self.save_json("schedules_inventory", schedules)
        self.inventory_counts["schedules_inventory"] = len(schedules)
        self.save_json("scheduled_overrides_inventory", overrides)
        self.inventory_counts["scheduled_overrides_inventory"] = len(overrides)
        self.save_json("escalation_policy_details_inventory", policy_details)
        self.inventory_counts["escalation_policy_details_inventory"] = len(policy_details)

        self.scope_metadata = {
            "mode": "teams",
            "teams": sorted(requested_set),
            "expanded_teams": sorted(team_slugs),
            "expanded_policies": sorted(expanded_policies),
        }
        log.info(
            "Scope summary: %d requested team(s), %d expanded team(s), %d policy slug(s), %d user(s).",
            len(requested_set),
            len(team_slugs),
            len(expanded_policies),
            len(users),
        )

    def _process_global_entities(self) -> Tuple[List[Any], List[Any]]:
        log.info("[Phase 1/4] Fetching global entities...")
        users = self.extract_list(self.client.get("user", required=True), "users")
        self.save_json("users_inventory", users)
        self.inventory_counts["users_inventory"] = len(users)

        teams = self.extract_list(self.client.get("team", required=True), "teams")
        self.save_json("teams_inventory", teams)
        self.inventory_counts["teams_inventory"] = len(teams)

        routing_keys = self.extract_list(
            self.client.get("org/routing-keys", required=True), "routingKeys"
        )
        self.save_json("routing_keys_inventory", routing_keys)
        self.inventory_counts["routing_keys_inventory"] = len(routing_keys)

        rules_raw = self.client.get("alertRules", required=True)
        rules_list = self.extract_list(rules_raw, "rules")
        rules_list.sort(key=lambda x: x.get("rank", 0))
        self.save_json("alert_rules_inventory", rules_list)
        self.inventory_counts["alert_rules_inventory"] = len(rules_list)

        webhooks = self.extract_list(self.client.get("webhooks", required=True), "webhooks")
        self.save_json("outbound_webhooks_inventory", webhooks)
        self.inventory_counts["outbound_webhooks_inventory"] = len(webhooks)

        self.inventory_counts["integrations_inventory"] = 0
        return users, teams

    def _process_user_scoped_entities(self, users: List[Any]) -> None:
        if users:
            log.info(f"\n[Phase 2/4] Fetching user-scoped entities ({len(users)} users)...")
            contact_methods = self._fetch_user_contact_methods(users)
            self.save_json("contact_methods_inventory", contact_methods)
            self.inventory_counts["contact_methods_inventory"] = len(contact_methods)

            paging_policies = self._fetch_user_paging_policies(users)
            self.save_json("paging_policies_inventory", paging_policies)
            self.inventory_counts["paging_policies_inventory"] = len(paging_policies)
            return

        log.warning("[Phase 2/4] No users found — skipping user-scoped entities.")
        self.inventory_counts["contact_methods_inventory"] = 0
        self.inventory_counts["paging_policies_inventory"] = 0

    def _process_team_scoped_entities(self, teams: List[Any]) -> Optional[List[Any]]:
        if not teams:
            log.warning("[Phase 3/4] No teams found — skipping team-scoped entities.")
            self.inventory_counts["team_members_inventory"] = 0
            self.inventory_counts["team_admins_inventory"] = 0
            self.inventory_counts["rotation_definitions_inventory"] = 0
            self.inventory_counts["escalation_policies_inventory"] = 0
            self.inventory_counts["schedules_inventory"] = 0
            self.inventory_counts["scheduled_overrides_inventory"] = 0
            self.inventory_counts["escalation_policy_details_inventory"] = 0
            return None

        log.info(f"\n[Phase 3/4] Fetching team-scoped entities ({len(teams)} teams)...")
        team_members = self._fetch_team_members(teams)
        self.save_json("team_members_inventory", team_members)
        self.inventory_counts["team_members_inventory"] = len(team_members)

        team_admins = self._fetch_team_admins(teams)
        self.save_json("team_admins_inventory", team_admins)
        self.inventory_counts["team_admins_inventory"] = len(team_admins)

        rotations = self._fetch_rotations(teams)
        self.save_json("rotation_definitions_inventory", rotations)
        self.inventory_counts["rotation_definitions_inventory"] = len(rotations)

        policies_list = self._fetch_policies_list()

        grouped_policies = {}
        for policy in policies_list:
            tslug = (policy.get("team") or {}).get("slug")
            if tslug:
                grouped_policies.setdefault(tslug, []).append(policy)

        self.save_json("escalation_policies_inventory", grouped_policies)
        self.inventory_counts["escalation_policies_inventory"] = len(grouped_policies)

        schedules = self._fetch_schedules(teams)
        self.save_json("schedules_inventory", schedules)
        self.inventory_counts["schedules_inventory"] = len(schedules)

        overrides = self.get_scheduled_overrides()
        self.save_json("scheduled_overrides_inventory", overrides)
        self.inventory_counts["scheduled_overrides_inventory"] = len(overrides)
        return policies_list

    def _process_policy_details(self, policies_list: List[Any]) -> None:
        log.info("\n[Phase 4/4] Fetching escalation policy details...")
        unique_slugs = {
            policy.get("policy", {}).get("slug")
            for policy in policies_list
            if policy.get("policy", {}).get("slug")
        }
        policy_details = self._fetch_policy_details(unique_slugs)
        self.save_json("escalation_policy_details_inventory", policy_details)
        self.inventory_counts["escalation_policy_details_inventory"] = len(policy_details)

    def _finalize_run(self, elapsed: float) -> None:
        self.save_metadata(elapsed)
        self.reporter.write_summary(elapsed)

        minutes, seconds = divmod(int(elapsed), 60)
        log.info("=" * 60)
        log.info(f"Discovery complete in {minutes}m {seconds:02d}s.")
        log.info("=" * 60)

    def save_metadata(self, elapsed_seconds: float):
        files_written = [
            {"name": f"{name}.json", "count": count}
            for name, count in sorted(self.inventory_counts.items())
        ]
        metadata = {
            "org_slug": self.client.org_slug,
            "exported_at": datetime.now(timezone.utc).isoformat(),
            "api_version": "v1/v2",
            "elapsed_seconds": round(elapsed_seconds, 1),
            "inventory_counts": self.inventory_counts,
            "files_written": files_written,
            "manual_capture_required": ["integrations", "user_permissions", "sso_settings"],
            "notes": {
                "integrations_inventory": (
                    "Not exported — no public Splunk On-Call API endpoint exists for "
                    "listing integrations. See manual_capture/README.md."
                ),
            },
        }
        if self.scope_metadata:
            metadata["scope"] = self.scope_metadata
            metadata["notes"]["scoped_export"] = (
                "Partial export — alert rules limited to routing_key matches on in-scope "
                "routing keys; outbound webhooks excluded; policy closure may add teams."
            )
        self.save_json("discovery_metadata", metadata)


def main(argv: Optional[List[str]] = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    env_path = load_dotenv()
    if env_path:
        log.info(f"Loaded environment from {env_path}")
    else:
        log.warning(f"No .env file found at {PROJECT_ROOT / '.env'}")

    api_id = os.getenv("SOURCE_SPLUNK_ONCALL_API_ID")
    api_key = os.getenv("SOURCE_SPLUNK_ONCALL_API_KEY")
    org_slug = os.getenv("SOURCE_SPLUNK_ONCALL_ORG_SLUG")

    if not all([api_id, api_key, org_slug]):
        log.critical("Missing required environment variables. Set SOURCE_SPLUNK_ONCALL_API_ID, SOURCE_SPLUNK_ONCALL_API_KEY, SOURCE_SPLUNK_ONCALL_ORG_SLUG.")
        sys.exit(1)

    requested_teams: Optional[List[str]] = None
    if args.teams:
        requested_teams = parse_teams_arg(args.teams)
    elif args.teams_file:
        teams_path = Path(args.teams_file)
        if not teams_path.exists():
            log.critical(f"Teams file not found: {teams_path}")
            sys.exit(1)
        requested_teams = parse_teams_file(teams_path)

    if requested_teams is not None and not requested_teams:
        log.critical("No team slugs provided via --teams or --teams-file.")
        sys.exit(1)

    client = VictorOpsClient(api_id, api_key, org_slug)
    pipeline = DiscoveryPipeline(client, Path(args.inventory), requested_team_slugs=requested_teams)
    pipeline.run()

if __name__ == "__main__":
    main()
