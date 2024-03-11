
resource "signalfx_dashboard" "bigipdashboard" {
  name            = "bigip"
  dashboard_group = signalfx_dashboard_group.bigipdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.bigip_virtual_server_data_transmitted.id, signalfx_time_chart.bigip_virtual_server_connection_count.id, signalfx_time_chart.bigip_virtual_server_request_count.id, signalfx_time_chart.bigip_virtual_server_packet_count.id, signalfx_time_chart.bigip_virtual_server_availability.id, signalfx_time_chart.bigip_virtual_server_enabled.id, signalfx_time_chart.bigip_pool_data_transmitted.id, signalfx_time_chart.bigip_pool_connection_count.id, signalfx_time_chart.bigip_pool_request_count.id, signalfx_time_chart.bigip_pool_packet_count.id, signalfx_time_chart.bigip_pool_member_count.id, signalfx_time_chart.bigip_pool_availability.id, signalfx_time_chart.bigip_pool_enabled.id, signalfx_time_chart.bigip_pool_member_data_transmitted.id, signalfx_time_chart.bigip_pool_member_connection_count.id, signalfx_time_chart.bigip_pool_member_request_count.id, signalfx_time_chart.bigip_pool_member_packet_count.id, signalfx_time_chart.bigip_pool_member_session_count.id, signalfx_time_chart.bigip_pool_member_availability.id, signalfx_time_chart.bigip_pool_member_enabled.id, signalfx_time_chart.bigip_node_data_transmitted.id, signalfx_time_chart.bigip_node_connection_count.id, signalfx_time_chart.bigip_node_request_count.id, signalfx_time_chart.bigip_node_packet_count.id, signalfx_time_chart.bigip_node_session_count.id, signalfx_time_chart.bigip_node_availability.id, signalfx_time_chart.bigip_node_enabled.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "bigipdashboardgroup0" {
  name        = "bigip generated OTel dashboard group"
  description = "bigip generated OTel dashboard group"
}

resource "signalfx_time_chart" "bigip_virtual_server_data_transmitted" {
  name = "Amount of data transmitted to and from the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.data.transmitted").publish(label="Amount of data transmitted to and from the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_virtual_server_connection_count" {
  name = "Current number of connections to the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.connection.count").publish(label="Current number of connections to the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_virtual_server_request_count" {
  name = "Number of requests to the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.request.count").publish(label="Number of requests to the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_virtual_server_packet_count" {
  name = "Number of packets transmitted to and from the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.packet.count").publish(label="Number of packets transmitted to and from the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_virtual_server_availability" {
  name = "Availability of the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.availability").publish(label="Availability of the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_virtual_server_enabled" {
  name = "Enabled state of of the virtual server."

  program_text = <<-EOF
    data("bigip.virtual_server.enabled").publish(label="Enabled state of of the virtual server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_data_transmitted" {
  name = "Amount of data transmitted to and from the pool."

  program_text = <<-EOF
    data("bigip.pool.data.transmitted").publish(label="Amount of data transmitted to and from the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_connection_count" {
  name = "Current number of connections to the pool."

  program_text = <<-EOF
    data("bigip.pool.connection.count").publish(label="Current number of connections to the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_request_count" {
  name = "Number of requests to the pool."

  program_text = <<-EOF
    data("bigip.pool.request.count").publish(label="Number of requests to the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_packet_count" {
  name = "Number of packets transmitted to and from the pool."

  program_text = <<-EOF
    data("bigip.pool.packet.count").publish(label="Number of packets transmitted to and from the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_count" {
  name = "Total number of pool members."

  program_text = <<-EOF
    data("bigip.pool.member.count").publish(label="Total number of pool members.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_availability" {
  name = "Availability of the pool."

  program_text = <<-EOF
    data("bigip.pool.availability").publish(label="Availability of the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_enabled" {
  name = "Enabled state of of the pool."

  program_text = <<-EOF
    data("bigip.pool.enabled").publish(label="Enabled state of of the pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_data_transmitted" {
  name = "Amount of data transmitted to and from the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.data.transmitted").publish(label="Amount of data transmitted to and from the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_connection_count" {
  name = "Current number of connections to the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.connection.count").publish(label="Current number of connections to the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_request_count" {
  name = "Number of requests to the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.request.count").publish(label="Number of requests to the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_packet_count" {
  name = "Number of packets transmitted to and from the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.packet.count").publish(label="Number of packets transmitted to and from the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_session_count" {
  name = "Current number of sessions for the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.session.count").publish(label="Current number of sessions for the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_availability" {
  name = "Availability of the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.availability").publish(label="Availability of the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_pool_member_enabled" {
  name = "Enabled state of of the pool member."

  program_text = <<-EOF
    data("bigip.pool_member.enabled").publish(label="Enabled state of of the pool member.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_data_transmitted" {
  name = "Amount of data transmitted to and from the node."

  program_text = <<-EOF
    data("bigip.node.data.transmitted").publish(label="Amount of data transmitted to and from the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_connection_count" {
  name = "Current number of connections to the node."

  program_text = <<-EOF
    data("bigip.node.connection.count").publish(label="Current number of connections to the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_request_count" {
  name = "Number of requests to the node."

  program_text = <<-EOF
    data("bigip.node.request.count").publish(label="Number of requests to the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_packet_count" {
  name = "Number of packets transmitted to and from the node."

  program_text = <<-EOF
    data("bigip.node.packet.count").publish(label="Number of packets transmitted to and from the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_session_count" {
  name = "Current number of sessions for the node."

  program_text = <<-EOF
    data("bigip.node.session.count").publish(label="Current number of sessions for the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_availability" {
  name = "Availability of the node."

  program_text = <<-EOF
    data("bigip.node.availability").publish(label="Availability of the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "bigip_node_enabled" {
  name = "Enabled state of of the node."

  program_text = <<-EOF
    data("bigip.node.enabled").publish(label="Enabled state of of the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
