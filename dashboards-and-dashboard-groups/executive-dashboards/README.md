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
  
  Another option for adding this dashboard to your Splunk Observability environment is to import the included [`Exec-Level-Dashbaord-Group.json`](./Exec-Level-Dashboard-Group.json) in the same manner as you'd [import other exported dashboards](https://docs.splunk.com/observability/en/data-visualization/dashboards/dashboards-import-export.html#import-a-dashboard) and dashboard groups.

**Reminder:** These dashboards can be edited to include more context or split by dimensions specific to your own concerns. 

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
  - Logs per day by severity 


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


### License Usage overview:
- Provides 4 week and 12 week comparisons of "License Metrics"
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
  - Synthetics Datapoints Received


### Token Usage overview:
- Token Usage Rate 4 week and 12 week comparisons
- MTS Token Usage 4 week and 12 week comparisons
- Mean MTS Usage by Token
- Bundled Metrics by Token
- Custom Metrics by Token
- Resource Metrics by Token
- APM Bundled Metrics by Token
- Logs and Profiling Logs by Token
