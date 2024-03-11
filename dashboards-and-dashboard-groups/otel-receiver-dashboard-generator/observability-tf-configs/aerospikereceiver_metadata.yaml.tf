
resource "signalfx_dashboard" "aerospikedashboard" {
  name            = "aerospike"
  dashboard_group = signalfx_dashboard_group.aerospikedashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.aerospike_node_memory_free.id, signalfx_time_chart.aerospike_node_connection_count.id, signalfx_time_chart.aerospike_node_connection_open.id, signalfx_time_chart.aerospike_node_query_tracked.id, signalfx_time_chart.aerospike_namespace_memory_usage.id, signalfx_time_chart.aerospike_namespace_memory_free.id, signalfx_time_chart.aerospike_namespace_disk_available.id, signalfx_time_chart.aerospike_namespace_scan_count.id, signalfx_time_chart.aerospike_namespace_query_count.id, signalfx_time_chart.aerospike_namespace_geojson_region_query_cells.id, signalfx_time_chart.aerospike_namespace_geojson_region_query_false_positive.id, signalfx_time_chart.aerospike_namespace_geojson_region_query_points.id, signalfx_time_chart.aerospike_namespace_geojson_region_query_requests.id, signalfx_time_chart.aerospike_namespace_transaction_count.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "aerospikedashboardgroup0" {
  name        = "aerospike generated OTel dashboard group"
  description = "aerospike generated OTel dashboard group"
}

resource "signalfx_time_chart" "aerospike_node_memory_free" {
  name = "Percentage of the node's memory which is still free"

  program_text = <<-EOF
    data("aerospike.node.memory.free").publish(label="Percentage of the node's memory which is still free")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_node_connection_count" {
  name = "Number of connections opened and closed to the node"

  program_text = <<-EOF
    data("aerospike.node.connection.count").publish(label="Number of connections opened and closed to the node")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_node_connection_open" {
  name = "Current number of open connections to the node"

  program_text = <<-EOF
    data("aerospike.node.connection.open").publish(label="Current number of open connections to the node")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_node_query_tracked" {
  name = "Number of queries tracked by the system."

  program_text = <<-EOF
    data("aerospike.node.query.tracked").publish(label="Number of queries tracked by the system.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_memory_usage" {
  name = "Memory currently used by each component of the namespace"

  program_text = <<-EOF
    data("aerospike.namespace.memory.usage").publish(label="Memory currently used by each component of the namespace")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_memory_free" {
  name = "Percentage of the namespace's memory which is still free"

  program_text = <<-EOF
    data("aerospike.namespace.memory.free").publish(label="Percentage of the namespace's memory which is still free")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_disk_available" {
  name = "Minimum percentage of contiguous disk space free to the namespace across all devices"

  program_text = <<-EOF
    data("aerospike.namespace.disk.available").publish(label="Minimum percentage of contiguous disk space free to the namespace across all devices")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_scan_count" {
  name = "Number of scan operations performed on the namespace"

  program_text = <<-EOF
    data("aerospike.namespace.scan.count").publish(label="Number of scan operations performed on the namespace")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_query_count" {
  name = "Number of query operations performed on the namespace"

  program_text = <<-EOF
    data("aerospike.namespace.query.count").publish(label="Number of query operations performed on the namespace")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_geojson_region_query_cells" {
  name = "Number of cell coverings for query region queried"

  program_text = <<-EOF
    data("aerospike.namespace.geojson.region_query_cells").publish(label="Number of cell coverings for query region queried")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_geojson_region_query_false_positive" {
  name = "Number of points outside the region."

  program_text = <<-EOF
    data("aerospike.namespace.geojson.region_query_false_positive").publish(label="Number of points outside the region.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_geojson_region_query_points" {
  name = "Number of points within the region."

  program_text = <<-EOF
    data("aerospike.namespace.geojson.region_query_points").publish(label="Number of points within the region.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_geojson_region_query_requests" {
  name = "Number of geojson queries on the system since the uptime of the node."

  program_text = <<-EOF
    data("aerospike.namespace.geojson.region_query_requests").publish(label="Number of geojson queries on the system since the uptime of the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "aerospike_namespace_transaction_count" {
  name = "Number of transactions performed on the namespace"

  program_text = <<-EOF
    data("aerospike.namespace.transaction.count").publish(label="Number of transactions performed on the namespace")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
