# Executive Dashboards
Executive Dashboards in this group are focused on high level comparisons over time (4 week and 12 week)
- Wherever possible Org level metrics are used for compatibility
- Included Terraform files expect a Splunk Observability token to be available in the `signalfx_auth_token` environment variable.
  - Env Var Example: `export TF_VAR_signalfx_auth_token=this-is-my-splunk-observability-token`
- If required you can input your own `api_url` variable for your Splunk Observability org
  - https://registry.terraform.io/providers/splunk-terraform/signalfx/latest/docs  
    ```
    api_url - (Optional) The API URL to use for communicating with SignalFx. This is helpful for organizations that need to set their Realm or use a proxy. You can also set it using the SFX_API_URL environment variable.
    ```
- Log Events dashboards can be enriched with a Log Observer Metric noted below

**Reminder:** These dashboards can be edited to include more context or split by dimensions specific to your own concerns. 


## Log Observer Severity Metric
Note: When using Log Observer Connect this metric will need to be metricized in Splunk Cloud.

This metric enables visualizing log observer ingest by severity/log level.
```
Matching Condition: Match All

Operation: count

Dimensions: ["severity","deployment.environment"]
(Replace "deployment.environment" with your environment dimension)

Field: null

Metric Name: logs.events.count

```

## Sections
### APM / IMM (RED Metrics) overview:
- Provides 4 week and 12 week comparisons of R.E.D./L.E.T.S. metric, better known as the "Golden Signals"
  - Latency
  - Error rates
  - Total request rates
  - Host saturation 

### Logs overview:
- Provides 4 week and 12 week comparisons of Log Observer usage
  - Logs received per day by token
  - Profiling logs received per day by token
  - Logs per day by severity (requires setting up the [Log Observer metric](#log-observer-severity-metric) mentioned above)


### Real User Monitoring (RUM) overview:
- Provides 12 week comparisons of RUM metrics
  - RUM Browser request rate
  - RUM Browser error rates
  - RUM Browser latency (p75)
  - RUM Browser Web Vitals (p75)
  - RUM App request rate
  - RUM App errors
  - RUM App latency (p75)
  - RUM App crash count
  - RUM Workflow request rate
  - RUM Workflow errors
  - RUM Workflow latency (p75)


### Billing overview:
- Provides 4 week and 12 week comparisons of "Billable Metrics"
  - APM Hosts
  - APM Span Bytes Received
  - APM Troubleshooting Metric Sets
  - APM Traces Per Minute (TMP)
  - IMM Hosts
  - IMM Custom Metrics
  - IMM High Resolution Metrics
  - IMM Data Points per Minute (DPM)
  - Log Observer ingest bytes
  - Log Observer ingest bytes per host
