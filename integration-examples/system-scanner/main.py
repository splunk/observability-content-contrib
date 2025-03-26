#!/usr/bin/env python3

"""
SystemScanner
Version 0.3
Author: Brandon Blinderman
"""

import argparse
import json
from typing import Dict, Any
from os_info import get_os_info
from runtime_versions import RuntimeFactory
from utils import ContextLogger
from health import HealthCheck
from validators import sanitize_command_output, validate_path
from datetime import datetime
from string import Template  # Using string.Template for text formatting


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="System Scanner")
    parser.add_argument(
        "--output",
        type=str,
        choices=["json", "text"],
        default="text",
        help="Output format (json or text)",
    )
    parser.add_argument(
        "--health-check", action="store_true", help="Perform system health check"
    )
    return parser.parse_args()


def format_output(data: Dict[str, Any], output_format: str) -> str:
    if output_format == "json":
        return json.dumps(data, indent=2)
    return generate_text_report(data)


def generate_text_report(data: Dict[str, Any]) -> str:
    template = """
==================================================
SYSTEM SCANNER REPORT
Generated: ${timestamp}
==================================================

${os_info}

${runtime_versions}

${otel_collector}

${kubernetes_info}

${health_check}
"""

    report_data = {
        "timestamp": get_formatted_timestamp(),
        "os_info": format_os_info(data),
        "runtime_versions": format_runtime_versions(data),
        "otel_collector": format_otel_info(data),
        "kubernetes_info": format_kubernetes_info(data),
        "health_check": format_health_check(data),
    }

    return Template(template).substitute(report_data)

def get_formatted_timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def format_os_info(data: Dict[str, Any]) -> str:
    return f"""OPERATING SYSTEM INFORMATION:
--------------------------------------------------
System: {data['os_info']['system']}
Version: {data['os_info']['version']}
Architecture: {data['os_info']['architecture']}
Flavor: {data['os_info']['flavor']}
--------------------------------------------------"""

def format_runtime_versions(data: Dict[str, Any]) -> str:
    versions = "\n".join(f"  {runtime}: {version}" for runtime, version in data["runtime_versions"].items())
    return f"""RUNTIME VERSIONS:
--------------------------------------------------
{versions}
--------------------------------------------------"""

def format_otel_info(data: Dict[str, Any]) -> str:
    otel_version = data['otel_collector']['version']
    otel_path = data['otel_collector']['path'] if data['otel_collector']['path'] else "Not found"
    return f"""OPENTELEMETRY COLLECTOR INFORMATION:
--------------------------------------------------
Version: {otel_version}
Path: {otel_path}
--------------------------------------------------"""

def format_kubernetes_info(data: Dict[str, Any]) -> str:
    if "kubernetes_info" not in data:
        return ""

    kubernetes_info_str = "KUBERNETES INFORMATION:\n"
    if "otel_configmaps" in data["kubernetes_info"]:
        otel_maps = data["kubernetes_info"]["otel_configmaps"]
        if isinstance(otel_maps, list):
            kubernetes_info_str += f"  OpenTelemetry ConfigMaps found: {len(otel_maps)}\n"
            kubernetes_info_str += "\n".join(f"  - {cm['namespace']}/{cm['name']}" for cm in otel_maps)
        else:
            kubernetes_info_str += f"  OpenTelemetry ConfigMaps: {otel_maps}\n"
    return f"{kubernetes_info_str}\n--------------------------------------------------"

def format_health_check(data: Dict[str, Any]) -> str:
    if "health_check" not in data:
        return ""

    health_check_str = "SYSTEM HEALTH:\n"
    health_check_str += "\n".join(f"  {check}: {'✓' if status else '✗'}" for check, status in data["health_check"].items())
    return f"{health_check_str}\n--------------------------------------------------"


def main():
    args = parse_arguments()
    logger = ContextLogger(__name__)

    with logger.operation_context("System Scan"):
        # Initialize health check
        health_checker = HealthCheck()

        # Collect system information
        data = {}

        # Add timestamp
        data["timestamp"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # OS Information
        os_name, os_version, os_architecture, os_flavor = get_os_info()
        data["os_info"] = {
            "system": sanitize_command_output(os_name),
            "version": sanitize_command_output(os_version),
            "architecture": sanitize_command_output(os_architecture),
            "flavor": sanitize_command_output(os_flavor),
        }

        # Runtime Versions
        factory = RuntimeFactory()
        data["runtime_versions"] = {
            "Java": sanitize_command_output(factory.get_version("java")),
            "Python": sanitize_command_output(factory.get_version("python")),
            "Node.js": sanitize_command_output(factory.get_version("node")),
        }

        # OpenTelemetry Collector Information
        otel_version, otel_path = factory.get_otel_collector_info()
        data["otel_collector"] = {
            "version": sanitize_command_output(otel_version),
            "path": validate_path(otel_path) if otel_path else None,
        }

        # K8S Information
        if factory.is_running_in_kubernetes():
            data["kubernetes_info"] = {"otel_configmaps": factory.get_otel_configmaps()}

        # Health Check if requested
        if args.health_check:
            data["health_check"] = health_checker.check_system_resources()

        # Output results
        output = format_output(data, args.output)
        print(output)


if __name__ == "__main__":
    main()
