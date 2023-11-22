
resource "signalfx_dashboard" "nginxdashboard" {
  name            = "nginx"
  dashboard_group = signalfx_dashboard_group.nginxdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.nginx_requests.id, signalfx_time_chart.nginx_connections_accepted.id, signalfx_time_chart.nginx_connections_handled.id, signalfx_time_chart.nginx_connections_current.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "nginxdashboardgroup0" {
  name        = "nginx generated OTel dashboard group"
  description = "nginx generated OTel dashboard group"
}

resource "signalfx_time_chart" "nginx_requests" {
  name = "Total number of requests made to the server since it started"

  program_text = <<-EOF
    data("nginx.requests").publish(label="Total number of requests made to the server since it started")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nginx_connections_accepted" {
  name = "The total number of accepted client connections"

  program_text = <<-EOF
    data("nginx.connections_accepted").publish(label="The total number of accepted client connections")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nginx_connections_handled" {
  name = "The total number of handled connections. Generally, the parameter value is the same as nginx.connections_accepted unless some resource limits have been reached (for example, the worker_connections limit)."

  program_text = <<-EOF
    data("nginx.connections_handled").publish(label="The total number of handled connections. Generally, the parameter value is the same as nginx.connections_accepted unless some resource limits have been reached (for example, the worker_connections limit).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nginx_connections_current" {
  name = "The current number of nginx connections by state"

  program_text = <<-EOF
    data("nginx.connections_current").publish(label="The current number of nginx connections by state")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
