"""
SystemScanner: Runtime Versions Module

This module is responsible for detecting and reporting versions
of various runtime environments installed on the system, such as
Java, Python, and Node.js.

It uses a factory pattern to manage different runtime version checks.
"""

import os
import json
import sys
import subprocess


class RuntimeFactory:
    def __init__(self):
        self.executors = {
            "java": ["java", "-version"],
            "node": ["node", "-v"],
            "python": lambda: f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro} (Current Shell Environment)",
        }

    def get_version(self, runtime_name):
        command = self.executors.get(runtime_name)
        if callable(command):
            return command()
        elif command:
            return self.execute_command(command)
        return f"{runtime_name} not supported"

    def execute_command(self, command):
        try:
            result = subprocess.run(
                command, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, check=True
            )
            return result.stdout.decode().strip()
        except subprocess.CalledProcessError as e:
            return f"Command failed: {e}"
        except FileNotFoundError:
            return f"{command[0]} not found"

    def get_otel_collector_info(self):
        try:
            # Check for otelcol executable
            if os.name == "nt":  # Windows
                result = subprocess.run(
                    ["where", "otelcol"], capture_output=True, text=True
                )
                if result.returncode == 0:
                    otelcol_path = result.stdout.strip().split("\n")[0]
                else:
                    return "OpenTelemetry Collector not found", None
            else:  # Unix-like systems
                if os.path.exists("/usr/bin/otelcol"):
                    otelcol_path = "/usr/bin/otelcol"
                else:
                    result = subprocess.run(
                        ["which", "otelcol"], capture_output=True, text=True
                    )
                    if result.returncode == 0:
                        otelcol_path = result.stdout.strip()
                    else:
                        return "OpenTelemetry Collector not found", None

            # Try to get version
            try:
                version_result = subprocess.run(
                    [otelcol_path, "--version"],
                    capture_output=True,
                    text=True,
                    timeout=5,
                )
                if version_result.returncode == 0:
                    # Extract just the version number
                    version_output = version_result.stdout.strip().split("\n")[0]
                    # Extract just the version part (vX.Y.Z)
                    import re

                    version_match = re.search(r"v\d+\.\d+\.\d+", version_output)
                    if version_match:
                        version = version_match.group(0)
                    else:
                        version = version_output
                    return version, otelcol_path
                else:
                    return (
                        "Unable to determine OpenTelemetry Collector version",
                        otelcol_path,
                    )
            except (subprocess.TimeoutExpired, subprocess.SubprocessError):
                return (
                    "Error running OpenTelemetry Collector version command",
                    otelcol_path,
                )

        except Exception as e:
            return f"Error getting OpenTelemetry Collector info: {str(e)}", None

    def is_running_in_kubernetes(self):
        """Check if we're running inside a Kubernetes environment"""
        k8s_indicators = [
            os.path.exists("/var/run/secrets/kubernetes.io/serviceaccount/token"),
            "KUBERNETES_SERVICE_HOST" in os.environ,
            "KUBERNETES_PORT" in os.environ
        ]
        return any(k8s_indicators)

    def get_otel_configmaps(self):
        """Get OpenTelemetry collector ConfigMaps using only standard libraries"""
        if not self.is_running_in_kubernetes():
            return "Not running in a Kubernetes environment"

        try:
            # Use kubectl command through subprocess
            result = subprocess.run(
                ["kubectl", "get", "configmap", "--all-namespaces", "-o", "json"],
                capture_output=True,
                text=True,
                check=True,
            )

            configmaps = json.loads(result.stdout)
            otel_configmaps = []

            # Filter for OpenTelemetry related ConfigMaps
            for item in configmaps.get("items", []):
                name = item.get("metadata", {}).get("name", "")
                namespace = item.get("metadata", {}).get("namespace", "")

                # Look for common OpenTelemetry ConfigMap naming patterns
                if any(
                    pattern in name.lower()
                    for pattern in ["otel", "opentelemetry", "collector"]
                ):
                    otel_configmaps.append(
                        {
                            "name": name,
                            "namespace": namespace,
                            "data": item.get("data", {}),
                        }
                    )

            return otel_configmaps

        except subprocess.CalledProcessError as e:
            return f"Error executing kubectl: {e.stderr}"
        except json.JSONDecodeError:
            return "Error parsing kubectl output"
        except Exception as e:
            return f"Unexpected error: {str(e)}"
