
resource "signalfx_dashboard" "memcacheddashboard" {
  name            = "memcached"
  dashboard_group = signalfx_dashboard_group.memcacheddashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.memcached_bytes.id, signalfx_time_chart.memcached_connections_current.id, signalfx_time_chart.memcached_connections_total.id, signalfx_time_chart.memcached_commands.id, signalfx_time_chart.memcached_current_items.id, signalfx_time_chart.memcached_evictions.id, signalfx_time_chart.memcached_network.id, signalfx_time_chart.memcached_operations.id, signalfx_time_chart.memcached_operation_hit_ratio.id, signalfx_time_chart.memcached_cpu_usage.id, signalfx_time_chart.memcached_threads.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "memcacheddashboardgroup0" {
  name        = "memcached generated OTel dashboard group"
  description = "memcached generated OTel dashboard group"
}

resource "signalfx_time_chart" "memcached_bytes" {
  name = "Current number of bytes used by this server to store items."

  program_text = <<-EOF
    data("memcached.bytes").publish(label="Current number of bytes used by this server to store items.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_connections_current" {
  name = "The current number of open connections."

  program_text = <<-EOF
    data("memcached.connections.current").publish(label="The current number of open connections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_connections_total" {
  name = "Total number of connections opened since the server started running."

  program_text = <<-EOF
    data("memcached.connections.total").publish(label="Total number of connections opened since the server started running.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_commands" {
  name = "Commands executed."

  program_text = <<-EOF
    data("memcached.commands").publish(label="Commands executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_current_items" {
  name = "Number of items currently stored in the cache."

  program_text = <<-EOF
    data("memcached.current_items").publish(label="Number of items currently stored in the cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_evictions" {
  name = "Cache item evictions."

  program_text = <<-EOF
    data("memcached.evictions").publish(label="Cache item evictions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_network" {
  name = "Bytes transferred over the network."

  program_text = <<-EOF
    data("memcached.network").publish(label="Bytes transferred over the network.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_operations" {
  name = "Operation counts."

  program_text = <<-EOF
    data("memcached.operations").publish(label="Operation counts.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_operation_hit_ratio" {
  name = "Hit ratio for operations, expressed as a percentage value between 0.0 and 100.0."

  program_text = <<-EOF
    data("memcached.operation_hit_ratio").publish(label="Hit ratio for operations, expressed as a percentage value between 0.0 and 100.0.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_cpu_usage" {
  name = "Accumulated user and system time."

  program_text = <<-EOF
    data("memcached.cpu.usage").publish(label="Accumulated user and system time.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "memcached_threads" {
  name = "Number of threads used by the memcached instance."

  program_text = <<-EOF
    data("memcached.threads").publish(label="Number of threads used by the memcached instance.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
