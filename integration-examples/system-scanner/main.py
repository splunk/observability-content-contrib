#!/usr/bin/env python3

"""
SystemScanner
Version 0.2
Author: Brandon Blinderman
"""

from os_info import get_os_info
from runtime_versions import RuntimeFactory
from dotnet_framework import get_dotnet_versions
import logging


def print_separator():
    print("-" * 50)


def main():
    # Set up logging for debug purposes, but don't use it for main output
    logging.basicConfig(
        level=logging.DEBUG, filename="system_scanner.log", filemode="w"
    )
    logger = logging.getLogger(__name__)

    print("=" * 50)
    print("SYSTEM SCANNER REPORT")
    print("=" * 50)
    print()

    # Operating System Information
    os_name, os_version, os_architecture = get_os_info()
    print("OPERATING SYSTEM INFORMATION:")
    print(f"  System: {os_name}")
    print(f"  Version: {os_version}")
    print(f"  Architecture: {os_architecture}")

    print_separator()

    # Runtime Versions
    factory = RuntimeFactory()
    print("RUNTIME VERSIONS:")

    java_version = factory.get_version("java")
    print(f"  Java: {java_version}")

    python_version = factory.get_version("python")
    print(f"  Python: {python_version}")

    node_version = factory.get_version("node")
    print(f"  Node.js: {node_version}")

    print_separator()

    # OpenTelemetry Collector Information
    print("OPENTELEMETRY COLLECTOR INFORMATION:")
    otel_version, otel_path = factory.get_otel_collector_info()
    print(f"  Version: {otel_version}")
    print(f"  Path: {otel_path if otel_path else 'Not found'}")

    print_separator()

    # .NET Framework Versions (Windows only)
    if os_name == "Windows":
        print(".NET FRAMEWORK VERSIONS:")
        dotnet_versions = get_dotnet_versions()
        if isinstance(dotnet_versions, list):
            for name, version in dotnet_versions:
                print(f"  {name}: {version}")
        else:
            print(f"  Error: {dotnet_versions}")

    print()
    print("=" * 50)
    print("END OF SYSTEM SCANNER REPORT")
    print("=" * 50)


if __name__ == "__main__":
    main()
