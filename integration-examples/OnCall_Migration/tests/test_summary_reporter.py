"""Unit tests for summary_reporter.py."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from utils.summary_reporter import SummaryReporter


class SummaryReporterTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.output_dir = Path(self.temp_dir.name)
        self.inventory_counts = {
            "users_inventory": 1,
            "teams_inventory": 1,
            "routing_keys_inventory": 1,
            "alert_rules_inventory": 1,
            "outbound_webhooks_inventory": 1,
            "scheduled_overrides_inventory": 1,
        }
        self.reporter = SummaryReporter(self.output_dir, "test-org", self.inventory_counts)
        self._write_fixtures()

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_fixtures(self) -> None:
        fixtures = {
            "teams_inventory": [
                {"name": "Alpha Team", "slug": "team-alpha", "memberCount": 2},
            ],
            "users_inventory": [
                {
                    "username": "alice",
                    "displayName": "Alice Example",
                    "email": "alice@example.com",
                },
            ],
            "routing_keys_inventory": [
                {
                    "routingKey": "ALPHA-KEY",
                    "targets": [
                        {
                            "policyName": "Alpha Policy",
                            "_teamUrl": "/api-public/v1/team/team-alpha",
                        }
                    ],
                },
            ],
            "alert_rules_inventory": [
                {
                    "rank": 1,
                    "alertField": "routing_key",
                    "alertValueMatch": "ALPHA-KEY",
                    "matchType": "WILDCARD",
                    "stopFlag": False,
                    "annotations": [
                        {
                            "fieldValue": "https://example.com/webhook?sig=secret-token",
                        }
                    ],
                },
            ],
            "outbound_webhooks_inventory": [
                {
                    "label": "Test Webhook",
                    "slug": "wh-test",
                    "url": "https://example.com/webhook?sig=secret-token",
                },
            ],
            "team_members_inventory": {
                "team-alpha": [
                    {"username": "alice"},
                    {"username": "bob"},
                ],
            },
            "team_admins_inventory": {
                "team-alpha": [{"username": "alice"}],
            },
            "rotation_definitions_inventory": {
                "team-alpha": {
                    "rotations": [
                        {"label": "Primary"},
                        {"label": "Secondary"},
                    ],
                },
            },
            "escalation_policies_inventory": {
                "team-alpha": [
                    {"policy": {"slug": "pol-1", "name": "Alpha Policy"}},
                    {"policy": {"slug": "pol-2", "name": "Backup Policy"}},
                ],
            },
            "scheduled_overrides_inventory": {
                "team-alpha": [{"publicId": "override-1"}],
            },
        }
        for name, data in fixtures.items():
            path = self.output_dir / f"{name}.json"
            path.write_text(json.dumps(data))

    def test_write_summary_writes_markdown(self) -> None:
        self.reporter.write_summary(65.0)

        summary_path = self.output_dir / "inventory_summary.md"
        self.assertTrue(summary_path.exists())
        content = summary_path.read_text()

        self.assertIn("test-org", content)
        self.assertIn("Alpha Team", content)
        self.assertIn("ALPHA-KEY", content)
        self.assertIn("| 1 |", content)
        self.assertIn("alice", content)
        self.assertIn("Alice Example", content)
        self.assertIn("Primary, Secondary", content)

    def test_write_summary_redacts_sensitive_fields(self) -> None:
        self.reporter.write_summary(65.0)
        content = (self.output_dir / "inventory_summary.md").read_text()

        self.assertNotIn("https://example.com/webhook", content)
        self.assertNotIn("secret-token", content)
        self.assertNotIn("alice@example.com", content)
        self.assertIn("Test Webhook", content)
        self.assertIn("wh-test", content)


if __name__ == "__main__":
    unittest.main()
