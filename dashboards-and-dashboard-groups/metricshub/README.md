# MetricsHub

## Overview

**MetricsHub** is a universal metrics collection agent designed for monitoring hardware components, system performance, and sustainability KPIs. It collects data from servers, storage systems, and network devices and pushes it to OpenTelemetry back-ends such as the Splunk Observability Cloud.

### Key Features

- **Remote Monitoring**: MetricsHub supports the monitoring of thousands of systems remotely through protocols such as REST APIs, SNMP, WBEM, WMI, SSH, IPMI, and more.
- **OpenTelemetry Integration**: MetricsHub acts as an OpenTelemetry agent, following its standards for easy integration with various observability platforms.
- **Sustainability Metrics**: Track and report on energy usage and carbon footprint to optimize infrastructure efficiency.
- **250+ Connectors**: Ready-to-use connectors for monitoring a wide variety of platforms. MetricsHub agent is truly vendor-neutral, providing consistent coverage for all manufacturers (e.g., Cisco, Dell EMC, Huawei, HP, IBM, Lenovo, Pure, and more).

### Dashboards

MetricsHub comes with pre-configured dashboards that visualize hardware, as well as sustainability KPIs:

| Dashboard | Description |
| --- | --- |
| **Hardware - Main** | Overview of all monitored systems, focusing on key hardware and sustainability metrics. |
| **Hardware - Site** | Metrics specific to a particular site (a data center or a server room) and its monitored hosts. |
| **Hardware - Host** | Metrics associated with one *host* and its internal devices. |

## Setup

1. Follow the [installation instructions](https://metricshub.com/docs/latest/installation/index.html)
2. Configure the OpenTelemetry Collector to export metrics to Splunk by editing `otel-config.yaml`:

    ```yaml
    exporters:
       signalfx:
          # Access token to send data to SignalFx.
          access_token: <your token>
          # SignalFx realm where the data will be received.
          realm: <your realm>
    ```

Get more information about the [SignalFx Metrics Exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/signalfxexporter).

## Support

Subscribers to **MetricsHub** gain access to the **MetricsHub Support Desk**, which provides:

- Technical support
- Patches and updates
- Knowledge base access

Splunk does not provide support for these dashboards and users should contact Sentry Software's support with any support requests.

### Further Reading

For more information, visit the [MetricsHub](https://metricshub.com/) website.
