# vLLM

Dashboard group, dashboard and detectors for [vLLM](https://docs.vllm.ai) inference servers.

vLLM serves Prometheus metrics on the `/metrics` path of its OpenAI-compatible server (port `8000` by default). Scrape it with the `prometheus` receiver of the Splunk Distribution of the OpenTelemetry Collector and add the receiver to the metrics pipeline:

```yaml
receivers:
  prometheus/vllm:
    config:
      scrape_configs:
        - job_name: vllm
          scrape_interval: 15s
          static_configs:
            - targets: ["localhost:8000"]
          metric_relabel_configs:
            - source_labels: [__name__]
              regex: "vllm:.*"
              action: keep

service:
  pipelines:
    metrics:
      receivers: [hostmetrics, otlp, prometheus/vllm]
```

The charts and detectors use the metric names of the vLLM V1 engine (`vllm:kv_cache_usage_perc`, `vllm:inter_token_latency_seconds`) and the `model_name` label that vLLM adds to every series. Latency charts show averages computed from the `_sum` and `_count` series of each histogram.

## Dashboard

- Requests running and waiting
- KV cache usage
- Preemptions per second
- Prompt and generation tokens per second
- Prefix cache hit rate
- Finished requests by `finished_reason`
- Average time to first token
- Average inter-token latency
- Average end to end and queue time

## Detectors

| Detector | Condition |
|---|---|
| KV cache nearly full | `vllm:kv_cache_usage_perc` above 0.95 for 15m |
| Requests queueing | `vllm:num_requests_waiting` above 10 for 10m |
| High average time to first token | average time to first token above 2s for 10m |

Tune the thresholds to your workload and SLO.

## Deploy only this module

``` text
terraform apply -target=module.vllm
```
