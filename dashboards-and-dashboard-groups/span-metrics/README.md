# Span Metrics Dashboard

This dashboard depends on the [`span_metrics`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/connector/spanmetricsconnector) connector and is meant to show the performance of **internal spans** inside a service.

## Background

More information on the technique used, and why it matters, can be found in this blog post:

- [Span metrics: The OpenTelemetry Idiomatic Way to See Inside Your Services](https://community.splunk.com/t5/Community-Blog/span-metrics-The-OpenTelemetry-Idiomatic-Way-to-See-Inside-Your/ba-p/762246)

## OpenTelemetry Collector configuration

Example minimal OpenTelemetry Collector configuration to create span metrics for the spans inside services `internal-span-demo` and `other-service`:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch: {}

connectors:
  routing:
    # route everything to the default pipeline
    # only route spans with specific service names to the span metrics pipeline
    default_pipelines: [traces/default]
    table:
      - condition: ContainsValue(["internal-span-demo", "other-service"], resource.attributes["service.name"])
        action: copy # important, this ensures the span is ALSO sent to the default pipeline
        pipelines: [traces/route-to-spanmetrics]

  span_metrics:
    exclude_dimensions: ['collector.instance.id']
    aggregation_temporality: AGGREGATION_TEMPORALITY_DELTA
    metrics_flush_interval: 10s # resolution of generated metrics
    exemplars:
      enabled: false # explicitly disabled exemplars as we don't need them
    events:
      enabled: false # explicitly disabled events as we don't need them
    aggregation_cardinality_limit: 30 # explicit limit, raise if needed.
                                      # expected cardinality is 2x or 3x the number of different span names.
                                      # when limit is reached, attribute otel.metric.overflow="true" is set.

exporters:
  otlphttp/splunk:
    traces_endpoint: https://ingest.${env:SPLUNK_REALM}.observability.splunkcloud.com/v2/trace/otlp
    metrics_endpoint: https://ingest.${env:SPLUNK_REALM}.observability.splunkcloud.com/v2/datapoint/otlp
    headers:
      X-SF-Token: ${env:SPLUNK_ACCESS_TOKEN}

service:
  pipelines:
    traces/in:
      receivers: [otlp]
      exporters: [routing]
    traces/default:
      receivers: [routing]
      processors: [batch]
      exporters: [otlphttp/splunk]
    traces/route-to-spanmetrics:
      receivers: [routing]
      exporters: [span_metrics]
    metrics:
      receivers: [span_metrics]
      processors: []
      exporters: [otlphttp/splunk]

  telemetry:
    metrics:
      level: none
```
