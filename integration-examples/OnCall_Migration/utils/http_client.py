"""Shared base HTTP client for VictorOps API access."""

from __future__ import annotations

from typing import Dict, List, Optional

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

from utils.rate_limiter import RateLimiter


class BaseVictorOpsClient:
    """Shared session, auth headers, retries, base URLs, and rate limiting.

    Subclasses implement their own request verbs (paginated GET, POST, etc.).
    """

    BASE_V1 = "https://api.victorops.com/api-public/v1"
    BASE_V2 = "https://api.victorops.com/api-public/v2"

    def __init__(
        self,
        api_id: str,
        api_key: str,
        org_slug: str,
        *,
        retry_total: int,
        retry_backoff: float,
        allowed_methods: List[str],
        extra_headers: Optional[Dict[str, str]] = None,
        rate_hz: float = 2.0,
    ):
        self.api_id = api_id
        self.api_key = api_key
        self.org_slug = org_slug
        self.base_v1 = self.BASE_V1
        self.base_v2 = self.BASE_V2

        self.session = requests.Session()
        retries = Retry(
            total=retry_total,
            backoff_factor=retry_backoff,
            status_forcelist=[429, 500, 502, 503, 504],
            allowed_methods=allowed_methods,
        )
        self.session.mount("https://", HTTPAdapter(max_retries=retries))
        headers = {
            "X-VO-Api-Id": api_id,
            "X-VO-Api-Key": api_key,
            "Accept": "application/json",
        }
        headers.update(extra_headers or {})
        self.session.headers.update(headers)

        self.rate_limiter = RateLimiter(rate_hz=rate_hz)

    def _url(self, endpoint: str, base: str) -> str:
        if endpoint.startswith("http"):
            return endpoint
        return f"{base}/{endpoint.lstrip('/')}"
