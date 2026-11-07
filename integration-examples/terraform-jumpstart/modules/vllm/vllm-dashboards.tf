resource "signalfx_dashboard_group" "vllm_dashboard_group" {
  name        = "${var.o11y_prefix} vLLM"
  description = "Dashboards for vLLM inference servers"
}

resource "signalfx_time_chart" "vllm_requests" {
  name        = "Requests running and waiting"
  description = "Requests in the running batch and in the waiting queue"

  program_text = <<-EOF
        A = data('vllm:num_requests_running').sum(by=['model_name']).publish(label='Running')
        B = data('vllm:num_requests_waiting').sum(by=['model_name']).publish(label='Waiting')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_kv_cache" {
  name        = "KV cache usage (%)"
  description = "Fraction of the KV cache in use. Close to 100% the scheduler preempts requests"

  program_text = <<-EOF
        A = data('vllm:kv_cache_usage_perc').max(by=['host.name', 'model_name']).scale(100).publish(label='KV cache %')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_preemptions" {
  name        = "Preemptions per second"
  description = "Requests preempted because the KV cache ran out; they are recomputed later"

  program_text = <<-EOF
        A = data('vllm:num_preemptions_total', rollup='rate').sum(by=['model_name']).publish(label='Preemptions/s')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_tokens" {
  name        = "Token throughput (tokens/s)"
  description = "Prompt (prefill) and generation tokens processed per second"

  program_text = <<-EOF
        A = data('vllm:prompt_tokens_total', rollup='rate').sum(by=['model_name']).publish(label='Prompt')
        B = data('vllm:generation_tokens_total', rollup='rate').sum(by=['model_name']).publish(label='Generation')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_prefix_cache" {
  name        = "Prefix cache hit rate (%)"
  description = "Share of prompt tokens served from the prefix cache"

  program_text = <<-EOF
        H = data('vllm:prefix_cache_hits_total', rollup='delta').sum(by=['model_name'])
        Q = data('vllm:prefix_cache_queries_total', rollup='delta').sum(by=['model_name'])
        A = (H / Q * 100).publish(label='Hit rate %')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_finished" {
  name        = "Finished requests per second by reason"
  description = "Finished requests by finished_reason: stop, length, abort, error or repetition"

  program_text = <<-EOF
        A = data('vllm:request_success_total', rollup='rate').sum(by=['finished_reason']).publish(label='Requests/s')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_ttft" {
  name        = "Average time to first token (s)"
  description = "Average time from request arrival to the first output token"

  program_text = <<-EOF
        S = data('vllm:time_to_first_token_seconds_sum', rollup='delta').sum(by=['model_name'])
        C = data('vllm:time_to_first_token_seconds_count', rollup='delta').sum(by=['model_name'])
        A = (S / C).publish(label='TTFT')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_itl" {
  name        = "Average inter-token latency (s)"
  description = "Average time between consecutive output tokens"

  program_text = <<-EOF
        S = data('vllm:inter_token_latency_seconds_sum', rollup='delta').sum(by=['model_name'])
        C = data('vllm:inter_token_latency_seconds_count', rollup='delta').sum(by=['model_name'])
        A = (S / C).publish(label='Inter-token latency')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "vllm_e2e" {
  name        = "Average end to end and queue time (s)"
  description = "Average end to end request latency and time spent waiting in the queue"

  program_text = <<-EOF
        S = data('vllm:e2e_request_latency_seconds_sum', rollup='delta').sum(by=['model_name'])
        C = data('vllm:e2e_request_latency_seconds_count', rollup='delta').sum(by=['model_name'])
        QS = data('vllm:request_queue_time_seconds_sum', rollup='delta').sum(by=['model_name'])
        QC = data('vllm:request_queue_time_seconds_count', rollup='delta').sum(by=['model_name'])
        A = (S / C).publish(label='End to end')
        B = (QS / QC).publish(label='Queue')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_dashboard" "vllm_dashboard" {
  name            = "vLLM"
  dashboard_group = signalfx_dashboard_group.vllm_dashboard_group.id
  time_range      = "-1h"

  variable {
    property = "model_name"
    alias    = "model"
  }

  chart {
    chart_id = signalfx_time_chart.vllm_requests.id
    width    = 4
    height   = 1
    row      = 0
    column   = 0
  }

  chart {
    chart_id = signalfx_time_chart.vllm_kv_cache.id
    width    = 4
    height   = 1
    row      = 0
    column   = 4
  }

  chart {
    chart_id = signalfx_time_chart.vllm_preemptions.id
    width    = 4
    height   = 1
    row      = 0
    column   = 8
  }

  chart {
    chart_id = signalfx_time_chart.vllm_tokens.id
    width    = 4
    height   = 1
    row      = 1
    column   = 0
  }

  chart {
    chart_id = signalfx_time_chart.vllm_prefix_cache.id
    width    = 4
    height   = 1
    row      = 1
    column   = 4
  }

  chart {
    chart_id = signalfx_time_chart.vllm_finished.id
    width    = 4
    height   = 1
    row      = 1
    column   = 8
  }

  chart {
    chart_id = signalfx_time_chart.vllm_ttft.id
    width    = 4
    height   = 1
    row      = 2
    column   = 0
  }

  chart {
    chart_id = signalfx_time_chart.vllm_itl.id
    width    = 4
    height   = 1
    row      = 2
    column   = 4
  }

  chart {
    chart_id = signalfx_time_chart.vllm_e2e.id
    width    = 4
    height   = 1
    row      = 2
    column   = 8
  }
}
