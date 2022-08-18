# Snowflake Detectors

This folder contains detectors that may be useful when working with Snowflake.

Please note that you may want or need different thresholds than those provided here. 

## Snowflake Metrics Configuration
Please see [configuration examples](../../dashboards-and-dashboard-groups/snowflakedb/Configuration/) for help getting metrics from Snowflake into Splunk Observability.
## Importing Detectors
Two options exist:  
1. Edit and send the Detector JSON [via API](https://dev.splunk.com/observability/reference/api/detectors/latest#endpoint-create-single-detector)
  ```
  curl -X POST "https://api.{REALM}.signalfx.com/v2/detector" \
    -H "Content-Type: application/json" \
    -H "X-SF-TOKEN: <value>" \
    -d @"/path/to/detector/detector_name_is_amazing.json"
  ```
2. Copy the SignalFlow out of the detector JSON and paste into your own Detector [via the UI](https://docs.splunk.com/Observability/alerts-detectors-notifications/create-detectors-for-alerts.html#nav-Create-detectors-to-trigger-alerts)

## Available Detectors
Provided alerts follow the 4 Golden Signals of Latency, Errors, Traffic, and Saturation (L.E.T.S.) along with Billing.
### Latency:
- Queries in Small / X-Small Warehouses longer than 5 minutes (I.E. 300000 ms)
- Queries taking more than 15 minutes (900 seconds)

### Errors
- Database Errors by Warehouse (Arbitrarily threshold of 100 errors)
- Database Error Rate by Warehouse (Arbitrary threshold of 15%)
- Login Failures by User (Threshold of 15 per hour)

### Traffic
- Blocked Queries by Warehouse
- No Queries in last 3 hours

### Saturation
- Overloaded Queries by Warehouse
- Queries Queued longer than 5 minutes (I.E. 300000 ms)

### Billing
- Credits used by Warehouse (Anomaly detection)
- % of spend for Cloud Service greater than 15% by Warehouse