"""Unit tests for utils.io.load_json."""

from __future__ import annotations

import json
import logging
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from utils.io import load_json


class LoadJsonTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.base = Path(self.temp_dir.name)

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def test_missing_file_returns_default_none(self) -> None:
        result = load_json(self.base / "missing.json")
        self.assertIsNone(result)

    def test_missing_file_returns_custom_default(self) -> None:
        result = load_json(self.base / "missing.json", default=[])
        self.assertEqual(result, [])

    def test_missing_file_with_logger_logs_warning(self) -> None:
        logger = mock.MagicMock(spec=logging.Logger)
        path = self.base / "missing.json"

        result = load_json(path, default=[], logger=logger)

        self.assertEqual(result, [])
        logger.warning.assert_called_once()
        self.assertIn(str(path), logger.warning.call_args[0][0])

    def test_valid_json_returns_parsed_object(self) -> None:
        path = self.base / "data.json"
        path.write_text(json.dumps({"users": ["alice"]}))

        result = load_json(path)

        self.assertEqual(result, {"users": ["alice"]})

    def test_invalid_json_without_logger_raises(self) -> None:
        path = self.base / "bad.json"
        path.write_text("{not valid json")

        with self.assertRaises(json.JSONDecodeError):
            load_json(path)

    def test_invalid_json_with_logger_returns_default(self) -> None:
        path = self.base / "bad.json"
        path.write_text("{not valid json")
        logger = mock.MagicMock(spec=logging.Logger)

        result = load_json(path, default=[], logger=logger)

        self.assertEqual(result, [])
        logger.error.assert_called_once()
        self.assertIn(str(path), logger.error.call_args[0][0])


if __name__ == "__main__":
    unittest.main()
