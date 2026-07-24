"""Unit tests for generate_remapping.py."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from generate_remapping import RemappingGenerator


class RemappingGeneratorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.inventory_dir = Path(self.temp_dir.name) / "inventory"
        self.inventory_dir.mkdir()
        self.output_file = Path(self.temp_dir.name) / "remapping.json"
        self._write_inventory()

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_inventory(self) -> None:
        fixtures = {
            "users_inventory.json": [
                {"username": "alice", "displayName": "Alice", "email": "alice@example.com"}
            ],
            "teams_inventory.json": [{"slug": "team-alpha", "name": "Alpha"}],
            "routing_keys_inventory.json": [{"routingKey": "ALPHA"}],
            "escalation_policies_inventory.json": {
                "team-alpha": [{"policy": {"slug": "pol-alpha", "name": "Alpha"}}]
            },
            "escalation_policy_details_inventory.json": {
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
            },
            "alert_rules_inventory.json": [{"id": 42, "rank": 1, "alertField": "routing_key"}],
            "outbound_webhooks_inventory.json": [{"slug": "wh-test", "label": "Test"}],
            "contact_methods_inventory.json": {
                "alice": {
                    "emails": {
                        "contactMethods": [
                            {"value": "alice@example.com", "label": "Default"},
                            {"value": "alice.alt@example.com", "label": "Alt"},
                        ]
                    },
                    "phones": {"contactMethods": []},
                }
            },
        }
        for name, data in fixtures.items():
            (self.inventory_dir / name).write_text(json.dumps(data))

    def test_generate_all_categories(self) -> None:
        generator = RemappingGenerator(self.inventory_dir, self.output_file)
        result = generator.generate()

        self.assertEqual(result["users"]["alice"], "alice")
        self.assertEqual(result["emails"]["alice@example.com"], "alice@example.com")
        self.assertEqual(result["emails"]["oncall@example.com"], "oncall@example.com")
        self.assertEqual(result["teams"]["team-alpha"], "team-alpha")
        self.assertEqual(result["routing_keys"]["ALPHA"], "ALPHA")
        self.assertEqual(result["escalation_policies"]["pol-alpha"], "pol-alpha")
        self.assertEqual(result["alert_rules"]["42"], "42")
        self.assertEqual(result["outbound_webhooks"]["wh-test"], "wh-test")
        self.assertEqual(result["emails"]["alice.alt@example.com"], "alice.alt@example.com")
        self.assertTrue(self.output_file.exists())

    def test_username_suffix_appended_to_target(self) -> None:
        generator = RemappingGenerator(self.inventory_dir, self.output_file, username_suffix="-splunk")
        result = generator.generate()

        self.assertEqual(result["users"]["alice"], "alice-splunk")
        self.assertEqual(result["emails"]["alice@example.com"], "alice@example.com")


if __name__ == "__main__":
    unittest.main()
