# Configuration Examples
**NOTE:** These are only examples. You configuration will likely be slightly different.

These examples expect you are using the [`splunk-otel-collector`](https://github.com/signalfx/splunk-otel-collector) but these examples will also work with any other OTEL configuration.

1. [`agent_config.yaml`](./agent_config.yaml) Contains receiver, exporter, pipeline configuration
     The receiver entries for Snowflake can be found under `smartagent/sql`
     1. **NOTE:** You MUST add your Snowflake `account` to this config where `account` taken from this format `<account>.snowflakecomputing.com`
     2. If you plan to use a custom `role` rather than `ACCOUNTADMIN` you will need to add your `role` to this config
    - **NOTE:** Resolution of `3600` seconds (1 hour) is recommended due to the latency between actions happening and then showing up in the `SNOWFLAKE/ACCOUNT_USAGE` db view. It is possible to collect at a higher interval but is not recommended.
2. [`splunk-otel-collector.conf`](./splunk-otel-collector.conf) Contains referenced variables like snowflake username / password, and Splunk Observability token, etc
    1. Add your Splunk Observability token in `SPLUNK_ACCESS_TOKEN`
    2. Add your Snowflake User to `SNOWFLAKE_USER` (the user MUST have a role that allows access to the `SNOWFLAKE/ACCOUNT_USAGE` db view)
    3. Add the password for your Snowflake user account to `SNOWFLAKE_PASS`
3. [`snowflake-metrics.yaml`](./snowflake-metrics.yaml) Contains SQL queries and mappings for our Splunk Observability metrics and dimensions
    - [`snowflake-other-metrics.yaml`](./snowflake-other-metrics.yaml) file contains SQL queries for:
        - detailed and *high cardinality* DB query metrics including the `query_id` dimension which is a GUID
            - When using these metrics replace the `DB Metrics` in `snowflake-metrics.yaml`
        - Billing usage in USD