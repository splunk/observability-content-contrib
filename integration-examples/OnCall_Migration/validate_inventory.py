#!/usr/bin/env python3
"""
Validate on-disk inventory consistency after discovery (no API calls).

Usage:
    python3 validate_inventory.py
    python3 validate_inventory.py -h
    python3 validate_inventory.py --inventory inventory
"""

import argparse
import json
import logging
import sys
from pathlib import Path
from typing import Any

from utils.cli import print_help_and_exit_if_requested
from utils.io import load_json

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger(__name__)


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Validate on-disk inventory consistency after discovery (no API calls).",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--inventory", default="inventory", help="Inventory directory path.")
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)


TEAM_SCOPED_FILES = (
    "team_members_inventory",
    "team_admins_inventory",
    "rotation_definitions_inventory",
    "schedules_inventory",
)

# Per-team files that may legitimately omit teams (sparse): only validate shape
# and warn on keys not present in teams_inventory. Missing files are tolerated.
OPTIONAL_TEAM_SCOPED_FILES = (
    "escalation_policies_inventory",
    "scheduled_overrides_inventory",
)


class InventoryValidator:
    """Validates on-disk inventory consistency after discovery (no API calls)."""

    def __init__(self, inventory_dir: Path):
        self.inventory_dir = inventory_dir
        self.errors = 0
        self.warnings = 0

    def _load_json(self, name: str) -> Any:
        path = self.inventory_dir / f"{name}.json"
        try:
            return load_json(path)
        except json.JSONDecodeError:
            self.errors += 1
            log.error(f"Failed to parse {name}.json (invalid JSON).")
            return None

    def _count_items(self, name: str, data: Any) -> int:
        if data is None:
            return -1
        if isinstance(data, list):
            return len(data)
        if isinstance(data, dict):
            if name == "scheduled_overrides_inventory":
                return len(data)
            if name == "escalation_policy_details_inventory":
                return len(data)
            return len(data)
        return 0

    def validate(self) -> int:
        log.info("Starting inventory validation...")
        self._validate_team_coverage()
        self._validate_optional_team_coverage()
        self._validate_user_coverage()
        self._validate_scope_metadata()
        self._validate_metadata_counts()
        self._validate_routing_key_policies()
        log.info("-" * 40)
        log.info(f"Validation Complete: {self.errors} Errors, {self.warnings} Warnings.")
        if self.errors:
            log.error("Inventory validation FAILED.")
            return self.errors
        log.info("Inventory validation PASSED.")
        return 0

    def _validate_team_coverage(self) -> None:
        log.info("Checking team coverage across per-team inventories...")
        teams = self._load_json("teams_inventory") or []
        team_slugs = {t.get("slug") for t in teams if isinstance(t, dict) and t.get("slug")}

        for inventory_name in TEAM_SCOPED_FILES:
            data = self._load_json(inventory_name)
            if data is None:
                self.errors += 1
                log.error(f"Missing inventory file: {inventory_name}.json")
                continue
            if not isinstance(data, dict):
                self.errors += 1
                log.error(f"{inventory_name}.json must be a dict keyed by team slug.")
                continue
            missing = sorted(team_slugs - set(data.keys()))
            extra = sorted(set(data.keys()) - team_slugs)
            if missing:
                self.errors += 1
                log.error(f"{inventory_name}: missing {len(missing)} team(s), e.g. {missing[:3]}")
            if extra:
                self.warnings += 1
                log.warning(f"{inventory_name}: {len(extra)} key(s) not in teams_inventory.")

    def _validate_optional_team_coverage(self) -> None:
        teams = self._load_json("teams_inventory") or []
        team_slugs = {t.get("slug") for t in teams if isinstance(t, dict) and t.get("slug")}

        for inventory_name in OPTIONAL_TEAM_SCOPED_FILES:
            data = self._load_json(inventory_name)
            if data is None:
                continue
            if not isinstance(data, dict):
                self.errors += 1
                log.error(f"{inventory_name}.json must be a dict keyed by team slug.")
                continue
            extra = sorted(set(data.keys()) - team_slugs)
            if extra:
                self.warnings += 1
                log.warning(f"{inventory_name}: {len(extra)} key(s) not in teams_inventory.")

    def _validate_user_coverage(self) -> None:
        users = self._load_json("users_inventory")
        if not isinstance(users, list) or not users:
            return
        usernames = {u.get("username") for u in users if isinstance(u, dict) and u.get("username")}

        for inventory_name in ("contact_methods_inventory", "paging_policies_inventory"):
            data = self._load_json(inventory_name)
            if not isinstance(data, dict):
                continue
            keys = set(data.keys())
            missing = sorted(usernames - keys)
            orphan = sorted(keys - usernames)
            if missing:
                self.warnings += 1
                log.warning(
                    f"{inventory_name}: {len(missing)} user(s) from users_inventory "
                    f"have no entry, e.g. {missing[:3]}"
                )
            if orphan:
                self.errors += 1
                log.error(
                    f"{inventory_name}: {len(orphan)} key(s) not in users_inventory, "
                    f"e.g. {orphan[:3]}"
                )

    def _validate_scope_metadata(self) -> None:
        metadata = self._load_json("discovery_metadata")
        if not metadata or not isinstance(metadata.get("scope"), dict):
            return

        scope = metadata["scope"]
        requested = scope.get("teams") or []
        expanded = scope.get("expanded_teams") or []
        log.info("Scoped export detected in discovery_metadata.")
        if set(expanded) - set(requested):
            added = sorted(set(expanded) - set(requested))
            self.warnings += 1
            log.warning(
                "Policy closure expanded team scope beyond --teams: "
                + ", ".join(added)
            )

    def _validate_metadata_counts(self) -> None:
        log.info("Checking discovery_metadata counts...")
        metadata = self._load_json("discovery_metadata")
        if not metadata:
            self.warnings += 1
            log.warning("discovery_metadata.json not found — skipping count checks.")
            return

        counts = metadata.get("inventory_counts", {})
        files_written = {entry["name"]: entry["count"] for entry in metadata.get("files_written", [])}

        for name, expected in counts.items():
            if name == "integrations_inventory":
                continue
            data = self._load_json(name)
            if data is None:
                if expected != 0:
                    self.errors += 1
                    log.error(f"{name}.json missing but metadata count is {expected}.")
                continue
            actual = self._count_items(name, data)
            if actual != expected:
                self.errors += 1
                log.error(f"{name}: metadata count {expected} != on-disk count {actual}.")

            json_name = f"{name}.json"
            if files_written and json_name in files_written and files_written[json_name] != actual:
                self.errors += 1
                log.error(
                    f"{name}: files_written count {files_written[json_name]} != on-disk count {actual}."
                )

    def _validate_routing_key_policies(self) -> None:
        log.info("Checking routing key policy references...")
        routing_keys = self._load_json("routing_keys_inventory") or []
        policy_details = self._load_json("escalation_policy_details_inventory") or {}
        if not isinstance(policy_details, dict):
            self.errors += 1
            log.error("escalation_policy_details_inventory.json must be a dict.")
            return

        known_policies = set(policy_details.keys())
        for rk in routing_keys:
            if not isinstance(rk, dict):
                continue
            rk_name = rk.get("routingKey", "<unknown>")
            for target in rk.get("targets", []):
                if not isinstance(target, dict):
                    continue
                slug = target.get("policySlug")
                if not slug:
                    policy_url = target.get("policyUrl") or target.get("_policyUrl") or ""
                    slug = policy_url.rstrip("/").split("/")[-1] if policy_url else ""
                if slug and slug not in known_policies:
                    self.errors += 1
                    log.error(
                        f"Routing key '{rk_name}' targets policy '{slug}' "
                        "missing from escalation_policy_details_inventory."
                    )


def main(argv: list[str] | None = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    validator = InventoryValidator(Path(args.inventory))
    exit_code = validator.validate()
    if exit_code:
        sys.exit(exit_code)


if __name__ == "__main__":
    main()
