"""Load environment variables from a .env file."""

from __future__ import annotations

import os
from pathlib import Path
from typing import Optional

PROJECT_ROOT = Path(__file__).resolve().parent.parent


def load_dotenv(path: Optional[Path] = None) -> Optional[Path]:
    """Load KEY=VALUE pairs from a .env file without overriding existing env vars.

    Defaults to PROJECT_ROOT/.env. Returns the path if the file was loaded, else None.
    """
    env_path = path or (PROJECT_ROOT / ".env")
    if not env_path.exists():
        return None

    for line in env_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        os.environ.setdefault(key, value)

    return env_path
