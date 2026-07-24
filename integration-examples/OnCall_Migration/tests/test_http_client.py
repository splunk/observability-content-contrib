"""Unit tests for utils.http_client.BaseVictorOpsClient."""

from __future__ import annotations

import os
import unittest

os.environ.setdefault("SOURCE_SPLUNK_ONCALL_API_ID", "test-id")
os.environ.setdefault("SOURCE_SPLUNK_ONCALL_API_KEY", "test-key")
os.environ.setdefault("SOURCE_SPLUNK_ONCALL_ORG_SLUG", "test-org")

from apply import ApplyClient
from discovery import VictorOpsClient
from utils.http_client import BaseVictorOpsClient
from utils.rate_limiter import RateLimiter


class BaseVictorOpsClientTest(unittest.TestCase):
    def setUp(self) -> None:
        self.client = BaseVictorOpsClient(
            "api-id",
            "api-key",
            "org-slug",
            retry_total=3,
            retry_backoff=1,
            allowed_methods=["GET", "POST"],
            extra_headers={"Content-Type": "application/json"},
        )

    def test_session_headers(self) -> None:
        headers = self.client.session.headers
        self.assertEqual(headers["X-VO-Api-Id"], "api-id")
        self.assertEqual(headers["X-VO-Api-Key"], "api-key")
        self.assertEqual(headers["Accept"], "application/json")
        self.assertEqual(headers["Content-Type"], "application/json")

    def test_base_urls(self) -> None:
        self.assertEqual(self.client.base_v1, BaseVictorOpsClient.BASE_V1)
        self.assertEqual(self.client.base_v2, BaseVictorOpsClient.BASE_V2)

    def test_rate_limiter(self) -> None:
        self.assertIsInstance(self.client.rate_limiter, RateLimiter)

    def test_url_joins_relative_endpoint(self) -> None:
        url = self.client._url("team/foo", self.client.base_v1)
        self.assertEqual(url, f"{BaseVictorOpsClient.BASE_V1}/team/foo")

    def test_url_passes_through_absolute(self) -> None:
        absolute = "https://example.com/next"
        self.assertEqual(self.client._url(absolute, self.client.base_v1), absolute)


class SubclassCompatibilityTest(unittest.TestCase):
    def test_victorops_client_exposes_expected_attributes(self) -> None:
        client = VictorOpsClient("test-id", "test-key", "test-org")
        self.assertIsNotNone(client.session)
        self.assertIsInstance(client.rate_limiter, RateLimiter)
        self.assertEqual(client.base_v1, BaseVictorOpsClient.BASE_V1)

    def test_apply_client_exposes_expected_attributes(self) -> None:
        client = ApplyClient("id", "key", "target-org", dry_run=True)
        self.assertIsNotNone(client.session)
        self.assertIsInstance(client.rate_limiter, RateLimiter)
        self.assertEqual(client.base_v1, BaseVictorOpsClient.BASE_V1)
        self.assertTrue(client.dry_run)


if __name__ == "__main__":
    unittest.main()
