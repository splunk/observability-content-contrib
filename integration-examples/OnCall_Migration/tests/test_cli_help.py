"""Smoke tests that pipeline scripts expose argparse -h/--help."""

import subprocess
import sys
import unittest
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent

PIPELINE_SCRIPTS = (
    "discovery.py",
    "validate_inventory.py",
    "generate_remapping.py",
    "validate_apply.py",
    "apply.py",
    "apply_contact_methods_and_policies.py",
)


class TestCliHelp(unittest.TestCase):
    def test_help_exits_zero(self) -> None:
        for script in PIPELINE_SCRIPTS:
            with self.subTest(script=script):
                result = subprocess.run(
                    [sys.executable, str(PROJECT_ROOT / script), "-h"],
                    cwd=PROJECT_ROOT,
                    capture_output=True,
                    text=True,
                    check=False,
                )
                self.assertEqual(result.returncode, 0, msg=result.stderr)
                combined = (result.stdout + result.stderr).lower()
                self.assertTrue(
                    "usage:" in combined or "options:" in combined,
                    msg=f"{script} -h did not print argparse help",
                )


if __name__ == "__main__":
    unittest.main()
