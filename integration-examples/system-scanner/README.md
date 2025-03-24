# SystemScanner

This project is designed to check and report information about the operating system and various runtime environments installed on a machine, such as Java, Python, Node.js, and .NET Framework (on Windows).

## ⚠️ Warning: Work in Progress

**PLEASE NOTE: This project is currently in early development stages and is considered a rough work in progress.**

## Features

- Check operating system information (including OS flavor details)
- Check Java runtime version
- Check Python runtime version (with current shell environment context)
- Check Node.js runtime version
- Check OpenTelemetry Collector version and path
- Check .NET Framework versions (Windows only)
- Detect Kubernetes environments and list OpenTelemetry ConfigMaps
- Perform system health checks (disk space, network connectivity, file permissions)
- Generate timestamped reports in text or JSON format


## Project Structure

```plaintext
system-scanner/
│
├── os_info.py
├── runtime_versions.py
├── dotnet_framework.py
├── health.py
├── utils.py
├── validators.py
└── main.py
```


### Module Descriptions

- **`os_info.py`**: Retrieves operating system information including system type, version, architecture, and OS flavor.
- **`runtime_versions.py`**: Handles version checking and retrieval for various runtimes like Java, Python, and Node.js. Also detects OpenTelemetry Collector and Kubernetes environments.
- **`dotnet_framework.py`**: Specifically deals with retrieving .NET Framework versions on Windows systems.
- **`health.py`**: Performs system health checks for disk space, network connectivity, and file permissions.
- **`utils.py`**: Contains utility functions including contextual logging with timing information.
- **`validators.py`**: Provides input validation and sanitization functions.
- **`main.py`**: Entry point to orchestrate the retrieval and logging of system information.


## Requirements

- Python 3.9 or higher


## Installation

1. Clone the repository:

```bash
git clone https://github.com/splunk/observability-content-contrib.git
```

2. Navigate into the project directory:

```bash
cd observability-content-contrib/integration-examples/system-scanner
```


## Usage

To run the script and get information about your system's versions and runtimes, execute:

```bash
python3 main.py                    # Default text output
python3 main.py --output json      # JSON output
python3 main.py --health-check     # Include system health checks
```


## Health Checks

The system scanner includes basic health checks for:

- Disk space
- Network connectivity (tests connection to 8.8.8.8:53)
- File system permissions (tests ability to create/delete temporary files)

These checks can be enabled using the `--health-check` flag.

## Output

The script generates a formatted report directly to the console, structured as follows:

```
==================================================
SYSTEM SCANNER REPORT
Generated: 2025-03-21 14:27:00
==================================================

OPERATING SYSTEM INFORMATION:
  System: [OS Name]
  Version: [OS Version]
  Architecture: [OS Architecture]
  Flavor: [OS Flavor]
--------------------------------------------------
RUNTIME VERSIONS:
  Java: [Java Version]
  Python: [Python Version] (Current Shell Environment)
  Node.js: [Node.js Version]
--------------------------------------------------
OPENTELEMETRY COLLECTOR INFORMATION:
  Version: [OTel Collector Version]
  Path: [OTel Collector Path]
--------------------------------------------------
KUBERNETES INFORMATION:
  OpenTelemetry ConfigMaps: [ConfigMap Information]
--------------------------------------------------
SYSTEM HEALTH:
  disk_space: ✓
  network: ✓
  file_permissions: ✓
--------------------------------------------------
```


## Kubernetes Integration

When running in a Kubernetes environment, the scanner will automatically detect this and attempt to list any OpenTelemetry-related ConfigMaps in the cluster. This functionality requires:

1. The scanner to be running inside a Kubernetes pod
2. The pod to have appropriate permissions to list ConfigMaps
3. The `kubectl` command to be available in the environment

## Logging

The script generates logs in a `logs` directory, with detailed information about operations and any errors encountered during execution. The log file (`system_scanner.log`) can be found in the `logs` directory.

## Common Commands: Bash vs PowerShell

For users who need to run commands manually or understand the underlying operations, here are some common commands used in this project with their Bash and PowerShell equivalents:


| Operation | Bash (Unix-like systems) | PowerShell (Windows) |
| :-- | :-- | :-- |
| Check Java version | `java -version` | `java -version` |
| Check Python version | `python --version` | `python --version` |
| Check Node.js version | `node --version` | `node --version` |
| Check OS version | `uname -a` | `[System.Environment]::OSVersion.Version` |
| Check OTel Collector version | `otelcol --version` | `otelcol --version` |

## OTel Collector config location(s) (Default)

**Windows**

```powershell
C:\ProgramData\Splunk\OpenTelemetry Collector\agent_config.yaml
```

**Linux**

```bash
/etc/otel/collector/agent_config.yaml
```


## Contributing

If you wish to contribute to this project, please fork the repository and submit a pull request.

**Note**: This project uses standard Python libraries to maintain portability and minimize dependencies.
