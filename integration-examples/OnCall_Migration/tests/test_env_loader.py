"""Unit tests for env_loader.py."""

from __future__ import annotations

import os
import tempfile
import unittest
from pathlib import Path

from utils.env_loader import load_dotenv


class EnvLoaderTest(unittest.TestCase):
    def tearDown(self) -> None:
        for key in (
            "TEST_ENV_LOADER_KEY",
            "TEST_ENV_LOADER_QUOTED",
            "TEST_ENV_LOADER_PRESET",
        ):
            os.environ.pop(key, None)

    def test_load_dotenv_reads_values(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            env_path = Path(tmp) / ".env"
            env_path.write_text(
                "TEST_ENV_LOADER_KEY=alpha\nTEST_ENV_LOADER_QUOTED='beta'\n"
            )
            loaded = load_dotenv(env_path)
            self.assertEqual(loaded, env_path)
            self.assertEqual(os.environ.get("TEST_ENV_LOADER_KEY"), "alpha")
            self.assertEqual(os.environ.get("TEST_ENV_LOADER_QUOTED"), "beta")

    def test_load_dotenv_does_not_override_existing(self) -> None:
        os.environ["TEST_ENV_LOADER_PRESET"] = "existing"
        with tempfile.TemporaryDirectory() as tmp:
            env_path = Path(tmp) / ".env"
            env_path.write_text("TEST_ENV_LOADER_PRESET=new\n")
            load_dotenv(env_path)
            self.assertEqual(os.environ.get("TEST_ENV_LOADER_PRESET"), "existing")

    def test_load_dotenv_missing_file_returns_none(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            missing = Path(tmp) / "missing.env"
            self.assertIsNone(load_dotenv(missing))


if __name__ == "__main__":
    unittest.main()
