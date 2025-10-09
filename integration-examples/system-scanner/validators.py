import re
import os
from typing import Optional


def sanitize_command_output(output: str) -> str:
    """Sanitize command output to prevent injection"""
    if not isinstance(output, str):
        return ""
    return re.sub(r"[^\w\s.()-]", "", output)  # Added () to the allowed characters


def validate_path(path: str) -> Optional[str]:
    """Validate and normalize file path"""
    if not path or not isinstance(path, str):
        return None
    try:
        normalized_path = os.path.normpath(path)
        return normalized_path if os.path.exists(normalized_path) else None
    except Exception:
        return None


def validate_version_string(version: str) -> str:
    """Validate and clean version string"""
    if not version or not isinstance(version, str):
        return "Unknown"
    # Remove any potentially harmful characters, keeping only valid version characters
    cleaned = re.sub(r"[^\w\s.-]", "", version)
    return cleaned if cleaned else "Unknown"
