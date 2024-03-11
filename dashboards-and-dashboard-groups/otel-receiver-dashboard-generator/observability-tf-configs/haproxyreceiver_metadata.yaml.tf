
resource "signalfx_dashboard" "haproxydashboard" {
  name            = "haproxy"
  dashboard_group = signalfx_dashboard_group.haproxydashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.haproxy_connections_rate.id, signalfx_time_chart.haproxy_sessions_count.id, signalfx_time_chart.haproxy_connections_total.id, signalfx_time_chart.haproxy_server_selected_total.id, signalfx_time_chart.haproxy_bytes_input.id, signalfx_time_chart.haproxy_bytes_output.id, signalfx_time_chart.haproxy_clients_canceled.id, signalfx_time_chart.haproxy_compression_bypass.id, signalfx_time_chart.haproxy_compression_input.id, signalfx_time_chart.haproxy_compression_output.id, signalfx_time_chart.haproxy_compression_count.id, signalfx_time_chart.haproxy_requests_denied.id, signalfx_time_chart.haproxy_responses_denied.id, signalfx_time_chart.haproxy_downtime.id, signalfx_time_chart.haproxy_connections_errors.id, signalfx_time_chart.haproxy_requests_errors.id, signalfx_time_chart.haproxy_responses_errors.id, signalfx_time_chart.haproxy_failed_checks.id, signalfx_time_chart.haproxy_requests_redispatched.id, signalfx_time_chart.haproxy_requests_total.id, signalfx_time_chart.haproxy_connections_retries.id, signalfx_time_chart.haproxy_sessions_total.id, signalfx_time_chart.haproxy_requests_queued.id, signalfx_time_chart.haproxy_requests_rate.id, signalfx_time_chart.haproxy_sessions_average.id, signalfx_time_chart.haproxy_sessions_rate.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "haproxydashboardgroup0" {
  name        = "haproxy generated OTel dashboard group"
  description = "haproxy generated OTel dashboard group"
}

resource "signalfx_time_chart" "haproxy_connections_rate" {
  name = "Number of connections over the last elapsed second (frontend). Corresponds to HAProxy's `conn_rate` metric."

  program_text = <<-EOF
    data("haproxy.connections.rate").publish(label="Number of connections over the last elapsed second (frontend). Corresponds to HAProxy's `conn_rate` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_sessions_count" {
  name = "Current sessions. Corresponds to HAProxy's `scur` metric."

  program_text = <<-EOF
    data("haproxy.sessions.count").publish(label="Current sessions. Corresponds to HAProxy's `scur` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_connections_total" {
  name = "Cumulative number of connections (frontend). Corresponds to HAProxy's `conn_tot` metric."

  program_text = <<-EOF
    data("haproxy.connections.total").publish(label="Cumulative number of connections (frontend). Corresponds to HAProxy's `conn_tot` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_server_selected_total" {
  name = "Number of times a server was selected, either for new sessions or when re-dispatching. Corresponds to HAProxy's `lbtot` metric."

  program_text = <<-EOF
    data("haproxy.server_selected.total").publish(label="Number of times a server was selected, either for new sessions or when re-dispatching. Corresponds to HAProxy's `lbtot` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_bytes_input" {
  name = "Bytes in. Corresponds to HAProxy's `bin` metric."

  program_text = <<-EOF
    data("haproxy.bytes.input").publish(label="Bytes in. Corresponds to HAProxy's `bin` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_bytes_output" {
  name = "Bytes out. Corresponds to HAProxy's `bout` metric."

  program_text = <<-EOF
    data("haproxy.bytes.output").publish(label="Bytes out. Corresponds to HAProxy's `bout` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_clients_canceled" {
  name = "Number of data transfers aborted by the client. Corresponds to HAProxy's `cli_abrt` metric"

  program_text = <<-EOF
    data("haproxy.clients.canceled").publish(label="Number of data transfers aborted by the client. Corresponds to HAProxy's `cli_abrt` metric")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_compression_bypass" {
  name = "Number of bytes that bypassed the HTTP compressor (CPU/BW limit). Corresponds to HAProxy's `comp_byp` metric."

  program_text = <<-EOF
    data("haproxy.compression.bypass").publish(label="Number of bytes that bypassed the HTTP compressor (CPU/BW limit). Corresponds to HAProxy's `comp_byp` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_compression_input" {
  name = "Number of HTTP response bytes fed to the compressor. Corresponds to HAProxy's `comp_in` metric."

  program_text = <<-EOF
    data("haproxy.compression.input").publish(label="Number of HTTP response bytes fed to the compressor. Corresponds to HAProxy's `comp_in` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_compression_output" {
  name = "Number of HTTP response bytes emitted by the compressor. Corresponds to HAProxy's `comp_out` metric."

  program_text = <<-EOF
    data("haproxy.compression.output").publish(label="Number of HTTP response bytes emitted by the compressor. Corresponds to HAProxy's `comp_out` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_compression_count" {
  name = "Number of HTTP responses that were compressed. Corresponds to HAProxy's `comp_rsp` metric."

  program_text = <<-EOF
    data("haproxy.compression.count").publish(label="Number of HTTP responses that were compressed. Corresponds to HAProxy's `comp_rsp` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_denied" {
  name = "Requests denied because of security concerns. Corresponds to HAProxy's `dreq` metric"

  program_text = <<-EOF
    data("haproxy.requests.denied").publish(label="Requests denied because of security concerns. Corresponds to HAProxy's `dreq` metric")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_responses_denied" {
  name = "Responses denied because of security concerns. Corresponds to HAProxy's `dresp` metric"

  program_text = <<-EOF
    data("haproxy.responses.denied").publish(label="Responses denied because of security concerns. Corresponds to HAProxy's `dresp` metric")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_downtime" {
  name = "Total downtime (in seconds). The value for the backend is the downtime for the whole backend, not the sum of the server downtime. Corresponds to HAProxy's `downtime` metric"

  program_text = <<-EOF
    data("haproxy.downtime").publish(label="Total downtime (in seconds). The value for the backend is the downtime for the whole backend, not the sum of the server downtime. Corresponds to HAProxy's `downtime` metric")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_connections_errors" {
  name = "Number of requests that encountered an error trying to connect to a backend server. The backend stat is the sum of the stat. Corresponds to HAProxy's `econ` metric"

  program_text = <<-EOF
    data("haproxy.connections.errors").publish(label="Number of requests that encountered an error trying to connect to a backend server. The backend stat is the sum of the stat. Corresponds to HAProxy's `econ` metric")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_errors" {
  name = "Cumulative number of request errors. Corresponds to HAProxy's `ereq` metric."

  program_text = <<-EOF
    data("haproxy.requests.errors").publish(label="Cumulative number of request errors. Corresponds to HAProxy's `ereq` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_responses_errors" {
  name = "Cumulative number of response errors. Corresponds to HAProxy's `eresp` metric, `srv_abrt` will be counted here also."

  program_text = <<-EOF
    data("haproxy.responses.errors").publish(label="Cumulative number of response errors. Corresponds to HAProxy's `eresp` metric, `srv_abrt` will be counted here also.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_failed_checks" {
  name = "Number of failed checks. (Only counts checks failed when the server is up). Corresponds to HAProxy's `chkfail` metric."

  program_text = <<-EOF
    data("haproxy.failed_checks").publish(label="Number of failed checks. (Only counts checks failed when the server is up). Corresponds to HAProxy's `chkfail` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_redispatched" {
  name = "Number of times a request was redispatched to another server. Corresponds to HAProxy's `wredis` metric."

  program_text = <<-EOF
    data("haproxy.requests.redispatched").publish(label="Number of times a request was redispatched to another server. Corresponds to HAProxy's `wredis` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_total" {
  name = "Total number of HTTP requests received. Corresponds to HAProxy's `req_tot`, `hrsp_1xx`, `hrsp_2xx`, `hrsp_3xx`, `hrsp_4xx`, `hrsp_5xx` and `hrsp_other` metrics."

  program_text = <<-EOF
    data("haproxy.requests.total").publish(label="Total number of HTTP requests received. Corresponds to HAProxy's `req_tot`, `hrsp_1xx`, `hrsp_2xx`, `hrsp_3xx`, `hrsp_4xx`, `hrsp_5xx` and `hrsp_other` metrics.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_connections_retries" {
  name = "Number of times a connection to a server was retried. Corresponds to HAProxy's `wretr` metric."

  program_text = <<-EOF
    data("haproxy.connections.retries").publish(label="Number of times a connection to a server was retried. Corresponds to HAProxy's `wretr` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_sessions_total" {
  name = "Cumulative number of sessions. Corresponds to HAProxy's `stot` metric."

  program_text = <<-EOF
    data("haproxy.sessions.total").publish(label="Cumulative number of sessions. Corresponds to HAProxy's `stot` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_queued" {
  name = "Current queued requests. For the backend this reports the number queued without a server assigned. Corresponds to HAProxy's `qcur` metric."

  program_text = <<-EOF
    data("haproxy.requests.queued").publish(label="Current queued requests. For the backend this reports the number queued without a server assigned. Corresponds to HAProxy's `qcur` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_requests_rate" {
  name = "HTTP requests per second over last elapsed second. Corresponds to HAProxy's `req_rate` metric."

  program_text = <<-EOF
    data("haproxy.requests.rate").publish(label="HTTP requests per second over last elapsed second. Corresponds to HAProxy's `req_rate` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_sessions_average" {
  name = "Average total session time in ms over the last 1024 requests. Corresponds to HAProxy's `ttime` metric."

  program_text = <<-EOF
    data("haproxy.sessions.average").publish(label="Average total session time in ms over the last 1024 requests. Corresponds to HAProxy's `ttime` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "haproxy_sessions_rate" {
  name = "Number of sessions per second over last elapsed second. Corresponds to HAProxy's `rate` metric."

  program_text = <<-EOF
    data("haproxy.sessions.rate").publish(label="Number of sessions per second over last elapsed second. Corresponds to HAProxy's `rate` metric.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
