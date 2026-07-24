#!/usr/bin/env python3
"""
Pre-flight checks for remapping.json against inventory (no API calls).

Usage:
    python3 validate_apply.py
    python3 validate_apply.py -h
    python3 validate_apply.py --inventory inventory --remapping inventory/remapping.json
"""

import argparse
import logging
import re
import sys
from pathlib import Path
from typing import Any, Dict

from utils.cli import print_help_and_exit_if_requested
from utils.io import load_json

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger(__name__)


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Pre-flight checks for remapping.json against inventory (no API calls).",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--inventory", default="inventory", help="Inventory directory path.")
    parser.add_argument("--remapping", default="inventory/remapping.json", help="Remapping file path.")
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)


class PreFlightValidator:
    """Validates human edits in remapping.json and checks relational integrity against inventory."""

    def __init__(self, inventory_dir: Path, remapping_file: Path):
        self.inventory_dir = inventory_dir
        self.remapping_file = remapping_file
        self.errors = 0
        self.warnings = 0

    def _load_json(self, path: Path) -> Any:
        return load_json(path)

    def _policy_slug_from_target(self, target: Dict[str, Any]) -> str:
        if target.get("policySlug"):
            return target["policySlug"]
        policy_url = target.get("policyUrl") or target.get("_policyUrl") or ""
        if policy_url:
            return policy_url.rstrip("/").split("/")[-1]
        return ""

    def _is_skipped(self, mappings: Dict[str, Any], key: str) -> bool:
        return key in mappings and mappings.get(key) is None

    def validate(self) -> int:
        log.info("Starting pre-flight validation...")
        remapping = self._load_json(self.remapping_file)
        if not remapping:
            log.error(f"Remapping file not found at {self.remapping_file}")
            self.errors += 1
            return self.errors

        self._validate_formats(remapping)
        self._validate_user_emails(remapping)
        self._validate_escalation_policy_emails(remapping)
        self._validate_routing_key_policies(remapping)
        self._validate_policy_teams(remapping)
        self._validate_team_members(remapping)
        self._validate_team_admins(remapping)
        self._validate_rotation_user_refs(remapping)
        self._validate_alert_rules(remapping)

        log.info("-" * 40)
        log.info(f"Validation complete: {self.errors} errors, {self.warnings} warnings/skips.")
        if self.errors > 0:
            log.error("Validation failed. Correct errors in remapping.json before running apply.py.")
            return self.errors
        log.info("Validation passed. Ready for apply phase.")
        return 0

    def _validate_formats(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating target name/slug formats...")
        patterns = {
            "teams": re.compile(r"^[a-zA-Z0-9_-]+$"),
            "escalation_policies": re.compile(r"^[a-zA-Z0-9_-]+$"),
            "users": re.compile(r"^[a-zA-Z0-9_.@-]+$"),
            "emails": re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$"),
            "routing_keys": re.compile(r"^.+$"),
            "alert_rules": re.compile(r"^.+$"),
            "outbound_webhooks": re.compile(r"^[a-zA-Z0-9_-]+$"),
        }

        for category, mappings in remapping.items():
            if not isinstance(mappings, dict):
                continue
            pattern = patterns.get(category, re.compile(r"^.+$"))
            for source, target in mappings.items():
                if target is None:
                    self.warnings += 1
                    log.warning(f"[{category}] '{source}' is marked for SKIP.")
                    continue
                if not isinstance(target, str) or not pattern.match(target):
                    self.errors += 1
                    if category in ("teams", "escalation_policies", "outbound_webhooks"):
                        log.error(
                            f"[{category}] Invalid target slug '{target}' for source '{source}'. "
                            "Only alphanumeric, dashes, and underscores allowed."
                        )
                    else:
                        log.error(f"[{category}] Invalid format '{target}' for source '{source}'.")

    def _validate_user_emails(self, remapping: Dict[str, Any]) -> None:
        mapped_emails = remapping.get("emails")
        if not mapped_emails:
            return

        log.info("Validating user email references...")
        users = self._load_json(self.inventory_dir / "users_inventory.json") or []
        mapped_users = remapping.get("users", {})

        for user in users:
            if not isinstance(user, dict):
                continue
            username = user.get("username")
            address = user.get("email")
            if not username or not address or self._is_skipped(mapped_users, username):
                continue
            if address not in mapped_emails:
                self.errors += 1
                log.error(
                    f"[users] User '{username}' has email '{address}' "
                    "which is missing from remapping.json."
                )
            elif mapped_emails[address] is None:
                self.errors += 1
                log.error(
                    f"[users] User '{username}' has email '{address}' "
                    "which is marked to be SKIPPED."
                )

    def _validate_escalation_policy_emails(self, remapping: Dict[str, Any]) -> None:
        mapped_emails = remapping.get("emails")
        if not mapped_emails:
            return

        log.info("Validating escalation policy email references...")
        details = self._load_json(self.inventory_dir / "escalation_policy_details_inventory.json") or {}
        mapped_policies = remapping.get("escalation_policies", {})

        if not isinstance(details, dict):
            return

        for policy_slug, steps in details.items():
            if self._is_skipped(mapped_policies, policy_slug):
                continue
            if not isinstance(steps, list):
                continue
            for step in steps:
                if not isinstance(step, dict):
                    continue
                for entry in step.get("entries", []):
                    if not isinstance(entry, dict):
                        continue
                    if entry.get("executionType") != "email":
                        continue
                    address = entry.get("email", {}).get("address")
                    if not address:
                        continue
                    if address not in mapped_emails:
                        self.errors += 1
                        log.error(
                            f"[escalation_policies] Policy '{policy_slug}' uses email '{address}' "
                            "which is missing from remapping.json."
                        )
                    elif mapped_emails[address] is None:
                        self.errors += 1
                        log.error(
                            f"[escalation_policies] Policy '{policy_slug}' uses email '{address}' "
                            "which is marked to be SKIPPED."
                        )

    def _validate_routing_key_policies(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating routing key targets...")
        routing_keys = self._load_json(self.inventory_dir / "routing_keys_inventory.json") or []
        mapped_keys = remapping.get("routing_keys", {})
        mapped_policies = remapping.get("escalation_policies", {})

        for rk in routing_keys:
            if not isinstance(rk, dict):
                continue
            rk_name = rk.get("routingKey")
            if not rk_name or self._is_skipped(mapped_keys, rk_name):
                continue

            for target in rk.get("targets", []):
                if not isinstance(target, dict):
                    continue
                policy_slug = self._policy_slug_from_target(target)
                if not policy_slug:
                    continue
                if policy_slug not in mapped_policies:
                    self.errors += 1
                    log.error(
                        f"[routing_keys] '{rk_name}' targets policy '{policy_slug}' "
                        "which is missing from remapping.json."
                    )
                elif mapped_policies[policy_slug] is None:
                    self.errors += 1
                    log.error(
                        f"[routing_keys] '{rk_name}' targets policy '{policy_slug}' "
                        "which is marked to be SKIPPED."
                    )

    def _validate_policy_teams(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating escalation policy team dependencies...")
        policies_grouped = self._load_json(self.inventory_dir / "escalation_policies_inventory.json") or {}
        mapped_teams = remapping.get("teams", {})
        mapped_policies = remapping.get("escalation_policies", {})

        if not isinstance(policies_grouped, dict):
            return

        for team_slug, policies in policies_grouped.items():
            for policy_entry in policies:
                if not isinstance(policy_entry, dict):
                    continue
                policy = policy_entry.get("policy", {})
                policy_slug = policy.get("slug")
                if not policy_slug or self._is_skipped(mapped_policies, policy_slug):
                    continue
                if self._is_skipped(mapped_teams, team_slug):
                    self.errors += 1
                    log.error(
                        f"[escalation_policies] Policy '{policy_slug}' belongs to skipped team '{team_slug}'."
                    )

    def _validate_team_members(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating team member user references...")
        self._validate_team_user_refs(
            "team_members_inventory.json",
            remapping.get("teams", {}),
            remapping.get("users", {}),
            "team_members",
        )

    def _validate_team_admins(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating team admin user references...")
        self._validate_team_user_refs(
            "team_admins_inventory.json",
            remapping.get("teams", {}),
            remapping.get("users", {}),
            "team_admins",
        )

    def _validate_team_user_refs(
        self,
        inventory_file: str,
        mapped_teams: Dict[str, Any],
        mapped_users: Dict[str, Any],
        label: str,
    ) -> None:
        team_data = self._load_json(self.inventory_dir / inventory_file) or {}
        if not isinstance(team_data, dict):
            return

        for team_slug, members in team_data.items():
            if self._is_skipped(mapped_teams, team_slug):
                continue
            if not isinstance(members, list):
                continue
            for member in members:
                if not isinstance(member, dict):
                    continue
                username = member.get("username")
                if not username:
                    continue
                if username not in mapped_users:
                    self.errors += 1
                    log.error(
                        f"[{label}] Team '{team_slug}' references user '{username}' "
                        "which is missing from remapping.json."
                    )
                elif mapped_users[username] is None:
                    self.warnings += 1
                    log.warning(
                        f"[{label}] Team '{team_slug}' references user '{username}' "
                        "which is marked to be SKIPPED (apply excludes them at runtime)."
                    )

    def _validate_rotation_user_refs(self, remapping: Dict[str, Any]) -> None:
        log.info("Validating rotation shift member user references...")
        rotations_by_team = self._load_json(self.inventory_dir / "rotation_definitions_inventory.json") or {}
        mapped_teams = remapping.get("teams", {})
        mapped_users = remapping.get("users", {})

        if not isinstance(rotations_by_team, dict):
            return

        for team_slug, payload in rotations_by_team.items():
            if self._is_skipped(mapped_teams, team_slug):
                continue
            if not isinstance(payload, dict):
                continue
            for rotation in payload.get("rotations", []):
                if not isinstance(rotation, dict):
                    continue
                rotation_label = rotation.get("label", "")
                for shift in rotation.get("shifts", []):
                    if not isinstance(shift, dict):
                        continue
                    shift_label = shift.get("label", "shift")
                    for member in shift.get("shiftMembers", []):
                        if not isinstance(member, dict):
                            continue
                        username = member.get("username")
                        if not username:
                            continue
                        if username not in mapped_users:
                            self.errors += 1
                            log.error(
                                f"[rotations] Rotation '{rotation_label}' shift '{shift_label}' "
                                f"references user '{username}' which is missing from remapping.json."
                            )
                        elif mapped_users[username] is None:
                            self.warnings += 1
                            log.warning(
                                f"[rotations] Rotation '{rotation_label}' shift '{shift_label}' "
                                f"references user '{username}' which is marked to be SKIPPED "
                                "(apply excludes them at runtime)."
                            )

    def _validate_alert_rules(self, remapping: Dict[str, Any]) -> None:
        alert_rules = remapping.get("alert_rules")
        if not alert_rules:
            return

        log.info("Validating alert rule routing key references...")
        rules = self._load_json(self.inventory_dir / "alert_rules_inventory.json") or []
        mapped_rules = remapping.get("alert_rules", {})
        mapped_keys = remapping.get("routing_keys", {})

        for rule in rules:
            if not isinstance(rule, dict):
                continue
            rule_id = str(rule.get("id", ""))
            if not rule_id or self._is_skipped(mapped_rules, rule_id):
                continue
            if rule.get("alertField") != "routing_key":
                continue
            match_value = rule.get("alertValueMatch", "")
            if not match_value:
                continue
            if match_value not in mapped_keys:
                self.errors += 1
                log.error(
                    f"[alert_rules] Rule {rule_id} matches routing key '{match_value}' "
                    "which is missing from remapping.json."
                )
            elif mapped_keys[match_value] is None:
                self.errors += 1
                log.error(
                    f"[alert_rules] Rule {rule_id} matches routing key '{match_value}' "
                    "which is marked to be SKIPPED."
                )


def main(argv: list[str] | None = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    validator = PreFlightValidator(Path(args.inventory), Path(args.remapping))
    exit_code = validator.validate()
    if exit_code:
        sys.exit(exit_code)


if __name__ == "__main__":
    main()
