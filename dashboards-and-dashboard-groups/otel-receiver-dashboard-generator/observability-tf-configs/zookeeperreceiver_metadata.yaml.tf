
resource "signalfx_dashboard" "zookeeperdashboard" {
  name            = "zookeeper"
  dashboard_group = signalfx_dashboard_group.zookeeperdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.zookeeper_follower_count.id, signalfx_time_chart.zookeeper_sync_pending.id, signalfx_time_chart.zookeeper_latency_avg.id, signalfx_time_chart.zookeeper_latency_max.id, signalfx_time_chart.zookeeper_latency_min.id, signalfx_time_chart.zookeeper_connection_active.id, signalfx_time_chart.zookeeper_request_active.id, signalfx_time_chart.zookeeper_znode_count.id, signalfx_time_chart.zookeeper_watch_count.id, signalfx_time_chart.zookeeper_data_tree_ephemeral_node_count.id, signalfx_time_chart.zookeeper_data_tree_size.id, signalfx_time_chart.zookeeper_file_descriptor_open.id, signalfx_time_chart.zookeeper_file_descriptor_limit.id, signalfx_time_chart.zookeeper_packet_count.id, signalfx_time_chart.zookeeper_fsync_exceeded_threshold_count.id, signalfx_time_chart.zookeeper_ruok.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "zookeeperdashboardgroup0" {
  name        = "zookeeper generated OTel dashboard group"
  description = "zookeeper generated OTel dashboard group"
}

resource "signalfx_time_chart" "zookeeper_follower_count" {
  name = "The number of followers. Only exposed by the leader."

  program_text = <<-EOF
    data("zookeeper.follower.count").publish(label="The number of followers. Only exposed by the leader.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_sync_pending" {
  name = "The number of pending syncs from the followers. Only exposed by the leader."

  program_text = <<-EOF
    data("zookeeper.sync.pending").publish(label="The number of pending syncs from the followers. Only exposed by the leader.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_latency_avg" {
  name = "Average time in milliseconds for requests to be processed."

  program_text = <<-EOF
    data("zookeeper.latency.avg").publish(label="Average time in milliseconds for requests to be processed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_latency_max" {
  name = "Maximum time in milliseconds for requests to be processed."

  program_text = <<-EOF
    data("zookeeper.latency.max").publish(label="Maximum time in milliseconds for requests to be processed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_latency_min" {
  name = "Minimum time in milliseconds for requests to be processed."

  program_text = <<-EOF
    data("zookeeper.latency.min").publish(label="Minimum time in milliseconds for requests to be processed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_connection_active" {
  name = "Number of active clients connected to a ZooKeeper server."

  program_text = <<-EOF
    data("zookeeper.connection.active").publish(label="Number of active clients connected to a ZooKeeper server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_request_active" {
  name = "Number of currently executing requests."

  program_text = <<-EOF
    data("zookeeper.request.active").publish(label="Number of currently executing requests.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_znode_count" {
  name = "Number of z-nodes that a ZooKeeper server has in its data tree."

  program_text = <<-EOF
    data("zookeeper.znode.count").publish(label="Number of z-nodes that a ZooKeeper server has in its data tree.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_watch_count" {
  name = "Number of watches placed on Z-Nodes on a ZooKeeper server."

  program_text = <<-EOF
    data("zookeeper.watch.count").publish(label="Number of watches placed on Z-Nodes on a ZooKeeper server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_data_tree_ephemeral_node_count" {
  name = "Number of ephemeral nodes that a ZooKeeper server has in its data tree."

  program_text = <<-EOF
    data("zookeeper.data_tree.ephemeral_node.count").publish(label="Number of ephemeral nodes that a ZooKeeper server has in its data tree.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_data_tree_size" {
  name = "Size of data in bytes that a ZooKeeper server has in its data tree."

  program_text = <<-EOF
    data("zookeeper.data_tree.size").publish(label="Size of data in bytes that a ZooKeeper server has in its data tree.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_file_descriptor_open" {
  name = "Number of file descriptors that a ZooKeeper server has open."

  program_text = <<-EOF
    data("zookeeper.file_descriptor.open").publish(label="Number of file descriptors that a ZooKeeper server has open.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_file_descriptor_limit" {
  name = "Maximum number of file descriptors that a ZooKeeper server can open."

  program_text = <<-EOF
    data("zookeeper.file_descriptor.limit").publish(label="Maximum number of file descriptors that a ZooKeeper server can open.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_packet_count" {
  name = "The number of ZooKeeper packets received or sent by a server."

  program_text = <<-EOF
    data("zookeeper.packet.count").publish(label="The number of ZooKeeper packets received or sent by a server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_fsync_exceeded_threshold_count" {
  name = "Number of times fsync duration has exceeded warning threshold."

  program_text = <<-EOF
    data("zookeeper.fsync.exceeded_threshold.count").publish(label="Number of times fsync duration has exceeded warning threshold.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "zookeeper_ruok" {
  name = "Response from zookeeper ruok command"

  program_text = <<-EOF
    data("zookeeper.ruok").publish(label="Response from zookeeper ruok command")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
