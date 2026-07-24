#!/usr/bin/env python3
"""
Apply deferred user settings: contact methods and paging policies.

Run after apply.py has provisioned users in the target org.
Dry-run by default. Pass --apply to execute writes.

Usage:
    python3 apply_contact_methods_and_policies.py
    python3 apply_contact_methods_and_policies.py -h
    python3 apply_contact_methods_and_policies.py --apply --inventory inventory --remapping inventory/remapping.json
"""

from __future__ import annotations

import argparse
import sys

from utils.cli import print_help_and_exit_if_requested


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Apply deferred Splunk On-Call user settings (contact methods and paging policies).",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--apply", action="store_true", help="Execute writes (default is dry-run).")
    parser.add_argument("--inventory", default="inventory", help="Inventory directory path.")
    parser.add_argument("--remapping", default="inventory/remapping.json", help="Remapping file path.")
    return parser


if __name__ == "__main__":
    print_help_and_exit_if_requested(_build_arg_parser)

import logging
import os
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from apply import RemappingContext
from utils import load_dotenv, load_json
from utils.http_client import BaseVictorOpsClient

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%H:%M:%S")
log = logging.getLogger(__name__)


class DeferredMigrationClient(BaseVictorOpsClient):
    """Client for applying contact methods and paging policies to the target org."""

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

    def get(self, endpoint: str) -> Tuple[Optional[Any], int]:
        url = self._url(endpoint, self.base_v1)
        self.rate_limiter.wait()
        resp = self.session.get(url, timeout=30)
        if resp.status_code == 404:
            return None, 404
        if resp.status_code != 200:
            log.error(f"GET {url} -> {resp.status_code}: {resp.text[:200]}")
            return None, resp.status_code
        return resp.json(), resp.status_code

    def get_emails(self, username: str) -> Tuple[Optional[Any], int]:
        return self.get(f"user/{username}/contact-methods/emails")

    def get_phones(self, username: str) -> Tuple[Optional[Any], int]:
        return self.get(f"user/{username}/contact-methods/phones")

    def get_profile_policies(self, username: str) -> Tuple[Optional[Any], int]:
        return self.get(f"profile/{username}/policies")

    def post(self, endpoint: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        url = self._url(endpoint, self.base_v1)
        self.rate_limiter.wait()
        if self.dry_run:
            log.info(f"DRY-RUN POST {url} payload={payload}")
            return {"dry_run": True, "endpoint": endpoint, "payload": payload}, 200
        resp = self.session.post(url, json=payload, timeout=30)
        if resp.status_code not in (200, 201):
            log.error(f"POST {url} -> {resp.status_code}: {resp.text[:200]}")
            return None, resp.status_code
        try:
            return resp.json(), resp.status_code
        except ValueError:
            return {}, resp.status_code

    def post_email(self, username: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        return self.post(f"user/{username}/contact-methods/emails", payload)

    def post_phone(self, username: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        return self.post(f"user/{username}/contact-methods/phones", payload)

    def post_paging_policy_step(self, username: str, payload: Dict[str, Any]) -> Tuple[Optional[Any], int]:
        return self.post(f"profile/{username}/policies", payload)


class DeferredPipeline:
    def __init__(
        self,
        client: DeferredMigrationClient,
        inventory_dir: Path,
        remapping: RemappingContext,
    ):
        self.client = client
        self.inventory_dir = inventory_dir
        self.remapping = remapping
        self.stats: Dict[str, Dict[str, int]] = {}

    def _bump(self, category: str, outcome: str) -> None:
        self.stats.setdefault(category, {"created": 0, "skipped": 0, "failed": 0, "warned": 0})
        self.stats[category][outcome] += 1

    @staticmethod
    def _contact_methods(category: Any, user: str, label: str) -> List[Dict[str, Any]]:
        if not isinstance(category, dict):
            raise ValueError(
                f"contact_methods_inventory[{user}].{label} must be a dict with contactMethods[]"
            )
        methods = category.get("contactMethods")
        if not isinstance(methods, list):
            raise ValueError(
                f"contact_methods_inventory[{user}].{label}.contactMethods must be a list"
            )
        for item in methods:
            if not isinstance(item, dict):
                raise ValueError(
                    f"contact_methods_inventory[{user}].{label}.contactMethods entries must be objects"
                )
        return methods

    @staticmethod
    def _paging_steps(raw: Any, source_user: str) -> List[Dict[str, Any]]:
        if not isinstance(raw, list):
            raise ValueError(f"paging_policies_inventory[{source_user}] must be a list of step objects")
        for step in raw:
            if not isinstance(step, dict):
                raise ValueError(f"paging_policies_inventory[{source_user}] entries must be objects")
            if step.get("contactType") is None:
                raise ValueError(
                    f"paging_policies_inventory[{source_user}] step missing contactType: {step!r}"
                )
        return raw

    @staticmethod
    def _contact_values(raw: Any) -> set:
        return {
            item["value"]
            for item in DeferredPipeline._contact_records(raw)
            if item.get("value")
        }

    @staticmethod
    def _contact_records(raw: Any) -> List[Dict[str, Any]]:
        if isinstance(raw, dict):
            items = raw.get("contactMethods")
            if not isinstance(items, list):
                return []
        elif isinstance(raw, list):
            items = raw
        else:
            items = []
        return [item for item in items if isinstance(item, dict)]

    @staticmethod
    def _existing_paging_signatures(profile_policies: Any) -> set:
        signatures: set = set()
        if not isinstance(profile_policies, dict):
            return signatures
        for step in profile_policies.get("steps", []) or []:
            if not isinstance(step, dict):
                continue
            timeout = step.get("timeout")
            for rule in step.get("rules", []) or []:
                if isinstance(rule, dict) and rule.get("type"):
                    signatures.add((timeout, rule["type"]))
        return signatures

    @staticmethod
    def _build_paging_payload(
        step: Dict[str, Any],
        email_records: List[Dict[str, Any]],
        phone_records: List[Dict[str, Any]],
    ) -> Optional[Dict[str, Any]]:
        contact_type = step.get("contactType")
        timeout = step.get("timeout", 1)
        rule: Dict[str, Any] = {"type": contact_type}

        if contact_type == "email":
            if not email_records:
                return None
            contact = email_records[0]
            rule["contact"] = {"id": contact["id"], "type": "email"}
        elif contact_type in ("phone", "sms"):
            if not phone_records:
                return None
            contact = phone_records[0]
            rule["contact"] = {"id": contact["id"], "type": "phone"}

        return {"timeout": timeout, "rules": [rule]}

    def _validate_inventories(
        self, contact_methods: Any, paging_policies: Any
    ) -> Tuple[Dict[str, Any], Dict[str, Any]]:
        if not isinstance(contact_methods, dict):
            log.critical("contact_methods_inventory.json must be a dict keyed by username.")
            sys.exit(1)
        if not isinstance(paging_policies, dict):
            log.critical("paging_policies_inventory.json must be a dict keyed by username.")
            sys.exit(1)

        for source_user, methods in contact_methods.items():
            if not isinstance(methods, dict):
                log.critical(f"contact_methods_inventory[{source_user}] must be a dict.")
                sys.exit(1)
            for label in ("emails", "phones"):
                if label in methods:
                    try:
                        self._contact_methods(methods[label], source_user, label)
                    except ValueError as exc:
                        log.critical(str(exc))
                        sys.exit(1)

        for source_user, steps in paging_policies.items():
            try:
                self._paging_steps(steps, source_user)
            except ValueError as exc:
                log.critical(str(exc))
                sys.exit(1)

        return contact_methods, paging_policies

    def _existing_for_user(self, target_user: str) -> Tuple[set, set, set, List[Dict[str, Any]], List[Dict[str, Any]]]:
        """Return existing contact values and paging signatures on the target user."""
        if self.client.dry_run:
            return set(), set(), set(), [], []

        emails_raw, _ = self.client.get_emails(target_user)
        phones_raw, _ = self.client.get_phones(target_user)
        profile_raw, _ = self.client.get_profile_policies(target_user)

        email_records = self._contact_records(emails_raw)
        phone_records = self._contact_records(phones_raw)
        existing_emails = {record["value"] for record in email_records if record.get("value")}
        existing_phones = {record["value"] for record in phone_records if record.get("value")}
        existing_paging = self._existing_paging_signatures(profile_raw)
        return existing_emails, existing_phones, existing_paging, email_records, phone_records

    def run(self) -> None:
        log.info("Loading inventory files...")
        contact_methods = load_json(self.inventory_dir / "contact_methods_inventory.json", default={})
        paging_policies = load_json(self.inventory_dir / "paging_policies_inventory.json", default={})

        if not contact_methods:
            log.warning("Contact methods inventory is empty or not found.")

        contact_methods, paging_policies = self._validate_inventories(contact_methods, paging_policies)

        source_users = sorted(set(contact_methods.keys()) | set(paging_policies.keys()))
        for source_user in source_users:
            methods = contact_methods.get(source_user, {})

            if self.remapping.is_skipped("users", source_user):
                log.info(f"Skipping user '{source_user}' (set to null in remapping).")
                self._bump("users", "skipped")
                continue
            target_user = self.remapping.map_value("users", source_user)

            log.info(f"Processing deferred items for target user: {target_user}")

            existing_emails, existing_phones, existing_paging, email_records, phone_records = (
                self._existing_for_user(target_user)
            )

            emails_category = methods.get("emails")
            if emails_category is not None:
                for email_obj in self._contact_methods(emails_category, source_user, "emails"):
                    source_email = email_obj.get("value")
                    if not source_email:
                        log.error(f"  Email entry for {source_user} missing value; aborting user.")
                        self._bump("emails", "failed")
                        continue
                    target_email = self.remapping.map_value("emails", source_email)
                    if target_email is None:
                        self._bump("emails", "skipped")
                        continue
                    if target_email in existing_emails:
                        log.info(f"  SKIP email exists for {target_user}: {target_email}")
                        self._bump("emails", "skipped")
                        continue

                    payload = {
                        "email": target_email,
                        "label": email_obj.get("label", "Default"),
                    }
                    result, status = self.client.post_email(target_user, payload)
                    if status in (200, 201) and isinstance(result, dict):
                        existing_emails.add(target_email)
                        if result.get("id") and result.get("value"):
                            email_records.append({"id": result["id"], "value": result["value"]})
                        self._bump("emails", "created")
                    else:
                        self._bump("emails", "failed")

            phones_category = methods.get("phones")
            if phones_category is not None:
                for phone_obj in self._contact_methods(phones_category, source_user, "phones"):
                    phone_number = phone_obj.get("value")
                    if not phone_number:
                        log.error(f"  Phone entry for {source_user} missing value; aborting entry.")
                        self._bump("phones", "failed")
                        continue
                    if phone_number in existing_phones:
                        log.info(f"  SKIP phone exists for {target_user}: {phone_number}")
                        self._bump("phones", "skipped")
                        continue
                    payload = {
                        "phone": phone_number,
                        "label": phone_obj.get("label", "Phone"),
                    }
                    result, status = self.client.post_phone(target_user, payload)
                    if status in (200, 201) and isinstance(result, dict):
                        existing_phones.add(phone_number)
                        if result.get("id") and result.get("value"):
                            phone_records.append({"id": result["id"], "value": result["value"]})
                        self._bump("phones", "created")
                    else:
                        self._bump("phones", "failed")

            log.debug(
                "Skipping devices for %s — push devices require user login and cannot be migrated via API.",
                target_user,
            )

            if not self.client.dry_run and (email_records or phone_records):
                emails_raw, _ = self.client.get_emails(target_user)
                phones_raw, _ = self.client.get_phones(target_user)
                email_records = self._contact_records(emails_raw)
                phone_records = self._contact_records(phones_raw)

            for step in self._paging_steps(paging_policies.get(source_user, []), source_user):
                contact_type = step.get("contactType")
                step_signature = (step.get("timeout", 1), contact_type)
                if step_signature in existing_paging:
                    log.info(f"  SKIP paging step exists for {target_user}: {step_signature}")
                    self._bump("paging_steps", "skipped")
                    continue

                payload = self._build_paging_payload(step, email_records, phone_records)
                if payload is None:
                    log.warning(
                        "Skipping paging step %s for %s — no target %s contact method available.",
                        step_signature,
                        target_user,
                        contact_type,
                    )
                    self._bump("paging_steps", "warned")
                    continue

                _, status = self.client.post_paging_policy_step(target_user, payload)
                if status in (200, 201):
                    existing_paging.add(step_signature)
                    self._bump("paging_steps", "created")
                elif contact_type == "push":
                    log.warning(
                        "Expected failure for push contactType on %s "
                        "(devices cannot be migrated via API). Skipping step.",
                        target_user,
                    )
                    self._bump("paging_steps", "warned")
                else:
                    self._bump("paging_steps", "failed")

        for category, counts in sorted(self.stats.items()):
            log.info(
                "%s: created=%d skipped=%d failed=%d warned=%d",
                category,
                counts.get("created", 0),
                counts.get("skipped", 0),
                counts.get("failed", 0),
                counts.get("warned", 0),
            )
        log.info("Deferred migration processing complete.")


def main(argv: list[str] | None = None) -> None:
    args = _build_arg_parser().parse_args(argv)

    load_dotenv()

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

    remapping_path = Path(args.remapping)
    if not remapping_path.exists():
        log.critical(f"Remapping file not found: {remapping_path}")
        sys.exit(1)

    remapping_data = load_json(remapping_path, default={})
    client = DeferredMigrationClient(
        required["TARGET_SPLUNK_ONCALL_API_ID"],
        required["TARGET_SPLUNK_ONCALL_API_KEY"],
        required["TARGET_SPLUNK_ONCALL_ORG_SLUG"],
        dry_run=not args.apply,
    )
    pipeline = DeferredPipeline(
        client,
        Path(args.inventory),
        RemappingContext(remapping_data),
    )

    mode = "APPLY" if args.apply else "DRY-RUN"
    log.info(f"Starting deferred apply pipeline ({mode}) for org '{required['TARGET_SPLUNK_ONCALL_ORG_SLUG']}'")
    pipeline.run()


if __name__ == "__main__":
    main()
