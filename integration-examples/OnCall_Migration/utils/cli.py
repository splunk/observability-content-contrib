"""Shared CLI helpers for migration scripts."""

from __future__ import annotations

import argparse
import sys
from typing import Callable


def print_help_and_exit_if_requested(build_parser: Callable[[], argparse.ArgumentParser]) -> None:
    """Print argparse help and exit when -h/--help is passed.

    Lets scripts respond to help before importing heavy dependencies (e.g. requests).
    """
    if any(flag in sys.argv[1:] for flag in ("-h", "--help")):
        build_parser().parse_args()  # argparse prints help and exits
