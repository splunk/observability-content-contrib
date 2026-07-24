"""Custom exceptions for Splunk On-Call migration scripts."""

from __future__ import annotations


class MigrationError(Exception):
    """Base exception for migration pipeline failures."""


class NetworkError(MigrationError):
    """Raised when an HTTP request fails due to network or transport errors."""


class ApiError(MigrationError):
    """Raised when the VictorOps API returns an unrecoverable response."""
