"""Unit tests for discovery.py (mocked HTTP — no live API calls)."""

from __future__ import annotations

import json
import os
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path
from unittest import mock

os.environ.setdefault("SOURCE_SPLUNK_ONCALL_API_ID", "test-id")
os.environ.setdefault("SOURCE_SPLUNK_ONCALL_API_KEY", "test-key")
os.environ.setdefault("SOURCE_SPLUNK_ONCALL_ORG_SLUG", "test-org")

from discovery import DiscoveryPipeline, VictorOpsClient
from utils.exceptions import ApiError


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


class VictorOpsClientTest(unittest.TestCase):
    def setUp(self) -> None:
        self.client = VictorOpsClient("test-id", "test-key", "test-org")

    def test_get_returns_full_dict_for_multi_list_responses(self) -> None:
        payload = {
            "devices": [{"deviceType": "push"}],
            "emails": [{"deviceType": "email"}],
            "phones": [{"deviceType": "phone"}],
        }
        self.client.session.get = mock.MagicMock(return_value=FakeResponse(payload))

        with mock.patch.object(self.client.rate_limiter, "wait"):
            result = self.client.get("user/alice/contact-methods")

        self.assertIsInstance(result, dict)
        self.assertEqual(set(result.keys()), {"devices", "emails", "phones"})

    def test_get_required_404_raises(self) -> None:
        self.client.session.get = mock.MagicMock(return_value=FakeResponse({}, status_code=404))

        with mock.patch.object(self.client.rate_limiter, "wait"):
            with self.assertRaises(ApiError):
                self.client.get("alertRules", required=True)

    def test_get_paginate_false_returns_rotation_dict(self) -> None:
        payload = {"rotations": [{"name": "primary"}]}
        self.client.session.get = mock.MagicMock(return_value=FakeResponse(payload))

        with mock.patch.object(self.client.rate_limiter, "wait"):
            result = self.client.get("team/team-a/rotations", use_v2=True, paginate=False)

        self.assertEqual(result, payload)


class DiscoveryPipelineTest(unittest.TestCase):
    def setUp(self) -> None:
        self.client = VictorOpsClient("test-id", "test-key", "test-org")
        self.pipeline = DiscoveryPipeline(self.client, Path("inventory"))

    def test_extract_list_from_bare_list(self) -> None:
        data = [{"username": "alice"}]
        self.assertEqual(self.pipeline.extract_list(data, "users"), data)

    def test_extract_list_flattens_nested_lists(self) -> None:
        data = [[{"username": "alice"}], [{"username": "bob"}]]
        result = self.pipeline.extract_list(data)
        self.assertEqual(len(result), 2)
        self.assertEqual(result[0]["username"], "alice")
        self.assertEqual(result[1]["username"], "bob")

    def test_is_override_active_without_end(self) -> None:
        now = datetime.now(timezone.utc)
        self.assertTrue(self.pipeline.is_override_active({"publicId": "o1"}, now))

    def test_is_override_active_expired(self) -> None:
        now = datetime.now(timezone.utc)
        override = {"publicId": "o2", "end": "2000-01-01T00:00:00Z"}
        self.assertFalse(self.pipeline.is_override_active(override, now))

    def test_is_override_active_invalid_end(self) -> None:
        now = datetime.now(timezone.utc)
        override = {"publicId": "o3", "end": "not-a-timestamp"}
        self.assertFalse(self.pipeline.is_override_active(override, now))

    def test_get_scheduled_overrides_groups_by_team(self) -> None:
        payload = {
            "overrides": [
                {
                    "publicId": "active-1",
                    "end": "2099-01-01T00:00:00Z",
                    "assignments": [{"team": "team-a"}, {"team": "team-b"}],
                },
                {
                    "publicId": "expired-1",
                    "end": "2000-01-01T00:00:00Z",
                    "assignments": [{"team": "team-a"}],
                },
                {
                    "publicId": "unassigned-1",
                    "end": "2099-01-01T00:00:00Z",
                    "assignments": [],
                },
            ]
        }
        self.client.get = mock.MagicMock(return_value=payload)

        grouped = self.pipeline.get_scheduled_overrides()

        self.assertIn("team-a", grouped)
        self.assertIn("team-b", grouped)
        self.assertIn("_unassigned", grouped)
        self.assertEqual(len(grouped["team-a"]), 1)
        self.assertEqual(grouped["team-a"][0]["publicId"], "active-1")

    def test_fetch_per_entity_concurrent(self) -> None:
        users = [{"username": "alice"}, {"username": "bob"}]
        self.client.get = mock.MagicMock(
            side_effect=[
                {"devices": [], "emails": [], "phones": []},
                {"devices": [], "emails": [], "phones": []},
            ]
        )

        results = self.pipeline.fetch_per_entity_concurrent(
            users, "username", lambda u: f"user/{u}/contact-methods", "user"
        )

        self.assertEqual(len(results), 2)
        self.assertIn("alice", results)
        self.assertIn("bob", results)

    def test_fetch_per_entity_concurrent_passes_paginate_false(self) -> None:
        teams = [{"slug": "team-a"}]
        self.client.get = mock.MagicMock(return_value={"rotations": [{"name": "primary"}]})

        results = self.pipeline.fetch_per_entity_concurrent(
            teams,
            "slug",
            lambda t: f"team/{t}/rotations",
            "team",
            use_v2=True,
            paginate=False,
        )

        self.client.get.assert_called_once_with(
            "team/team-a/rotations", use_v2=True, paginate=False
        )
        self.assertEqual(results["team-a"], {"rotations": [{"name": "primary"}]})

    def test_run_scoped_saves_filtered_inventory_and_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            output_dir = Path(tmp)
            pipeline = DiscoveryPipeline(
                self.client,
                output_dir,
                requested_team_slugs=["team-a"],
            )

            all_users = [
                {"username": "alice", "email": "alice@example.com"},
                {"username": "bob", "email": "bob@example.com"},
            ]
            all_teams = [
                {"slug": "team-a", "name": "Team A"},
                {"slug": "team-b", "name": "Team B"},
            ]
            policies_list = [
                {
                    "policy": {"slug": "pol-a", "name": "Policy A"},
                    "team": {"slug": "team-a"},
                },
                {
                    "policy": {"slug": "pol-b", "name": "Policy B"},
                    "team": {"slug": "team-b"},
                },
            ]

            def fake_get(endpoint, params=None, use_v2=False, paginate=True, required=False):
                if endpoint == "user":
                    return {"users": all_users}
                if endpoint == "team":
                    return {"teams": all_teams}
                if endpoint == "org/routing-keys":
                    return {
                        "routingKeys": [
                            {
                                "routingKey": "ALPHA",
                                "targets": [{"policySlug": "pol-a"}],
                            },
                            {
                                "routingKey": "BETA",
                                "targets": [{"policySlug": "pol-b"}],
                            },
                        ]
                    }
                if endpoint == "alertRules":
                    return {
                        "rules": [
                            {
                                "id": 1,
                                "alertField": "routing_key",
                                "alertValueMatch": "ALPHA",
                                "rank": 1,
                            },
                            {
                                "id": 2,
                                "alertField": "message_type",
                                "alertValueMatch": "noop",
                                "rank": 2,
                            },
                            {
                                "id": 3,
                                "alertField": "routing_key",
                                "alertValueMatch": "BETA",
                                "rank": 3,
                            },
                        ]
                    }
                if endpoint == "policies":
                    return {"policies": policies_list}
                if endpoint == "overrides":
                    return {"overrides": []}
                if endpoint == "team/team-a/members":
                    return {"members": [{"username": "alice"}]}
                if endpoint == "team/team-a/admins":
                    return {"admins": [{"username": "alice"}]}
                if endpoint == "team/team-a/rotations":
                    return {"rotations": []}
                if endpoint == "team/team-a/oncall/schedule":
                    return {"schedule": []}
                if endpoint == "user/alice/contact-methods":
                    return {"devices": [], "emails": [], "phones": []}
                if endpoint == "user/alice/policies":
                    return {"policies": []}
                if endpoint == "policies/pol-a":
                    return [
                        {
                            "timeout": 0,
                            "entries": [
                                {
                                    "executionType": "user",
                                    "user": {"username": "alice"},
                                }
                            ],
                        }
                    ]
                return None

            self.client.get = mock.MagicMock(side_effect=fake_get)

            with mock.patch.object(self.client.rate_limiter, "wait"):
                pipeline.run()

            users = json.loads((output_dir / "users_inventory.json").read_text())
            teams = json.loads((output_dir / "teams_inventory.json").read_text())
            routing_keys = json.loads((output_dir / "routing_keys_inventory.json").read_text())
            alert_rules = json.loads((output_dir / "alert_rules_inventory.json").read_text())
            metadata = json.loads((output_dir / "discovery_metadata.json").read_text())

            self.assertEqual(len(users), 1)
            self.assertEqual(users[0]["username"], "alice")
            self.assertEqual({team["slug"] for team in teams}, {"team-a"})
            self.assertEqual(len(routing_keys), 1)
            self.assertEqual(routing_keys[0]["routingKey"], "ALPHA")
            # Only the in-scope routing_key rule survives: the message_type rule and
            # the routing_key rule targeting out-of-scope BETA are both dropped.
            self.assertEqual([rule["id"] for rule in alert_rules], [1])
            self.assertEqual(metadata["scope"]["teams"], ["team-a"])
            self.assertIn("pol-a", metadata["scope"]["expanded_policies"])

            member_calls = [
                call.args[0]
                for call in self.client.get.call_args_list
                if call.args and call.args[0].startswith("team/")
            ]
            self.assertTrue(all("team-b" not in endpoint for endpoint in member_calls))
            self.assertFalse(any(call.args[0] == "user/bob/contact-methods" for call in self.client.get.call_args_list))

    def test_run_scoped_policy_routing_pulls_referenced_policy_into_scope(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            output_dir = Path(tmp)
            pipeline = DiscoveryPipeline(
                self.client,
                output_dir,
                requested_team_slugs=["team-a"],
            )

            all_users = [
                {"username": "alice", "email": "alice@example.com"},
                {"username": "bob", "email": "bob@example.com"},
            ]
            all_teams = [
                {"slug": "team-a", "name": "Team A"},
                {"slug": "team-b", "name": "Team B"},
            ]
            policies_list = [
                {"policy": {"slug": "pol-a", "name": "Policy A"}, "team": {"slug": "team-a"}},
                {"policy": {"slug": "pol-b", "name": "Policy B"}, "team": {"slug": "team-b"}},
            ]

            def fake_get(endpoint, params=None, use_v2=False, paginate=True, required=False):
                if endpoint == "user":
                    return {"users": all_users}
                if endpoint == "team":
                    return {"teams": all_teams}
                if endpoint == "org/routing-keys":
                    return {
                        "routingKeys": [
                            {"routingKey": "ALPHA", "targets": [{"policySlug": "pol-a"}]},
                            {"routingKey": "BETA", "targets": [{"policySlug": "pol-b"}]},
                        ]
                    }
                if endpoint == "alertRules":
                    return {
                        "rules": [
                            {"id": 1, "alertField": "routing_key", "alertValueMatch": "ALPHA", "rank": 1},
                            {"id": 2, "alertField": "routing_key", "alertValueMatch": "BETA", "rank": 2},
                        ]
                    }
                if endpoint == "policies":
                    return {"policies": policies_list}
                if endpoint == "overrides":
                    return {"overrides": []}
                if endpoint in ("team/team-a/members", "team/team-a/admins"):
                    return {endpoint.split("/")[-1]: [{"username": "alice"}]}
                if endpoint in ("team/team-b/members", "team/team-b/admins"):
                    return {endpoint.split("/")[-1]: [{"username": "bob"}]}
                if endpoint.endswith("/rotations"):
                    return {"rotations": []}
                if endpoint.endswith("/oncall/schedule"):
                    return {"schedule": []}
                if endpoint.endswith("/contact-methods"):
                    return {"devices": [], "emails": [], "phones": []}
                if endpoint.endswith("/policies"):
                    return {"policies": []}
                if endpoint == "policies/pol-a":
                    return [
                        {
                            "timeout": 0,
                            "entries": [
                                {
                                    "executionType": "policy_routing",
                                    "targetPolicy": {"policySlug": "pol-b"},
                                }
                            ],
                        }
                    ]
                if endpoint == "policies/pol-b":
                    return [
                        {
                            "timeout": 0,
                            "entries": [{"executionType": "user", "user": {"username": "bob"}}],
                        }
                    ]
                return None

            self.client.get = mock.MagicMock(side_effect=fake_get)

            with mock.patch.object(self.client.rate_limiter, "wait"):
                pipeline.run()

            teams = json.loads((output_dir / "teams_inventory.json").read_text())
            alert_rules = json.loads((output_dir / "alert_rules_inventory.json").read_text())
            policies = json.loads((output_dir / "escalation_policies_inventory.json").read_text())
            metadata = json.loads((output_dir / "discovery_metadata.json").read_text())

            # Closure pulls pol-b (and its team-b) into scope even though only team-a was requested.
            self.assertEqual(metadata["scope"]["teams"], ["team-a"])
            self.assertIn("pol-a", metadata["scope"]["expanded_policies"])
            self.assertIn("pol-b", metadata["scope"]["expanded_policies"])
            self.assertIn("team-b", metadata["scope"]["expanded_teams"])
            self.assertEqual({team["slug"] for team in teams}, {"team-a", "team-b"})
            team_b_policy_slugs = {entry["policy"]["slug"] for entry in policies.get("team-b", [])}
            self.assertIn("pol-b", team_b_policy_slugs)
            # pol-b details were fetched via closure, and its routing key/alert rule are now in scope.
            self.assertTrue(any(call.args and call.args[0] == "policies/pol-b" for call in self.client.get.call_args_list))
            self.assertEqual({rule["id"] for rule in alert_rules}, {1, 2})


if __name__ == "__main__":
    unittest.main()
