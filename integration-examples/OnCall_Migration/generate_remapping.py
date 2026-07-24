#!/usr/bin/env python3
"""
Build inventory/remapping.json from discovery inventory files.

Usage:
    python3 generate_remapping.py
    python3 generate_remapping.py -h
    python3 generate_remapping.py --inventory inventory --remapping inventory/remapping.json
"""

import argparse
import json
import logging
from pathlib import Path
from typing import Any, Dict

from utils.cli import print_help_and_exit_if_requested
from utils.io import load_json

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%H:%M:%S")
log = logging.getLogger(__name__)


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Build remapping.json from discovery inventory files.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--inventory", default="inventory", help="Inventory directory path.")
    parser.add_argument("--remapping", default="inventory/remapping.json", help="Remapping output file path.")
    parser.add_argument(
        "--username-suffix",
        default="",
        help="Suffix appended to target usernames for global uniqueness (e.g. --username-suffix=-splunk).",
    )
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)


class RemappingGenerator:
    """Generates a remapping.json template from the discovery inventory."""

    def __init__(self, inventory_dir: Path, output_file: Path, username_suffix: str = ""):
        self.inventory_dir = inventory_dir
        self.output_file = output_file
        self.username_suffix = username_suffix

    def _load_json(self, filename: str) -> Any:
        return load_json(self.inventory_dir / filename, default=[], logger=log)

    def _collect_emails(self, users: Any, policy_details: Any, contact_methods: Any = None) -> Dict[str, str]:
        emails: Dict[str, str] = {}

        if isinstance(users, list):
            for user in users:
                if not isinstance(user, dict):
                    continue
                address = user.get("email")
                if address:
                    emails[address] = address

        if isinstance(contact_methods, dict):
            for methods in contact_methods.values():
                if not isinstance(methods, dict):
                    continue
                email_category = methods.get("emails")
                if not isinstance(email_category, dict):
                    continue
                for method in email_category.get("contactMethods", []) or []:
                    if not isinstance(method, dict):
                        continue
                    address = method.get("value")
                    if address:
                        emails.setdefault(address, address)

        if isinstance(policy_details, dict):
            for steps in policy_details.values():
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
                        if address:
                            emails[address] = address

        return emails

    def generate(self) -> Dict[str, Dict[str, str]]:
        remapping = {
            "users": {},
            "emails": {},
            "teams": {},
            "routing_keys": {},
            "escalation_policies": {},
            "alert_rules": {},
            "outbound_webhooks": {},
        }

        users = self._load_json("users_inventory.json")
        for u in users:
            if isinstance(u, dict) and "username" in u:
                remapping["users"][u["username"]] = f"{u['username']}{self.username_suffix}"

        policy_details = self._load_json("escalation_policy_details_inventory.json")
        contact_methods = self._load_json("contact_methods_inventory.json")
        remapping["emails"] = self._collect_emails(users, policy_details, contact_methods)

        teams = self._load_json("teams_inventory.json")
        for t in teams:
            if isinstance(t, dict) and "slug" in t:
                remapping["teams"][t["slug"]] = t["slug"]

        routing_keys = self._load_json("routing_keys_inventory.json")
        for rk in routing_keys:
            if isinstance(rk, dict) and "routingKey" in rk:
                remapping["routing_keys"][rk["routingKey"]] = rk["routingKey"]

        policies_grouped = self._load_json("escalation_policies_inventory.json")
        if isinstance(policies_grouped, dict):
            for _team_slug, policies in policies_grouped.items():
                for p in policies:
                    policy = p.get("policy", {})
                    slug = policy.get("slug")
                    if slug:
                        remapping["escalation_policies"][slug] = slug

        alert_rules = self._load_json("alert_rules_inventory.json")
        for rule in alert_rules:
            if isinstance(rule, dict) and rule.get("id") is not None:
                remapping["alert_rules"][str(rule["id"])] = str(rule["id"])

        webhooks = self._load_json("outbound_webhooks_inventory.json")
        for wh in webhooks:
            if isinstance(wh, dict) and wh.get("slug"):
                remapping["outbound_webhooks"][wh["slug"]] = wh["slug"]

        self.output_file.parent.mkdir(parents=True, exist_ok=True)
        with self.output_file.open("w") as f:
            json.dump(remapping, f, indent=2)

        log.info(f"Generated remapping template at {self.output_file}")
        log.info(
            "Counts: %d users, %d emails, %d teams, %d routing keys, %d policies, %d alert rules, %d webhooks.",
            len(remapping["users"]),
            len(remapping["emails"]),
            len(remapping["teams"]),
            len(remapping["routing_keys"]),
            len(remapping["escalation_policies"]),
            len(remapping["alert_rules"]),
            len(remapping["outbound_webhooks"]),
        )

        return remapping


def main(argv: list[str] | None = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    generator = RemappingGenerator(Path(args.inventory), Path(args.remapping), args.username_suffix)
    generator.generate()


if __name__ == "__main__":
    main()
