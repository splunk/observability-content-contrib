
resource "signalfx_dashboard" "mongodbdashboard" {
  name            = "mongodb"
  dashboard_group = signalfx_dashboard_group.mongodbdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.mongodb_cache_operations.id, signalfx_time_chart.mongodb_collection_count.id, signalfx_time_chart.mongodb_data_size.id, signalfx_time_chart.mongodb_connection_count.id, signalfx_time_chart.mongodb_extent_count.id, signalfx_time_chart.mongodb_global_lock_time.id, signalfx_time_chart.mongodb_index_count.id, signalfx_time_chart.mongodb_index_size.id, signalfx_time_chart.mongodb_memory_usage.id, signalfx_time_chart.mongodb_object_count.id, signalfx_time_chart.mongodb_operation_latency_time.id, signalfx_time_chart.mongodb_operation_count.id, signalfx_time_chart.mongodb_operation_repl_count.id, signalfx_time_chart.mongodb_storage_size.id, signalfx_time_chart.mongodb_database_count.id, signalfx_time_chart.mongodb_index_access_count.id, signalfx_time_chart.mongodb_document_operation_count.id, signalfx_time_chart.mongodb_network_io_receive.id, signalfx_time_chart.mongodb_network_io_transmit.id, signalfx_time_chart.mongodb_network_request_count.id, signalfx_time_chart.mongodb_operation_time.id, signalfx_time_chart.mongodb_session_count.id, signalfx_time_chart.mongodb_cursor_count.id, signalfx_time_chart.mongodb_cursor_timeout_count.id, signalfx_time_chart.mongodb_lock_acquire_count.id, signalfx_time_chart.mongodb_lock_acquire_wait_count.id, signalfx_time_chart.mongodb_lock_acquire_time.id, signalfx_time_chart.mongodb_lock_deadlock_count.id, signalfx_time_chart.mongodb_health.id, signalfx_time_chart.mongodb_uptime.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "mongodbdashboardgroup0" {
  name        = "mongodb generated OTel dashboard group"
  description = "mongodb generated OTel dashboard group"
}

resource "signalfx_time_chart" "mongodb_cache_operations" {
  name = "The number of cache operations of the instance."

  program_text = <<-EOF
    data("mongodb.cache.operations").publish(label="The number of cache operations of the instance.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_collection_count" {
  name = "The number of collections."

  program_text = <<-EOF
    data("mongodb.collection.count").publish(label="The number of collections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_data_size" {
  name = "The size of the collection. Data compression does not affect this value."

  program_text = <<-EOF
    data("mongodb.data.size").publish(label="The size of the collection. Data compression does not affect this value.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_connection_count" {
  name = "The number of connections."

  program_text = <<-EOF
    data("mongodb.connection.count").publish(label="The number of connections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_extent_count" {
  name = "The number of extents."

  program_text = <<-EOF
    data("mongodb.extent.count").publish(label="The number of extents.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_global_lock_time" {
  name = "The time the global lock has been held."

  program_text = <<-EOF
    data("mongodb.global_lock.time").publish(label="The time the global lock has been held.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_index_count" {
  name = "The number of indexes."

  program_text = <<-EOF
    data("mongodb.index.count").publish(label="The number of indexes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_index_size" {
  name = "Sum of the space allocated to all indexes in the database, including free index space."

  program_text = <<-EOF
    data("mongodb.index.size").publish(label="Sum of the space allocated to all indexes in the database, including free index space.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_memory_usage" {
  name = "The amount of memory used."

  program_text = <<-EOF
    data("mongodb.memory.usage").publish(label="The amount of memory used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_object_count" {
  name = "The number of objects."

  program_text = <<-EOF
    data("mongodb.object.count").publish(label="The number of objects.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_operation_latency_time" {
  name = "The latency of operations."

  program_text = <<-EOF
    data("mongodb.operation.latency.time").publish(label="The latency of operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_operation_count" {
  name = "The number of operations executed."

  program_text = <<-EOF
    data("mongodb.operation.count").publish(label="The number of operations executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_operation_repl_count" {
  name = "The number of replicated operations executed."

  program_text = <<-EOF
    data("mongodb.operation.repl.count").publish(label="The number of replicated operations executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_storage_size" {
  name = "The total amount of storage allocated to this collection."

  program_text = <<-EOF
    data("mongodb.storage.size").publish(label="The total amount of storage allocated to this collection.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_database_count" {
  name = "The number of existing databases."

  program_text = <<-EOF
    data("mongodb.database.count").publish(label="The number of existing databases.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_index_access_count" {
  name = "The number of times an index has been accessed."

  program_text = <<-EOF
    data("mongodb.index.access.count").publish(label="The number of times an index has been accessed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_document_operation_count" {
  name = "The number of document operations executed."

  program_text = <<-EOF
    data("mongodb.document.operation.count").publish(label="The number of document operations executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_network_io_receive" {
  name = "The number of bytes received."

  program_text = <<-EOF
    data("mongodb.network.io.receive").publish(label="The number of bytes received.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_network_io_transmit" {
  name = "The number of by transmitted."

  program_text = <<-EOF
    data("mongodb.network.io.transmit").publish(label="The number of by transmitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_network_request_count" {
  name = "The number of requests received by the server."

  program_text = <<-EOF
    data("mongodb.network.request.count").publish(label="The number of requests received by the server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_operation_time" {
  name = "The total time spent performing operations."

  program_text = <<-EOF
    data("mongodb.operation.time").publish(label="The total time spent performing operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_session_count" {
  name = "The total number of active sessions."

  program_text = <<-EOF
    data("mongodb.session.count").publish(label="The total number of active sessions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_cursor_count" {
  name = "The number of open cursors maintained for clients."

  program_text = <<-EOF
    data("mongodb.cursor.count").publish(label="The number of open cursors maintained for clients.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_cursor_timeout_count" {
  name = "The number of cursors that have timed out."

  program_text = <<-EOF
    data("mongodb.cursor.timeout.count").publish(label="The number of cursors that have timed out.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_lock_acquire_count" {
  name = "Number of times the lock was acquired in the specified mode."

  program_text = <<-EOF
    data("mongodb.lock.acquire.count").publish(label="Number of times the lock was acquired in the specified mode.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_lock_acquire_wait_count" {
  name = "Number of times the lock acquisitions encountered waits because the locks were held in a conflicting mode."

  program_text = <<-EOF
    data("mongodb.lock.acquire.wait_count").publish(label="Number of times the lock acquisitions encountered waits because the locks were held in a conflicting mode.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_lock_acquire_time" {
  name = "Cumulative wait time for the lock acquisitions."

  program_text = <<-EOF
    data("mongodb.lock.acquire.time").publish(label="Cumulative wait time for the lock acquisitions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_lock_deadlock_count" {
  name = "Number of times the lock acquisitions encountered deadlocks."

  program_text = <<-EOF
    data("mongodb.lock.deadlock.count").publish(label="Number of times the lock acquisitions encountered deadlocks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_health" {
  name = "The health status of the server."

  program_text = <<-EOF
    data("mongodb.health").publish(label="The health status of the server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodb_uptime" {
  name = "The amount of time that the server has been running."

  program_text = <<-EOF
    data("mongodb.uptime").publish(label="The amount of time that the server has been running.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
