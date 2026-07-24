"""Unit tests for utils.rate_limiter."""

from __future__ import annotations

import unittest
from unittest import mock

from utils.rate_limiter import RateLimiter


class RateLimiterTest(unittest.TestCase):
    @mock.patch("utils.rate_limiter.time.sleep")
    @mock.patch("utils.rate_limiter.time.monotonic")
    def test_wait_enforces_minimum_spacing(self, mock_monotonic: mock.Mock, mock_sleep: mock.Mock) -> None:
        mock_monotonic.side_effect = [1.0, 1.0, 1.1, 1.1]
        limiter = RateLimiter(rate_hz=2.0)

        limiter.wait()
        limiter.wait()

        mock_sleep.assert_called_once()
        self.assertAlmostEqual(mock_sleep.call_args[0][0], 0.4)


if __name__ == "__main__":
    unittest.main()
