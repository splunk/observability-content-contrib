
resource "signalfx_dashboard" "nsxtdashboard" {
  name            = "nsxt"
  dashboard_group = signalfx_dashboard_group.nsxtdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.nsxt_node_network_io.id, signalfx_time_chart.nsxt_node_network_packet_count.id, signalfx_time_chart.nsxt_node_cpu_utilization.id, signalfx_time_chart.nsxt_node_filesystem_utilization.id, signalfx_time_chart.nsxt_node_filesystem_usage.id, signalfx_time_chart.nsxt_node_memory_usage.id, signalfx_time_chart.nsxt_node_memory_cache_usage.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "nsxtdashboardgroup0" {
  name        = "nsxt generated OTel dashboard group"
  description = "nsxt generated OTel dashboard group"
}

resource "signalfx_time_chart" "nsxt_node_network_io" {
  name = "The number of bytes which have flowed through the network interface."

  program_text = <<-EOF
    data("nsxt.node.network.io").publish(label="The number of bytes which have flowed through the network interface.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_network_packet_count" {
  name = "The number of packets which have flowed through the network interface on the node."

  program_text = <<-EOF
    data("nsxt.node.network.packet.count").publish(label="The number of packets which have flowed through the network interface on the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_cpu_utilization" {
  name = "The average amount of CPU being used by the node."

  program_text = <<-EOF
    data("nsxt.node.cpu.utilization").publish(label="The average amount of CPU being used by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_filesystem_utilization" {
  name = "The percentage of storage space utilized."

  program_text = <<-EOF
    data("nsxt.node.filesystem.utilization").publish(label="The percentage of storage space utilized.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_filesystem_usage" {
  name = "The amount of storage space used by the node."

  program_text = <<-EOF
    data("nsxt.node.filesystem.usage").publish(label="The amount of storage space used by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_memory_usage" {
  name = "The memory usage of the node."

  program_text = <<-EOF
    data("nsxt.node.memory.usage").publish(label="The memory usage of the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "nsxt_node_memory_cache_usage" {
  name = "The size of the node's memory cache."

  program_text = <<-EOF
    data("nsxt.node.memory.cache.usage").publish(label="The size of the node's memory cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
