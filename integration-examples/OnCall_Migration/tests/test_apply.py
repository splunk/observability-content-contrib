"""Unit tests for apply.py."""

from __future__ import annotations

import json
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from apply import ApplyClient, ApplyPipeline, RemappingContext


class FakeResponse:
    def __init__(self, payload: object, status_code: int = 200):
        self.status_code = status_code
        self._payload = payload
        self.text = json.dumps(payload)

    def json(self) -> object:
        return self._payload

    def raise_for_status(self) -> None:
        if self.status_code >= 400:
            raise RuntimeError(f"HTTP {self.status_code}")


class ApplyPipelineTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.inventory_dir = Path(self.temp_dir.name)
        self.remapping = RemappingContext(
            {
                "users": {"alice": "alice"},
                "emails": {"alice@example.com": "alice@target.example.com"},
                "teams": {"team-alpha": "team-alpha"},
                "routing_keys": {"ALPHA": "ALPHA"},
                "escalation_policies": {"pol-alpha": "pol-alpha"},
                "alert_rules": {"1": "1"},
                "outbound_webhooks": {},
            }
        )
        self._write_inventory()
        self.client = ApplyClient("id", "key", "target-org", dry_run=True)
        self.pipeline = ApplyPipeline(
            self.client,
            self.inventory_dir,
            self.remapping,
            self.inventory_dir / "apply_report.json",
        )

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_inventory(self) -> None:
        fixtures = {
            "users_inventory.json": [
                {
                    "username": "alice",
                    "firstName": "Alice",
                    "lastName": "Example",
                    "email": "alice@example.com",
                }
            ],
            "teams_inventory.json": [{"slug": "team-alpha", "name": "Alpha Team"}],
            "team_members_inventory.json": {"team-alpha": [{"username": "alice"}]},
            "team_admins_inventory.json": {"team-alpha": [{"username": "alice"}]},
            "rotation_definitions_inventory.json": {
                "team-alpha": {
                    "rotations": [
                        {
                            "label": "Primary",
                            "shifts": [
                                {
                                    "label": "Day",
                                    "timezone": "UTC",
                                    "start": "2020-01-01T00:00:00Z",
                                    "duration": 7,
                                    "shifttype": "std",
                                    "mask": {"day": {}, "time": []},
                                    "shiftMembers": [{"username": "alice"}],
                                }
                            ],
                        }
                    ]
                }
            },
            "escalation_policies_inventory.json": {
                "team-alpha": [{"policy": {"slug": "pol-alpha", "name": "Alpha Policy"}}]
            },
            "escalation_policy_details_inventory.json": {
                "pol-alpha": [
                    {
                        "timeout": 0,
                        "entries": [
                            {
                                "executionType": "rotation_group",
                                "rotationGroup": {"slug": "rtg-src", "label": "Primary"},
                            }
                        ],
                    }
                ]
            },
            "routing_keys_inventory.json": [
                {"routingKey": "ALPHA", "targets": [{"policySlug": "pol-alpha"}]}
            ],
            "alert_rules_inventory.json": [
                {
                    "id": 1,
                    "alertField": "routing_key",
                    "alertValueMatch": "ALPHA",
                    "matchType": "WILDCARD",
                    "rank": 1,
                    "stopFlag": False,
                }
            ],
        }
        for name, data in fixtures.items():
            (self.inventory_dir / name).write_text(json.dumps(data))

    def test_dry_run_writes_report_without_http_posts(self) -> None:
        self.client.session.get = mock.MagicMock(return_value=FakeResponse({}, status_code=404))
        self.client.session.post = mock.MagicMock()

        report = self.pipeline.run()

        self.assertTrue(self.pipeline.report_path.exists())
        self.assertTrue(report["dry_run"])
        self.client.session.post.assert_not_called()

    def test_apply_posts_with_remapped_payload(self) -> None:
        self.client.dry_run = False

        def fake_get(url, timeout=30):
            if url.endswith("/user/alice"):
                return FakeResponse({}, status_code=404)
            if url.endswith("/team"):
                return FakeResponse([], status_code=200)
            if "/members" in url:
                return FakeResponse({"members": []}, status_code=200)
            if "/rotations" in url:
                return FakeResponse(
                    {"rotationGroups": [{"label": "Primary", "slug": "rtg-target"}]},
                    status_code=200,
                )
            if "/policies/pol-alpha" in url:
                return FakeResponse({}, status_code=404)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        posted = []

        def fake_post(url, json=None, timeout=30):
            posted.append((url, json))
            if url.endswith("/user"):
                return FakeResponse({"username": "alice"}, status_code=200)
            if url.endswith("/team"):
                return FakeResponse({"slug": "team-target", "name": "Alpha Team"}, status_code=200)
            if url.endswith("/members"):
                return FakeResponse({"members": [{"username": "alice"}]}, status_code=200)
            if "/rotations" in url:
                return FakeResponse(
                    {"rotationGroups": [{"label": "Primary", "slug": "rtg-target"}]},
                    status_code=200,
                )
            if url.endswith("/policies"):
                return FakeResponse({"slug": "pol-target"}, status_code=200)
            if url.endswith("/org/routing-keys"):
                return FakeResponse({"routingKey": "ALPHA"}, status_code=200)
            if url.endswith("/alertRules"):
                return FakeResponse({"id": 99}, status_code=200)
            return FakeResponse({}, status_code=200)

        self.client.session.post = mock.MagicMock(side_effect=fake_post)

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.run()

        user_post = next(body for url, body in posted if url.endswith("/user"))
        self.assertEqual(user_post["username"], "alice")
        self.assertEqual(user_post["email"], "alice@target.example.com")
        policy_post = next(body for url, body in posted if url.endswith("/policies"))
        self.assertEqual(policy_post["teamSlug"], "team-target")
        self.assertEqual(
            policy_post["steps"][0]["entries"][0]["rotationGroup"]["slug"],
            "rtg-target",
        )

    def test_apply_remapped_email_in_escalation_policy(self) -> None:
        policy_details = {
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
        (self.inventory_dir / "escalation_policy_details_inventory.json").write_text(
            json.dumps(policy_details)
        )
        self.pipeline.remapping = RemappingContext(
            {
                "users": {"alice": "alice"},
                "emails": {
                    "alice@example.com": "alice@target.example.com",
                    "oncall@example.com": "oncall@target.example.com",
                },
                "teams": {"team-alpha": "team-alpha"},
                "routing_keys": {"ALPHA": "ALPHA"},
                "escalation_policies": {"pol-alpha": "pol-alpha"},
                "alert_rules": {"1": "1"},
                "outbound_webhooks": {},
            }
        )
        self.client.dry_run = False

        def fake_get(url, timeout=30):
            if url.endswith("/user/alice"):
                return FakeResponse({"username": "alice"}, status_code=200)
            if url.endswith("/team"):
                return FakeResponse([], status_code=200)
            if "/members" in url:
                return FakeResponse({"members": [{"username": "alice"}]}, status_code=200)
            if "/rotations" in url:
                return FakeResponse(
                    {"rotationGroups": [{"label": "Primary", "slug": "rtg-target"}]},
                    status_code=200,
                )
            if "/policies/pol-alpha" in url:
                return FakeResponse({}, status_code=404)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        posted = []

        def fake_post(url, json=None, timeout=30):
            posted.append((url, json))
            if url.endswith("/team"):
                return FakeResponse({"slug": "team-target", "name": "Alpha Team"}, status_code=200)
            if url.endswith("/policies"):
                return FakeResponse({"slug": "pol-target"}, status_code=200)
            if url.endswith("/org/routing-keys"):
                return FakeResponse({"routingKey": "ALPHA"}, status_code=200)
            if url.endswith("/alertRules"):
                return FakeResponse({"id": 99}, status_code=200)
            return FakeResponse({}, status_code=200)

        self.client.session.post = mock.MagicMock(side_effect=fake_post)

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline._index_policy_metadata()
            self.pipeline.apply_escalation_policies()

        policy_post = next(body for url, body in posted if url.endswith("/policies"))
        self.assertEqual(
            policy_post["steps"][0]["entries"][0]["email"]["address"],
            "oncall@target.example.com",
        )

    def test_post_succeeded_counts_201_as_created(self) -> None:
        self.client.dry_run = False

        self.client.session.get = mock.MagicMock(return_value=FakeResponse({}, status_code=404))
        self.client.session.post = mock.MagicMock(
            return_value=FakeResponse({"username": "alice"}, status_code=201)
        )

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.apply_users()

        self.assertEqual(self.pipeline.stats["users"]["created"], 1)
        self.assertEqual(self.pipeline.stats["users"].get("failed", 0), 0)

    def test_escalation_policy_skips_by_remapped_slug(self) -> None:
        self.pipeline.remapping = RemappingContext(
            {
                "users": {"alice": "alice"},
                "emails": {"alice@example.com": "alice@target.example.com"},
                "teams": {"team-alpha": "team-alpha"},
                "routing_keys": {"ALPHA": "ALPHA"},
                "escalation_policies": {"pol-alpha": "pol-target"},
                "alert_rules": {"1": "1"},
                "outbound_webhooks": {},
            }
        )
        self.client.dry_run = False
        get_urls = []

        def fake_get(url, timeout=30):
            get_urls.append(url)
            if "/policies/pol-target" in url:
                return FakeResponse({"slug": "pol-target"}, status_code=200)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        self.client.session.post = mock.MagicMock()

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline._index_policy_metadata()
            self.pipeline.apply_escalation_policies()

        self.assertTrue(any("/policies/pol-target" in url for url in get_urls))
        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["escalation_policies"]["skipped"], 1)

    def test_routing_key_skipped_when_exists(self) -> None:
        self.client.dry_run = False

        def fake_get(url, timeout=30):
            if url.endswith("/org/routing-keys"):
                return FakeResponse({"routingKeys": [{"routingKey": "ALPHA"}]}, status_code=200)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        self.client.session.post = mock.MagicMock()

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.apply_routing_keys()

        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["routing_keys"]["skipped"], 1)

    def test_alert_rule_skipped_when_signature_exists(self) -> None:
        self.client.dry_run = False

        def fake_get(url, timeout=30):
            if url.endswith("/alertRules"):
                return FakeResponse(
                    {
                        "alertRules": [
                            {"alertField": "routing_key", "alertValueMatch": "ALPHA", "rank": 1}
                        ]
                    },
                    status_code=200,
                )
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        self.client.session.post = mock.MagicMock()

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.apply_alert_rules()

        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["alert_rules"]["skipped"], 1)

    def test_rotation_skips_empty_shifts_and_groups(self) -> None:
        rotations = {
            "team-alpha": {
                "rotations": [
                    {
                        "label": "Empty Group",
                        "shifts": [],
                    },
                    {
                        "label": "Filtered Shift",
                        "shifts": [
                            {
                                "label": "Night",
                                "timezone": "UTC",
                                "start": "2020-01-01T00:00:00Z",
                                "duration": 7,
                                "shifttype": "std",
                                "mask": {"day": {}, "time": []},
                                "shiftMembers": [{"username": "departed"}],
                            }
                        ],
                    },
                ]
            }
        }
        (self.inventory_dir / "rotation_definitions_inventory.json").write_text(json.dumps(rotations))
        self.pipeline.remapping = RemappingContext(
            {
                "users": {"alice": "alice", "departed": None},
                "emails": {"alice@example.com": "alice@target.example.com"},
                "teams": {"team-alpha": "team-alpha"},
                "routing_keys": {"ALPHA": "ALPHA"},
                "escalation_policies": {"pol-alpha": "pol-alpha"},
                "alert_rules": {"1": "1"},
                "outbound_webhooks": {},
            }
        )
        self.client.dry_run = False

        def fake_get(url, timeout=30):
            if "/rotations" in url:
                return FakeResponse({"rotationGroups": []}, status_code=200)
            if url.endswith("/team"):
                return FakeResponse([{"name": "Alpha Team", "slug": "team-target"}], status_code=200)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        posted = []

        def fake_post_once(url, json=None, timeout=30):
            posted.append((url, json))
            return FakeResponse({"rotationGroups": []}, status_code=200)

        self.client.post_once = mock.MagicMock(side_effect=fake_post_once)

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.team_slug_map["team-alpha"] = "team-target"
            self.pipeline.apply_rotations()

        self.client.post_once.assert_not_called()
        self.assertEqual(self.pipeline.stats["rotations"]["skipped"], 2)

    def test_escalation_policy_fails_when_rotation_unmapped(self) -> None:
        self.client.dry_run = False
        self.pipeline.rtg_slug_map = {}

        def fake_get(url, timeout=30):
            if "/policies/pol-alpha" in url:
                return FakeResponse({}, status_code=404)
            return FakeResponse({}, status_code=404)

        self.client.session.get = mock.MagicMock(side_effect=fake_get)
        self.client.session.post = mock.MagicMock()

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline._index_policy_metadata()
            self.pipeline.apply_escalation_policies()

        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["escalation_policies"]["failed"], 1)
        self.assertIn("pol-alpha", self.pipeline.failures.get("escalation_policies", []))

    def test_routing_key_skips_when_policy_unmapped(self) -> None:
        self.client.dry_run = False
        self.pipeline.policy_slug_map = {}

        self.client.session.get = mock.MagicMock(
            return_value=FakeResponse({"routingKeys": []}, status_code=200)
        )
        self.client.session.post = mock.MagicMock()

        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.apply_routing_keys()

        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["routing_keys"]["skipped"], 1)


class ApplyMainEnvTest(unittest.TestCase):
    def test_main_exits_when_target_env_missing(self) -> None:
        import apply as apply_module

        with mock.patch.dict(os.environ, {}, clear=True):
            with mock.patch("apply.load_dotenv", return_value=None):
                with mock.patch("sys.argv", ["apply.py"]):
                    with self.assertRaises(SystemExit):
                        apply_module.main()

    def test_main_runs_when_target_env_present(self) -> None:
        import apply as apply_module

        env = {
            "TARGET_SPLUNK_ONCALL_API_ID": "id",
            "TARGET_SPLUNK_ONCALL_API_KEY": "key",
            "TARGET_SPLUNK_ONCALL_ORG_SLUG": "org",
        }
        with tempfile.TemporaryDirectory() as tmp:
            inventory = Path(tmp) / "inventory"
            inventory.mkdir()
            (inventory / "users_inventory.json").write_text("[]")
            (inventory / "teams_inventory.json").write_text("[]")
            remapping = Path(tmp) / "remapping.json"
            remapping.write_text(
                json.dumps(
                    {
                        "users": {},
                        "teams": {},
                        "routing_keys": {},
                        "escalation_policies": {},
                        "alert_rules": {},
                        "outbound_webhooks": {},
                    }
                )
            )
            with mock.patch.dict(os.environ, env, clear=True):
                with mock.patch("apply.load_dotenv", return_value=Path(tmp) / ".env"):
                    with mock.patch.object(apply_module.ApplyPipeline, "run", return_value={}) as mock_run:
                        with mock.patch(
                            "sys.argv",
                            [
                                "apply.py",
                                "--inventory",
                                str(inventory),
                                "--remapping",
                                str(remapping),
                            ],
                        ):
                            apply_module.main()
            mock_run.assert_called_once()


if __name__ == "__main__":
    unittest.main()
