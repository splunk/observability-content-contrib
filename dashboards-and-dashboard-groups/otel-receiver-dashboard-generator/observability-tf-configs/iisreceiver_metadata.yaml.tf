
resource "signalfx_dashboard" "iisdashboard" {
  name            = "iis"
  dashboard_group = signalfx_dashboard_group.iisdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.iis_request_count.id, signalfx_time_chart.iis_request_rejected.id, signalfx_time_chart.iis_request_queue_count.id, signalfx_time_chart.iis_request_queue_age_max.id, signalfx_time_chart.iis_network_file_count.id, signalfx_time_chart.iis_network_blocked.id, signalfx_time_chart.iis_network_io.id, signalfx_time_chart.iis_connection_attempt_count.id, signalfx_time_chart.iis_connection_active.id, signalfx_time_chart.iis_connection_anonymous.id, signalfx_time_chart.iis_thread_active.id, signalfx_time_chart.iis_uptime.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "iisdashboardgroup0" {
  name        = "iis generated OTel dashboard group"
  description = "iis generated OTel dashboard group"
}

resource "signalfx_time_chart" "iis_request_count" {
  name = "Total number of requests of a given type."

  program_text = <<-EOF
    data("iis.request.count").publish(label="Total number of requests of a given type.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_request_rejected" {
  name = "Total number of requests rejected."

  program_text = <<-EOF
    data("iis.request.rejected").publish(label="Total number of requests rejected.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_request_queue_count" {
  name = "Current number of requests in the queue."

  program_text = <<-EOF
    data("iis.request.queue.count").publish(label="Current number of requests in the queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_request_queue_age_max" {
  name = "Age of oldest request in the queue."

  program_text = <<-EOF
    data("iis.request.queue.age.max").publish(label="Age of oldest request in the queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_network_file_count" {
  name = "Number of transmitted files."

  program_text = <<-EOF
    data("iis.network.file.count").publish(label="Number of transmitted files.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_network_blocked" {
  name = "Number of bytes blocked due to bandwidth throttling."

  program_text = <<-EOF
    data("iis.network.blocked").publish(label="Number of bytes blocked due to bandwidth throttling.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_network_io" {
  name = "Total amount of bytes sent and received."

  program_text = <<-EOF
    data("iis.network.io").publish(label="Total amount of bytes sent and received.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_connection_attempt_count" {
  name = "Total number of attempts to connect to the server."

  program_text = <<-EOF
    data("iis.connection.attempt.count").publish(label="Total number of attempts to connect to the server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_connection_active" {
  name = "Number of active connections."

  program_text = <<-EOF
    data("iis.connection.active").publish(label="Number of active connections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_connection_anonymous" {
  name = "Number of connections established anonymously."

  program_text = <<-EOF
    data("iis.connection.anonymous").publish(label="Number of connections established anonymously.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_thread_active" {
  name = "Current number of active threads."

  program_text = <<-EOF
    data("iis.thread.active").publish(label="Current number of active threads.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "iis_uptime" {
  name = "The amount of time the server has been up."

  program_text = <<-EOF
    data("iis.uptime").publish(label="The amount of time the server has been up.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
