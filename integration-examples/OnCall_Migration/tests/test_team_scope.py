"""Unit tests for utils/team_scope.py."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from utils.team_scope import (
    collect_usernames,
    expand_policy_closure,
    filter_alert_rules,
    filter_routing_keys,
    parse_teams_arg,
    parse_teams_file,
    unknown_team_slugs,
)


class TeamScopeTest(unittest.TestCase):
    def test_parse_teams_arg_splits_and_strips(self) -> None:
        self.assertEqual(parse_teams_arg("a, b ,c"), ["a", "b", "c"])

    def test_parse_teams_file_skips_comments_and_blanks(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "teams.txt"
            path.write_text("# header\nteam-one\n\n# another\nteam-two\n")
            self.assertEqual(parse_teams_file(path), ["team-one", "team-two"])

    def test_unknown_team_slugs(self) -> None:
        teams = [{"slug": "team-a", "name": "A"}, {"slug": "team-b", "name": "B"}]
        self.assertEqual(unknown_team_slugs(["team-a", "missing"], teams), ["missing"])

    def test_collect_usernames_from_members_and_rotations(self) -> None:
        members = {"team-a": {"members": [{"username": "alice"}]}}
        rotations = {
            "team-a": {
                "rotations": [
                    {
                        "shifts": [
                            {"shiftMembers": [{"username": "bob"}]},
                        ]
                    }
                ]
            }
        }
        self.assertEqual(
            collect_usernames(members, rotations, {"team-a"}),
            {"alice", "bob"},
        )

    def test_collect_usernames_includes_admins(self) -> None:
        members = {"team-a": {"members": [{"username": "alice"}]}}
        admins = {"team-a": {"admins": [{"username": "carol"}]}}
        self.assertEqual(
            collect_usernames(members, {}, {"team-a"}, admins_by_team=admins),
            {"alice", "carol"},
        )

    def test_collect_usernames_includes_policy_user_steps(self) -> None:
        members = {"team-a": {"members": [{"username": "alice"}]}}
        details = {
            "pol-a": [
                {
                    "entries": [
                        {"executionType": "user", "user": {"username": "dave"}},
                        {"executionType": "email", "email": {"address": "x@example.com"}},
                    ]
                }
            ],
            "pol-out-of-scope": [
                {"entries": [{"executionType": "user", "user": {"username": "eve"}}]}
            ],
        }
        result = collect_usernames(
            members,
            {},
            {"team-a"},
            policy_details=details,
            policy_slugs={"pol-a"},
        )
        self.assertEqual(result, {"alice", "dave"})

    def test_expand_policy_closure_transitive(self) -> None:
        details = {
            "pol-a": [
                {
                    "entries": [
                        {
                            "executionType": "policy_routing",
                            "targetPolicy": {"policySlug": "pol-b"},
                        }
                    ]
                }
            ],
            "pol-b": [
                {
                    "entries": [
                        {
                            "executionType": "policy_routing",
                            "targetPolicy": {"policySlug": "pol-c"},
                        }
                    ]
                }
            ],
            "pol-c": [{"entries": [{"executionType": "user", "user": {"username": "alice"}}]}],
        }
        expanded = expand_policy_closure(details, {"pol-a"})
        self.assertEqual(expanded, {"pol-a", "pol-b", "pol-c"})

    def test_filter_routing_keys_by_policy_slug(self) -> None:
        routing_keys = [
            {
                "routingKey": "ALPHA",
                "targets": [{"policySlug": "pol-a"}, {"policySlug": "pol-other"}],
            },
            {"routingKey": "BETA", "targets": [{"policySlug": "pol-other"}]},
        ]
        filtered = filter_routing_keys(routing_keys, {"pol-a"})
        self.assertEqual(len(filtered), 1)
        self.assertEqual(filtered[0]["routingKey"], "ALPHA")
        self.assertEqual(filtered[0]["targets"], [{"policySlug": "pol-a"}])

    def test_filter_alert_rules_by_routing_key_match(self) -> None:
        rules = [
            {"id": 1, "alertField": "routing_key", "alertValueMatch": "ALPHA", "rank": 1},
            {"id": 2, "alertField": "message_type", "alertValueMatch": "ALPHA", "rank": 2},
            {"id": 3, "alertField": "routing_key", "alertValueMatch": "OTHER", "rank": 3},
        ]
        filtered = filter_alert_rules(rules, {"ALPHA"})
        self.assertEqual([rule["id"] for rule in filtered], [1])


if __name__ == "__main__":
    unittest.main()
