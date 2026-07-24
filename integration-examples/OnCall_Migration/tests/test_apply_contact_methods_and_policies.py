"""Unit tests for apply_contact_methods_and_policies.py."""

from __future__ import annotations

import json
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

os.environ.setdefault("TARGET_SPLUNK_ONCALL_API_ID", "test-id")
os.environ.setdefault("TARGET_SPLUNK_ONCALL_API_KEY", "test-key")
os.environ.setdefault("TARGET_SPLUNK_ONCALL_ORG_SLUG", "test-org")

from apply import RemappingContext
from apply_contact_methods_and_policies import DeferredMigrationClient, DeferredPipeline, main


class FakeResponse:
    def __init__(self, payload: object, status_code: int = 200):
        self.status_code = status_code
        self._payload = payload
        self.text = json.dumps(payload)

    def json(self) -> object:
        return self._payload


class DeferredMigrationClientTest(unittest.TestCase):
    def setUp(self) -> None:
        self.client = DeferredMigrationClient("test-id", "test-key", "test-org", dry_run=False)

    @mock.patch.object(DeferredMigrationClient, "post")
    def test_post_email_uses_documented_payload(self, mock_post) -> None:
        self.client.post_email("alice", {"email": "test@example.com", "label": "Work"})
        mock_post.assert_called_once_with(
            "user/alice/contact-methods/emails",
            {"email": "test@example.com", "label": "Work"},
        )

    @mock.patch.object(DeferredMigrationClient, "post")
    def test_post_phone_uses_documented_payload(self, mock_post) -> None:
        self.client.post_phone("bob", {"phone": "+1 555-0100", "label": "Phone"})
        mock_post.assert_called_once_with(
            "user/bob/contact-methods/phones",
            {"phone": "+1 555-0100", "label": "Phone"},
        )

    @mock.patch.object(DeferredMigrationClient, "post")
    def test_post_paging_policy_step_uses_profile_endpoint(self, mock_post) -> None:
        payload = {"timeout": 5, "rules": [{"type": "push"}]}
        self.client.post_paging_policy_step("bob", payload)
        mock_post.assert_called_once_with("profile/bob/policies", payload)


class DeferredPipelineTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.inventory_dir = Path(self.temp_dir.name)
        self.remapping = RemappingContext(
            {
                "users": {
                    "alice": "alice-target",
                    "bob": "bob-suffix",
                    "skipped": None,
                },
                "emails": {
                    "alice@example.com": "alice@target.example.com",
                    "alice@source.com": "alice@target.com",
                    "skip@example.com": None,
                },
            }
        )
        self.client = DeferredMigrationClient("id", "key", "target-org", dry_run=True)
        self.pipeline = DeferredPipeline(self.client, self.inventory_dir, self.remapping)

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _write_inventory(self, contact_methods: dict, paging_policies: dict) -> None:
        (self.inventory_dir / "contact_methods_inventory.json").write_text(json.dumps(contact_methods))
        (self.inventory_dir / "paging_policies_inventory.json").write_text(json.dumps(paging_policies))

    def test_dry_run_does_not_call_http(self) -> None:
        self._write_inventory(
            contact_methods={
                "alice": {
                    "emails": {
                        "contactMethods": [
                            {"value": "alice@example.com", "label": "Work"},
                            {"value": "skip@example.com", "label": "Skip Me"},
                        ]
                    },
                    "phones": {"contactMethods": [{"value": "+1 555-0100", "label": "Mobile"}]},
                    "devices": {"contactMethods": []},
                }
            },
            paging_policies={"alice": [{"order": 1, "timeout": 5, "contactType": "push"}]},
        )
        self.client.session.post = mock.MagicMock()
        with mock.patch.object(self.client.rate_limiter, "wait"):
            self.pipeline.run()
        self.client.session.post.assert_not_called()
        self.assertEqual(self.pipeline.stats["emails"]["created"], 1)
        self.assertEqual(self.pipeline.stats["emails"]["skipped"], 1)
        self.assertEqual(self.pipeline.stats["phones"]["created"], 1)
        self.assertEqual(self.pipeline.stats["paging_steps"]["created"], 1)

    def test_contact_methods_extraction_and_mapping(self) -> None:
        self._write_inventory(
            contact_methods={
                "alice": {
                    "emails": {
                        "contactMethods": [{"value": "alice@source.com", "label": "Work"}]
                    },
                    "phones": {"contactMethods": [{"value": "+1 555-0100", "label": "Cell"}]},
                    "devices": {"contactMethods": [{"value": "device-token"}]},
                }
            },
            paging_policies={},
        )
        self.client.dry_run = False
        with mock.patch.object(self.client, "get", return_value=(None, 404)):
            with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
                with mock.patch.object(self.client.rate_limiter, "wait"):
                    self.pipeline.run()

        self.assertEqual(mock_post.call_count, 2)
        mock_post.assert_any_call(
            "user/alice-target/contact-methods/emails",
            {"email": "alice@target.com", "label": "Work"},
        )
        mock_post.assert_any_call(
            "user/alice-target/contact-methods/phones",
            {"phone": "+1 555-0100", "label": "Cell"},
        )
        self.assertEqual(self.pipeline.stats["emails"]["created"], 1)
        self.assertEqual(self.pipeline.stats["phones"]["created"], 1)

    def test_skipped_user_not_processed(self) -> None:
        self._write_inventory(
            contact_methods={
                "skipped": {
                    "emails": {"contactMethods": [{"value": "x@example.com", "label": "X"}]},
                    "phones": {"contactMethods": []},
                }
            },
            paging_policies={"skipped": [{"order": 1, "timeout": 5, "contactType": "push"}]},
        )
        with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
            self.pipeline.run()
        mock_post.assert_not_called()
        self.assertEqual(self.pipeline.stats["users"]["skipped"], 1)

    def test_paging_policy_posts_profile_payload(self) -> None:
        self._write_inventory(
            contact_methods={
                "bob": {
                    "emails": {"contactMethods": []},
                    "phones": {"contactMethods": []},
                }
            },
            paging_policies={"bob": [{"order": 1, "timeout": 5, "contactType": "push"}]},
        )
        self.client.dry_run = False

        with mock.patch.object(self.client, "get", return_value=(None, 404)):
            with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
                with mock.patch.object(self.client.rate_limiter, "wait"):
                    self.pipeline.run()

        mock_post.assert_called_once_with(
            "profile/bob-suffix/policies",
            {"timeout": 5, "rules": [{"type": "push"}]},
        )
        self.assertEqual(self.pipeline.stats["paging_steps"]["created"], 1)

    def test_email_paging_step_includes_contact_id(self) -> None:
        self._write_inventory(
            contact_methods={
                "bob": {
                    "emails": {
                        "contactMethods": [{"value": "bob@example.com", "label": "Work"}]
                    },
                    "phones": {"contactMethods": []},
                }
            },
            paging_policies={"bob": [{"order": 1, "timeout": 3, "contactType": "email"}]},
        )
        self.pipeline.remapping = RemappingContext(
            {
                "users": {"bob": "bob-suffix"},
                "emails": {"bob@example.com": "bob@target.com"},
            }
        )
        self.client.dry_run = False

        def fake_get(endpoint):
            if endpoint.endswith("/contact-methods/emails"):
                return (
                    {
                        "contactMethods": [
                            {"id": 99, "value": "bob@target.com", "contactType": "Email"}
                        ]
                    },
                    200,
                )
            if endpoint.endswith("/profile/bob-suffix/policies"):
                return ({"steps": []}, 200)
            return (None, 404)

        with mock.patch.object(self.client, "get", side_effect=fake_get):
            with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
                with mock.patch.object(self.client.rate_limiter, "wait"):
                    self.pipeline.run()

        mock_post.assert_any_call(
            "profile/bob-suffix/policies",
            {"timeout": 3, "rules": [{"type": "email", "contact": {"id": 99, "type": "email"}}]},
        )

    def test_email_skipped_when_already_present_on_target(self) -> None:
        self._write_inventory(
            contact_methods={
                "alice": {
                    "emails": {
                        "contactMethods": [{"value": "alice@example.com", "label": "Work"}]
                    },
                    "phones": {"contactMethods": []},
                }
            },
            paging_policies={},
        )
        self.client.dry_run = False

        def fake_get(endpoint):
            if endpoint.endswith("/contact-methods/emails"):
                return ({"contactMethods": [{"value": "alice@target.example.com"}]}, 200)
            return (None, 404)

        with mock.patch.object(self.client, "get", side_effect=fake_get):
            with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
                with mock.patch.object(self.client.rate_limiter, "wait"):
                    self.pipeline.run()

        self.assertFalse(
            any("contact-methods/emails" in call.args[0] for call in mock_post.call_args_list)
        )
        self.assertEqual(self.pipeline.stats["emails"]["skipped"], 1)

    def test_paging_only_user_processed(self) -> None:
        self._write_inventory(
            contact_methods={},
            paging_policies={"bob": [{"order": 1, "timeout": 3, "contactType": "push"}]},
        )
        self.client.dry_run = False
        with mock.patch.object(self.client, "get", return_value=(None, 404)):
            with mock.patch.object(self.client, "post", return_value=({}, 200)) as mock_post:
                with mock.patch.object(self.client.rate_limiter, "wait"):
                    self.pipeline.run()
        mock_post.assert_called_once_with(
            "profile/bob-suffix/policies",
            {"timeout": 3, "rules": [{"type": "push"}]},
        )
        self.assertEqual(self.pipeline.stats["paging_steps"]["created"], 1)

    def test_invalid_paging_inventory_exits(self) -> None:
        self._write_inventory(
            contact_methods={},
            paging_policies={"bob": {"steps": [{"timeout": 3, "contactType": "email"}]}},
        )
        with self.assertRaises(SystemExit):
            self.pipeline.run()

    def test_build_paging_payload_requires_email_contact(self) -> None:
        payload = DeferredPipeline._build_paging_payload(
            {"timeout": 5, "contactType": "email"},
            [],
            [],
        )
        self.assertIsNone(payload)


class DeferredMainTest(unittest.TestCase):
    def test_main_exits_when_target_env_missing(self) -> None:
        with mock.patch.dict(os.environ, {}, clear=True):
            with mock.patch("apply_contact_methods_and_policies.load_dotenv", return_value=None):
                with self.assertRaises(SystemExit):
                    main([])

    @mock.patch("apply_contact_methods_and_policies.DeferredPipeline")
    def test_main_runs_pipeline(self, mock_pipeline_class) -> None:
        mock_pipeline = mock.MagicMock()
        mock_pipeline_class.return_value = mock_pipeline
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            (tmp_path / "remapping.json").write_text("{}")
            main(["--inventory", str(tmp_path), "--remapping", str(tmp_path / "remapping.json")])
        mock_pipeline.run.assert_called_once()


if __name__ == "__main__":
    unittest.main()
