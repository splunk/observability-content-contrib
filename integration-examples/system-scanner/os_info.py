"""
SystemScanner: OS Information Module

This module provides functionality to retrieve detailed information
about the operating system on which the script is running.

It includes functions to get the system name, release version,
and architecture.
"""

import platform
# import subprocess


def get_os_info():
    system = platform.system()
    release = platform.release()
    architecture = platform.machine()

    return system, release, architecture


## Leaving this for a future upgrade.

# def get_os_info():
#     system = platform.system()
#     version = platform.release()
#     detailed_version = ""

#     if system == "Darwin":  # macOS
#         mac_version = platform.mac_ver()[0]
#         detailed_version = f"macOS {mac_version}"
#     elif system == "Linux":
#         try:
#             # Try to get the distribution name and version
#             distro = subprocess.check_output(["lsb_release", "-ds"]).decode().strip()
#             detailed_version = distro
#         except:
#             # If lsb_release is not available, try reading from /etc/os-release
#             try:
#                 with open("/etc/os-release") as f:
#                     lines = f.readlines()
#                     for line in lines:
#                         if line.startswith("PRETTY_NAME="):
#                             detailed_version = line.split("=")[1].strip().strip('"')
#                             break
#             except:
#                 detailed_version = "Unknown Linux distribution"
#     elif system == "Windows":
#         win_version = platform.win32_ver()
#         detailed_version = f"Windows {win_version[0]} {win_version[1]}"
#     else:
#         detailed_version = f"Unknown OS: {system} {version}"

#     return system, version, detailed_version

# def main():
#     system, version, detailed_version = get_os_info()
#     print(f"Operating System: {system}")
#     print(f"Kernel Version: {version}")
#     print(f"Detailed Version: {detailed_version}")

# if __name__ == "__main__":
#     main()
