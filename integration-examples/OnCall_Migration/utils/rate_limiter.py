"""Thread-safe rate limiting for VictorOps API calls."""

from __future__ import annotations

import threading
import time


class RateLimiter:
    """Thread-safe rate limiter for VictorOps API throttling."""

    def __init__(self, rate_hz: float = 2.0):
        self.delay = 1.0 / rate_hz
        self.last_call = 0.0
        self.lock = threading.Lock()

    def wait(self) -> None:
        with self.lock:
            now = time.monotonic()
            elapsed = now - self.last_call
            if elapsed < self.delay:
                time.sleep(self.delay - elapsed)
            self.last_call = time.monotonic()
