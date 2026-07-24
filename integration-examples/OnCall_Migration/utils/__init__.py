"""Shared utilities for Splunk On-Call migration scripts.

Only dependency-light helpers are re-exported here. The HTTP client
(`utils.http_client`) imports `requests` and is intentionally not re-exported,
so importing `utils` stays safe before heavy dependencies are available
(e.g. for `-h`/`--help` handling).
"""

from utils.cli import print_help_and_exit_if_requested
from utils.env_loader import PROJECT_ROOT, load_dotenv
from utils.exceptions import ApiError, MigrationError, NetworkError
from utils.io import load_json
from utils.rate_limiter import RateLimiter

__all__ = [
    "PROJECT_ROOT",
    "ApiError",
    "MigrationError",
    "NetworkError",
    "RateLimiter",
    "load_dotenv",
    "load_json",
    "print_help_and_exit_if_requested",
]
