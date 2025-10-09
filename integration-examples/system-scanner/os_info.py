"""
SystemScanner: OS Information Module

This module provides functionality to retrieve detailed information
about the operating system on which the script is running.

It includes functions to get the system name, release version,
and architecture.
"""

import platform
import sys


def get_os_info():
    system = platform.system()
    release = platform.release()
    architecture = platform.machine()
    os_flavor = ""

    # Add OS flavor information focusing on the [0] output of platform
    if system == "Darwin":  # macOS
        os_flavor = f"macOS {platform.mac_ver()[0]}"
    elif system == "Linux":
        try:
            # Use platform.freedesktop_os_release() if available (Python 3.8+)
            if sys.version_info >= (3, 8):
                os_info = platform.freedesktop_os_release()
                if os_info.get("PRETTY_NAME"):
                    os_flavor = f"Linux {os_info['PRETTY_NAME']}"
                elif os_info.get("NAME"):
                    os_flavor = f"Linux {os_info['NAME']}"
                else:
                    os_flavor = "Linux"
            else:
                # Fallback to reading /etc/os-release (for Python < 3.8)
                with open("/etc/os-release") as f:
                    for line in f:
                        if line.startswith("PRETTY_NAME="):
                            os_flavor = line.split("=")[1].strip().strip('"')
                            break
        except:
            os_flavor = "Linux"
    elif system == "Windows":
        os_flavor = f"Windows {platform.win32_ver()[0]}"

    return system, release, architecture, os_flavor
