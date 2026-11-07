resource "signalfx_detector" "vllm_kv_cache_nearly_full" {
  name         = "${var.o11y_prefix} vLLM - KV cache nearly full"
  description  = "Alerts when the KV cache usage of a vLLM server stays above 95% for 15m. New requests wait and running ones get preempted"
  program_text = <<-EOF
    A = data('vllm:kv_cache_usage_perc').max(by=['host.name', 'model_name']).publish(label='A')
    detect(when(A > threshold(0.95), lasting='15m')).publish('vLLM KV cache usage above 95%')
  EOF
  rule {
    detect_label       = "vLLM KV cache usage above 95%"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "vllm_requests_queueing" {
  name         = "${var.o11y_prefix} vLLM - Requests queueing"
  description  = "Alerts when more than 10 requests wait to be scheduled on a vLLM server for 10m. The engine is saturated"
  program_text = <<-EOF
    A = data('vllm:num_requests_waiting').sum(by=['host.name', 'model_name']).publish(label='A')
    detect(when(A > threshold(10), lasting='10m')).publish('vLLM requests waiting above 10')
  EOF
  rule {
    detect_label       = "vLLM requests waiting above 10"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "vllm_high_time_to_first_token" {
  name         = "${var.o11y_prefix} vLLM - High average time to first token"
  description  = "Alerts when the average time to first token of a model stays above 2s for 10m. Tune the threshold to your SLO"
  program_text = <<-EOF
    S = data('vllm:time_to_first_token_seconds_sum', rollup='delta').sum(by=['model_name'])
    C = data('vllm:time_to_first_token_seconds_count', rollup='delta').sum(by=['model_name'])
    A = (S / C).publish(label='A')
    detect(when(A > threshold(2), lasting='10m')).publish('vLLM average time to first token above 2s')
  EOF
  rule {
    detect_label       = "vLLM average time to first token above 2s"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}
