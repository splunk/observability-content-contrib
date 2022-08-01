# Configuration Examples
**NOTE:** These are only examples. You configuration will likely be slightly different.

These examples expect you are using the [`splunk-otel-collector`](https://github.com/signalfx/splunk-otel-collector) but these examples will also work with any other OTEL configuration.

1. [`agent_config.yaml`](./agent_config.yaml) Contains receiver, exporter, pipeline configuration
    - The receiver entries for Snowflake can be found under `smartagent/sql`
2. [`splunk-otel-collector.conf`](./splunk-otel-collector.conf) Contains referenced variables like snowflake username / password, and Splunk Observability token, etc
    - Add your Splunk Observability token in `SPLUNK_ACCESS_TOKEN`
    - Add your Snowflake User to `SNOWFLAKE_USER` (the user MUST have a role that allows access to the `SNOWFLAKE/ACCOUNT_USAGE` db view)
    - Add the password for your Snowflake user account to `SNOWFLAKE_PASS`
3. [`snowflake-metrics.yaml`](./snowflake-metrics.yaml) Contains SQL queries and mappings for our Splunk Observability metrics and dimensions
    - [`snowflake-other-metrics.yaml`](./snowflake-other-metrics.yaml) file contains SQL queries for:
        - detailed and *high cardinality* DB query metrics including the `query_id` dimension which is a GUID
            - When using these metrics replace the `DB Metrics` in `snowflake-metrics.yaml`
        - Billing usage in USD