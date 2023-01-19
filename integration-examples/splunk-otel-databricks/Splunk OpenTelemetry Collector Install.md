# Splunk OpenTelemetry Collector Installation on Databricks

## Modify the `httpforwarder` receiver configuration

### To begin one will need to modify the OpenTelemetry agent yaml file, sections for

* extensions
* receivers
* exporters

#### These sections need to have a semi-colon and a non-conflicting port such as 7070 appended to the endpoint value

##### Path: `extensions/http_forwarder/ingress/endpoint`

```yaml
extensions:
  health_check:
    endpoint: 0.0.0.0:13133
  http_forwarder:
    ingress:
      # Using a non-default port of 7070 for the ingress endpoint
      endpoint: 0.0.0.0:7070
```

## Modify the OpenTelemetry receivers

### Insert into the receivers section to include spark properties for your environment

* `collectd_spark_worker` or
* `collectd_spark_master`

#### Example configuration for a Worker

##### Path: `receivers/smartagent/collectd_spark_worker`

```yaml
receivers:
  smartagent/collectd_spark_worker:
    type: collectd/spark
    host: localhost
    port: 8080
    clusterType: Standalone
    isMaster: false
    enhancedMetrics: true
    extraMetrics: ["*"]
    intervalSeconds: 1
```

#### Example configuration for a Controller:

##### Path: `receivers/smartagent/collectd_spark_master`

```yaml
receivers:
  smartagent/collectd_spark_master:
    type: collectd/spark
    host: localhost
    port: 8080
    clusterType: Standalone
    isMaster: true
    collectApplicationMetrics: true
    enhancedMetrics: true
    extraMetrics: ["*"]
    intervalSeconds: 1
```

### Modify the exporters section

#### Modify api_url: <http://${SPLUNK_API_URL}:7070> to match the port used for the http_forwarder extension

##### Yaml Path: `exporters/signalfx/api_url`

```yaml
### Traces
exporters:
  signalfx:
    access_token: "${SPLUNK_ACCESS_TOKEN}"
    # Use when port conflicts occur with 8080, 6060, etc
    api_url: <http://${SPLUNK_API_URL}:7070>
```

References:

  1. Splunk Documentation <https://docs.splunk.com/Observability/gdi/spark/spark.html>
  2. Example Configurations for worker and controller <https://github.com/signalfx/splunk-otel-collector/tree/main/tests/receivers/smartagent/collectd-spark/testdata>.
  3. httpforwarder Documentation <https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/extension/httpforwarder/README.md>
