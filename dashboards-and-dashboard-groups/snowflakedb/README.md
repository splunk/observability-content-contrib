# SnowflakeDB Dashboards

This folder contains a Dashboard Group and individual Dashboards for Snowflake along with OpenTelemetry configuration examples for [Smart Agent receiver](https://docs.splunk.com/observability/en/gdi/monitors-databases/sql.html#collect-snowflake-performance-and-usage-metrics) and the OpenTelemetry contributed [Snowflake receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/snowflakereceiver).

## Configuration

### OpenTelemetry Agent Configuration

#### Snowflake Receiver (OpenTelemetry Contrib)
Setup according to [receiver documentation](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/snowflakereceiver) or use the provided configurations as guidance:
1.  [`agent_config.yaml`](./Configuration/snowflake-receiver/agent_config.yaml) Contains receiver, exporter, pipeline configuration
    - The receiver entries for Snowflake can be found under `snowflake`
2. [`splunk-otel-collector.conf`](./Configuration/snowflake-receiver/splunk-otel-collector.conf) Contains referenced variables like snowflake username / password, and Splunk Observability token, etc

#### Smart Agent Receiver (Legacy)
1. [`agent_config.yaml`](./Configuration/agent_config.yaml) Contains receiver, exporter, pipeline configuration
    - The receiver entries for Snowflake can be found under `smartagent/sql`
2. [`splunk-otel-collector.conf`](./Configuration/splunk-otel-collector.conf) Contains referenced variables like snowflake username / password, and Splunk Observability token, etc
3. [`snowflake-metrics.yaml`](./Configuration/snowflake-metrics.yaml) Contains SQL queries and mappings for our Splunk Observability metrics and dimensions pulling metrics from the Snowflake `SNOWFLAKE/ACCOUNT_USAGE` internal view.

## Sections
### Snowflake Home (overview):
  - General overview of Snowflake activity including Queries, errors, storage, user, login, credit counts, etc
  - Prioritizes sums over 24h and 1h periods where applicable

### Snowflake Warehouse:
  - Warehouse oriented view with charts over time for queries, errors, load, etc
  - Breakdowns on usage by Warehouse size
  - Tables for investigation of queuing, spilling, and data ingest


### Snowflake Database:
  - Database oriented view with charts over time for queries, errors, load, etc
  - Breakdowns on usage by Database
  - Tables for investigation of queuing, spilling, and data ingest


### Snowflake Schema:
  - Schema oriented view with charts over time for queries, errors, load, etc
  - Breakdowns on usage by Schema
  - Tables for investigation of queuing, spilling, and data ingest


### Snowflake Queries (overview):
  - More detailed breakdown of queries, errors, queuing , query status, etc
  - Table for detailed investigtion of errors including error messages, usernames, etc

### Snowflake Cost:
  - Cyclical daily counts of credit usage broken down by tipe
  - Charts for credit usage over time broken down by type
  - Charts detailing storage usage over time broken down by type

### Snowflake Security (logins):
  - Chart over time for logins and failed logins
  - Tables for investigation of login failures by user and sessions by user

### Snowflake Query Details [legacy Smart Agent only]:
- **NOTE:** This dashboard will be empty unless you replace the DB metrics set of SQL queries in [`snowflake-metrics.yaml`](./Configuration/snowflake-metrics.yaml) with the high cardinality queries from [`snowflake-other-metrics.yaml`](./Configuration/snowflake-other-metrics.yaml) in your OTEL collector configuration that produces *high cardinality* metrics with a dimension for `query_id`
- Provides 
  - Top queries by length of time
  - Queries where Compilation Time > Execution Time
  - Queries by % of cache hits
  - Queries by partitions scanned

## Detectors
**Note:** Detectors currently use Smart Agent naming for metrics
Detectors for Snowflake in Splunk Observability can be found in the [detectors folder](../../detectors/snowflakedb/) of this repository.

## Troubleshooting 

### Troubleshooting Configurations
1. If you get an error like:
    ```
    Jul 19 14:08:58 otel-testing otelcol[706538]: time="2022-07-19T14:08:58Z" level=error msg="error: 000606 (57P03): No active warehouse selected in the current session.  Select an active warehouse with the 'use warehouse' command.\n" 
    func="gosnowflake.(*snowflakeConn).queryContextInternal" file="connection.go:356"
    ```
    You need to enable a default warehouse for the account your OTEL agent is using in Snowflake
2. the `config_sources` block must be in your [agent configuration file](./Configuration/agent_config.yaml) or you will not be able to reference the `snowflake-metrics.yaml` file:
    ```
    config_sources:
      include:
    ```


### Troubleshooting Metrics
Sometimes metrics may look different than expected due to the latency of Snowflake picking up changes in their `SNOWFLAKE/ACCOUNT_USAGE` db view which we pull metrics from.
https://docs.snowflake.com/en/sql-reference/account-usage.html#account-usage-views

The time between any action happening in snowflake and it being countable for metrics is 45 minutes.

For this reason (and Snowflake credit considerations) our suggested cadence for picking up metrics is `3600` seconds (1 hour)

**Example:**
1. 100 failed logins happen at 12:45pm. 
2. OTEL Collector runs SQL queries against `SNOWFLAKE/ACCOUNT_USAGE` every hour and started at 10:05am (it will run every hour, 11:05am, 12:05pm, 1:05PM, etc)
3. The 1:05pm SQL query happens and brings in metrics.
4. Due to the 45 minute latency between action happening and it showing up in `SNOWFLAKE/ACCOUNT_USAGE` view in Snowflake the 100 failed logins may not show up until the 2:05pm SQL query.  
