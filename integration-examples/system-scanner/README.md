# SystemScanner

This project is designed to check and report information about the operating system and various runtime environments installed on a machine, such as Java, Python, Node.js, and .NET Framework (on Windows).

## ⚠️ Warning: Work in Progress

**PLEASE NOTE: This project is currently in early development stages and is considered a rough work in progress.**

## Features

- Check operating system information
- Check Java runtime version
- Check Python runtime version
- Check Node.js runtime version
- Check OpenTelemetry Collector version and path
- Check .NET Framework versions (Windows only)

## Project Structure

```plaintext
system-scanner/
│
├── os_info.py
├── runtime_versions.py
├── dotnet_framework.py
└── main.py
```

### Module Descriptions

- **`os_info.py`**: Retrieves operating system information.
- **`runtime_versions.py`**: Handles version checking and retrieval for various runtimes like Java, Python, and Node.js.
- **`dotnet_framework.py`**: Specifically deals with retrieving .NET Framework versions on Windows systems.
- **`main.py`**: Entry point to orchestrate the retrieval and logging of system information.

## Requirements

- Python 3.9 or higher

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/splunk/observability-content-contrib.git

2. Navigate into the project directory:
    ```bash
    cd observability-content-contrib/integration-examples/system-scanner
    ```

## Usage

To run the script and get information about your system's versions and runtimes, execute:
```bash
python3 main.py
```

### Output

The script generates a formatted report directly to the console, structured as follows:

```
==================================================
SYSTEM SCANNER REPORT
==================================================

OPERATING SYSTEM INFORMATION:
  System: [OS Name]
  Version: [OS Version]
  Architecture: [OS Architecture]

--------------------------------------------------
RUNTIME VERSIONS:
  Java: [Java Version]
  Python: [Python Version]
  Node.js: [Node.js Version]

--------------------------------------------------
OPENTELEMETRY COLLECTOR INFORMATION:
  Version: [OTel Collector Version]
  Path: [OTel Collector Path]

--------------------------------------------------
[.NET FRAMEWORK VERSIONS (if on Windows)]

==================================================
END OF SYSTEM SCANNER REPORT
==================================================
```


If running the script(s) isn't an option (for security reasons, etc), the same information can be obtained by referencing the below commands.


## Common Commands: Bash vs PowerShell

For users who need to run commands manually or understand the underlying operations, here are some common commands used in this project with their Bash and PowerShell equivalents:

| Operation | Bash (Unix-like systems) | PowerShell (Windows) |
|-----------|--------------------------|----------------------|
| Check Java version | `java -version` | `java -version` |
| Check Python version | `python --version` | `python --version` |
| Check Node.js version | `node --version` | `node --version` |
| Check OS version | `uname -a` | `[System.Environment]::OSVersion.Version` |
| List directory contents | `ls -l` | `Get-ChildItem` or `dir` |
| Create a directory | `mkdir -p new_folder` | `New-Item -ItemType Directory -Name new_folder` |
| Remove a file | `rm file.txt` | `Remove-Item file.txt` |
| Set an environment variable | `export VAR_NAME=value` | `$env:VAR_NAME = "value"` |
| Read an environment variable | `echo $VAR_NAME` | `$env:VAR_NAME` |
| Find a file | `find /path -name filename` | `Get-ChildItem -Path C:\ -Recurse -Filter filename` |
| Check if a file exists | `test -f filename && echo "Exists"` | `if (Test-Path filename) { "Exists" }` |
| Get current directory | `pwd` | `Get-Location` or `pwd` |
| Move/Rename a file | `mv old_name new_name` | `Move-Item -Path old_name -Destination new_name` |
| Copy a file | `cp source destination` | `Copy-Item -Path source -Destination destination` |
| Get OTel Collector version | `/bin/otelcol -v` | TBD |

Note: Some commands (like checking runtime versions) may be identical in both environments, while others differ significantly.

## .NET Framework Version Check (Windows Only)

To check the installed .NET Framework versions on a Windows system, you can use the following PowerShell command:

```powershell
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version
```

This command is already implemented in the `dotnet_framework.py` module for Windows systems.



## OTel Collector config location(s) (Default)

**Windows**
```powershell
C:\ProgramData\Splunk\OpenTelemetry Collector\agent_config.yaml
```

**Linux**
```bash
/etc/otel/collector/agent_config.yaml
```

The environment file with the required variables/values for the Splunk OpenTelemetry Collector service based on the specified parameters.

```bash
/etc/otel/collector/splunk-otel-collector.conf
```


## Tailing Collector Logs
**Linux**

Splunk Distro of OpenTelemetry:

```bash
sudo journalctl -u splunk-otel-collector -f -n 200
```

```bash
tail -f /var/log/[splunk-otel-collector]
```

Upstream OTel Collector (contrib):
```bash
sudo journalctl -u otelcol-contrib -f -n 200
```

```bash
tail -f /var/log/[otelcol-contrib]
```

## Getting Status/Restarting the OTel Collector

**Linux**

Splunk Distribution:
```bash
sudo systemctl [status/stop/start/restart] splunk-otel-collector
```

Upstream Contrib:
```bash
sudo systemctl [status/stop/start/restart] otelcol-contrib
```

**Windows**

Stop the Collector service:

```powershell
[Stop-Service/Start-Service] splunk-otel-collector
```

### Logging

While the main output is printed to the console, the script also generates a log file (`system_scanner.log`) in the same directory. This log file can be useful for debugging purposes.

## Error Handling

The script includes robust error handling mechanisms to catch potential exceptions during execution. Any errors or unexpected behaviors will be reflected in the output.

## Contributing

If you wish to contribute to this project, please fork the repository and submit a pull request.

**Note**: This project uses standard Python libraries to maintain portability and minimize dependencies.
