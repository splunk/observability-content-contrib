
resource "signalfx_dashboard" "riakdashboard" {
  name            = "riak"
  dashboard_group = signalfx_dashboard_group.riakdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.riak_node_operation_count.id, signalfx_time_chart.riak_node_operation_time_mean.id, signalfx_time_chart.riak_node_read_repair_count.id, signalfx_time_chart.riak_memory_limit.id, signalfx_time_chart.riak_vnode_operation_count.id, signalfx_time_chart.riak_vnode_index_operation_count.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "riakdashboardgroup0" {
  name        = "riak generated OTel dashboard group"
  description = "riak generated OTel dashboard group"
}

resource "signalfx_time_chart" "riak_node_operation_count" {
  name = "The number of operations performed by the node."

  program_text = <<-EOF
    data("riak.node.operation.count").publish(label="The number of operations performed by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "riak_node_operation_time_mean" {
  name = "The mean time between request and response for operations performed by the node over the last minute."

  program_text = <<-EOF
    data("riak.node.operation.time.mean").publish(label="The mean time between request and response for operations performed by the node over the last minute.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "riak_node_read_repair_count" {
  name = "The number of read repairs performed by the node."

  program_text = <<-EOF
    data("riak.node.read_repair.count").publish(label="The number of read repairs performed by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "riak_memory_limit" {
  name = "The amount of memory allocated to the node."

  program_text = <<-EOF
    data("riak.memory.limit").publish(label="The amount of memory allocated to the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "riak_vnode_operation_count" {
  name = "The number of operations performed by vnodes on the node."

  program_text = <<-EOF
    data("riak.vnode.operation.count").publish(label="The number of operations performed by vnodes on the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "riak_vnode_index_operation_count" {
  name = "The number of index operations performed by vnodes on the node."

  program_text = <<-EOF
    data("riak.vnode.index.operation.count").publish(label="The number of index operations performed by vnodes on the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
