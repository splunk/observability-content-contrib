
resource "signalfx_dashboard" "apachedashboard" {
  name            = "apache"
  dashboard_group = signalfx_dashboard_group.apachedashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.apache_uptime.id, signalfx_time_chart.apache_current_connections.id, signalfx_time_chart.apache_workers.id, signalfx_time_chart.apache_requests.id, signalfx_time_chart.apache_traffic.id, signalfx_time_chart.apache_cpu_time.id, signalfx_time_chart.apache_cpu_load.id, signalfx_time_chart.apache_load_1.id, signalfx_time_chart.apache_load_5.id, signalfx_time_chart.apache_load_15.id, signalfx_time_chart.apache_request_time.id, signalfx_time_chart.apache_scoreboard.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "apachedashboardgroup0" {
  name        = "apache generated OTel dashboard group"
  description = "apache generated OTel dashboard group"
}

resource "signalfx_time_chart" "apache_uptime" {
  name = "The amount of time that the server has been running in seconds."

  program_text = <<-EOF
    data("apache.uptime").publish(label="The amount of time that the server has been running in seconds.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_current_connections" {
  name = "The number of active connections currently attached to the HTTP server."

  program_text = <<-EOF
    data("apache.current_connections").publish(label="The number of active connections currently attached to the HTTP server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_workers" {
  name = "The number of workers currently attached to the HTTP server."

  program_text = <<-EOF
    data("apache.workers").publish(label="The number of workers currently attached to the HTTP server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_requests" {
  name = "The number of requests serviced by the HTTP server per second."

  program_text = <<-EOF
    data("apache.requests").publish(label="The number of requests serviced by the HTTP server per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_traffic" {
  name = "Total HTTP server traffic."

  program_text = <<-EOF
    data("apache.traffic").publish(label="Total HTTP server traffic.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_cpu_time" {
  name = "Jiffs used by processes of given category."

  program_text = <<-EOF
    data("apache.cpu.time").publish(label="Jiffs used by processes of given category.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_cpu_load" {
  name = "Current load of the CPU."

  program_text = <<-EOF
    data("apache.cpu.load").publish(label="Current load of the CPU.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_load_1" {
  name = "The average server load during the last minute."

  program_text = <<-EOF
    data("apache.load.1").publish(label="The average server load during the last minute.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_load_5" {
  name = "The average server load during the last 5 minutes."

  program_text = <<-EOF
    data("apache.load.5").publish(label="The average server load during the last 5 minutes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_load_15" {
  name = "The average server load during the last 15 minutes."

  program_text = <<-EOF
    data("apache.load.15").publish(label="The average server load during the last 15 minutes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_request_time" {
  name = "Total time spent on handling requests."

  program_text = <<-EOF
    data("apache.request.time").publish(label="Total time spent on handling requests.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "apache_scoreboard" {
  name = "The number of workers in each state."

  program_text = <<-EOF
    data("apache.scoreboard").publish(label="The number of workers in each state.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
