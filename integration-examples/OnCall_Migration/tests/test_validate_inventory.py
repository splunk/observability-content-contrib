"""Unit tests for validate_inventory.py."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from validate_inventory import InventoryValidator


class InventoryValidatorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.inventory_dir = Path(self.temp_dir.name)
        self._write_valid_inventory()

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_valid_inventory(self) -> None:
        team = {"slug": "team-alpha", "name": "Alpha"}
        per_team = {"team-alpha": []}
        rotation = {"team-alpha": {"rotations": []}}
        schedule = {"team-alpha": {"schedule": []}}

        files = {
            "teams_inventory.json": [team],
            "team_members_inventory.json": per_team,
            "team_admins_inventory.json": per_team,
            "rotation_definitions_inventory.json": rotation,
            "schedules_inventory.json": schedule,
            "routing_keys_inventory.json": [
                {"routingKey": "ALPHA", "targets": [{"policySlug": "pol-alpha"}]}
            ],
            "escalation_policy_details_inventory.json": {"pol-alpha": [{"timeout": 0, "entries": []}]},
            "discovery_metadata.json": {
                "inventory_counts": {
                    "teams_inventory": 1,
                    "team_members_inventory": 1,
                    "team_admins_inventory": 1,
                    "rotation_definitions_inventory": 1,
                    "schedules_inventory": 1,
                    "routing_keys_inventory": 1,
                    "escalation_policy_details_inventory": 1,
                },
                "files_written": [
                    {"name": "teams_inventory.json", "count": 1},
                    {"name": "team_members_inventory.json", "count": 1},
                    {"name": "team_admins_inventory.json", "count": 1},
                    {"name": "rotation_definitions_inventory.json", "count": 1},
                    {"name": "schedules_inventory.json", "count": 1},
                    {"name": "routing_keys_inventory.json", "count": 1},
                    {"name": "escalation_policy_details_inventory.json", "count": 1},
                ],
            },
        }
        for name, data in files.items():
            (self.inventory_dir / name).write_text(json.dumps(data))

    def test_validate_passes(self) -> None:
        validator = InventoryValidator(self.inventory_dir)
        self.assertEqual(validator.validate(), 0)

    def test_validate_fails_on_missing_team(self) -> None:
        data = json.loads((self.inventory_dir / "team_members_inventory.json").read_text())
        data.pop("team-alpha")
        (self.inventory_dir / "team_members_inventory.json").write_text(json.dumps(data))

        validator = InventoryValidator(self.inventory_dir)
        self.assertGreater(validator.validate(), 0)

    def test_validate_fails_on_orphan_policy(self) -> None:
        routing = [
            {"routingKey": "ALPHA", "targets": [{"policySlug": "pol-missing"}]}
        ]
        (self.inventory_dir / "routing_keys_inventory.json").write_text(json.dumps(routing))

        validator = InventoryValidator(self.inventory_dir)
        self.assertGreater(validator.validate(), 0)

    def test_validate_fails_on_corrupt_json(self) -> None:
        (self.inventory_dir / "teams_inventory.json").write_text("{ not valid json")

        validator = InventoryValidator(self.inventory_dir)
        self.assertGreater(validator.validate(), 0)

    def test_validate_warns_when_user_missing_contact_methods(self) -> None:
        (self.inventory_dir / "users_inventory.json").write_text(
            json.dumps([{"username": "alice"}, {"username": "bob"}])
        )
        (self.inventory_dir / "contact_methods_inventory.json").write_text(
            json.dumps({"alice": {"emails": {"contactMethods": []}}})
        )

        validator = InventoryValidator(self.inventory_dir)
        validator.validate()
        self.assertGreater(validator.warnings, 0)

    def test_validate_fails_when_contact_methods_orphan_user(self) -> None:
        (self.inventory_dir / "users_inventory.json").write_text(
            json.dumps([{"username": "alice"}])
        )
        (self.inventory_dir / "contact_methods_inventory.json").write_text(
            json.dumps({"ghost": {"emails": {"contactMethods": []}}})
        )

        validator = InventoryValidator(self.inventory_dir)
        self.assertGreater(validator.validate(), 0)


if __name__ == "__main__":
    unittest.main()
