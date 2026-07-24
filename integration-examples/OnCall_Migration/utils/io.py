"""Shared JSON loading helper for migration scripts."""

from __future__ import annotations

import json
import logging
from pathlib import Path
from typing import Any, Optional


def load_json(path: Path, default: Any = None, *, logger: Optional[logging.Logger] = None) -> Any:
    """Load JSON from ``path``.

    Returns ``default`` when the file is missing. When ``logger`` is provided,
    a missing file is logged at warning level and a parse error is logged at
    error level and returns ``default``; without a logger, parse errors propagate.
    """
    if not path.exists():
        if logger:
            logger.warning(f"File not found: {path}")
        return default
    try:
        with path.open("r") as f:
            return json.load(f)
    except json.JSONDecodeError:
        if logger:
            logger.error(f"Failed to parse {path}")
            return default
        raise
