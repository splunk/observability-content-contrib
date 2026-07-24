"""Unit tests for validate_apply.py."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from validate_apply import PreFlightValidator


class PreFlightValidatorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.inventory_dir = Path(self.temp_dir.name) / "inventory"
        self.inventory_dir.mkdir()
        self.remapping_file = Path(self.temp_dir.name) / "remapping.json"
        self._write_fixtures()

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_fixtures(self) -> None:
        (self.inventory_dir / "routing_keys_inventory.json").write_text(
            json.dumps(
                [
                    {
                        "routingKey": "ALPHA",
                        "targets": [{"policySlug": "pol-alpha", "policyName": "Alpha"}],
                    }
                ]
            )
        )
        (self.inventory_dir / "escalation_policies_inventory.json").write_text(
            json.dumps(
                {
                    "team-alpha": [
                        {"policy": {"slug": "pol-alpha", "name": "Alpha"}, "team": {"slug": "team-alpha"}}
                    ]
                }
            )
        )
        (self.inventory_dir / "team_members_inventory.json").write_text(
            json.dumps({"team-alpha": [{"username": "alice"}]})
        )
        (self.inventory_dir / "team_admins_inventory.json").write_text(
            json.dumps({"team-alpha": [{"username": "bob"}]})
        )
        (self.inventory_dir / "alert_rules_inventory.json").write_text(
            json.dumps(
                [
                    {
                        "id": 1,
                        "alertField": "routing_key",
                        "alertValueMatch": "ALPHA",
                        "rank": 1,
                    }
                ]
            )
        )
        (self.inventory_dir / "users_inventory.json").write_text(
            json.dumps([{"username": "alice", "email": "alice@example.com"}])
        )
        (self.inventory_dir / "escalation_policy_details_inventory.json").write_text(
            json.dumps(
                {
                    "pol-alpha": [
                        {
                            "timeout": 0,
                            "entries": [
                                {
                                    "executionType": "email",
                                    "email": {"address": "oncall@example.com"},
                                }
                            ],
                        }
                    ]
                }
            )
        )
        self.remapping_file.write_text(
            json.dumps(
                {
                    "users": {"alice": "alice", "bob": "bob"},
                    "emails": {
                        "alice@example.com": "alice@example.com",
                        "oncall@example.com": "oncall@example.com",
                    },
                    "teams": {"team-alpha": "team-alpha"},
                    "routing_keys": {"ALPHA": "ALPHA"},
                    "escalation_policies": {"pol-alpha": "pol-alpha"},
                    "alert_rules": {"1": "1"},
                    "outbound_webhooks": {},
                }
            )
        )

    def test_validate_passes_with_policy_slug(self) -> None:
        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertEqual(validator.validate(), 0)

    def test_validate_fails_when_policy_missing(self) -> None:
        remapping = json.loads(self.remapping_file.read_text())
        remapping["escalation_policies"] = {}
        self.remapping_file.write_text(json.dumps(remapping))

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertGreater(validator.validate(), 0)

    def test_validate_counts_skip_warnings(self) -> None:
        remapping = json.loads(self.remapping_file.read_text())
        remapping["users"]["alice"] = None
        self.remapping_file.write_text(json.dumps(remapping))

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertEqual(validator.validate(), 0)
        self.assertGreater(validator.warnings, 0)
        self.assertEqual(validator.errors, 0)

    def test_validate_warns_when_skipped_user_on_active_team(self) -> None:
        remapping = json.loads(self.remapping_file.read_text())
        remapping["users"]["bob"] = None
        self.remapping_file.write_text(json.dumps(remapping))

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertEqual(validator.validate(), 0)
        self.assertGreater(validator.warnings, 0)
        self.assertEqual(validator.errors, 0)

    def test_validate_rotation_user_refs(self) -> None:
        (self.inventory_dir / "rotation_definitions_inventory.json").write_text(
            json.dumps(
                {
                    "team-alpha": {
                        "rotations": [
                            {
                                "label": "Primary",
                                "shifts": [
                                    {
                                        "label": "Day",
                                        "shiftMembers": [{"username": "alice"}],
                                    }
                                ],
                            }
                        ]
                    }
                }
            )
        )

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertEqual(validator.validate(), 0)

    def test_validate_errors_when_user_missing_from_remapping(self) -> None:
        # A user whose email is not mapped and who is absent from remapping.users
        # must NOT be treated as skipped (aligns with RemappingContext semantics),
        # so the missing email surfaces as an error rather than being silently skipped.
        (self.inventory_dir / "users_inventory.json").write_text(
            json.dumps(
                [
                    {"username": "alice", "email": "alice@example.com"},
                    {"username": "carol", "email": "carol@example.com"},
                ]
            )
        )

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertGreater(validator.validate(), 0)

    def test_validate_fails_when_policy_email_missing(self) -> None:
        remapping = json.loads(self.remapping_file.read_text())
        remapping["emails"] = {"alice@example.com": "alice@example.com"}
        self.remapping_file.write_text(json.dumps(remapping))

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        self.assertGreater(validator.validate(), 0)

    def test_main_exits_on_failure(self) -> None:
        remapping = json.loads(self.remapping_file.read_text())
        remapping["escalation_policies"] = {}
        self.remapping_file.write_text(json.dumps(remapping))

        validator = PreFlightValidator(self.inventory_dir, self.remapping_file)
        with mock.patch.object(validator, "validate", return_value=2):
            with mock.patch("validate_apply.sys.exit") as mock_exit:
                with mock.patch("validate_apply.PreFlightValidator", return_value=validator):
                    import validate_apply

                    validate_apply.main([])
        mock_exit.assert_called_once_with(2)


if __name__ == "__main__":
    unittest.main()
