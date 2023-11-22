
resource "signalfx_dashboard" "mongodbatlasdashboard" {
  name            = "mongodbatlas"
  dashboard_group = signalfx_dashboard_group.mongodbatlasdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.mongodbatlas_process_asserts.id, signalfx_time_chart.mongodbatlas_process_background_flush.id, signalfx_time_chart.mongodbatlas_process_cache_io.id, signalfx_time_chart.mongodbatlas_process_cache_size.id, signalfx_time_chart.mongodbatlas_process_connections.id, signalfx_time_chart.mongodbatlas_process_cpu_usage_max.id, signalfx_time_chart.mongodbatlas_process_cpu_usage_average.id, signalfx_time_chart.mongodbatlas_process_cpu_children_usage_max.id, signalfx_time_chart.mongodbatlas_process_cpu_children_usage_average.id, signalfx_time_chart.mongodbatlas_process_cpu_children_normalized_usage_max.id, signalfx_time_chart.mongodbatlas_process_cpu_children_normalized_usage_average.id, signalfx_time_chart.mongodbatlas_process_cpu_normalized_usage_max.id, signalfx_time_chart.mongodbatlas_process_cpu_normalized_usage_average.id, signalfx_time_chart.mongodbatlas_process_cursors.id, signalfx_time_chart.mongodbatlas_process_db_storage.id, signalfx_time_chart.mongodbatlas_process_db_document_rate.id, signalfx_time_chart.mongodbatlas_process_global_lock.id, signalfx_time_chart.mongodbatlas_process_index_btree_miss_ratio.id, signalfx_time_chart.mongodbatlas_process_index_counters.id, signalfx_time_chart.mongodbatlas_process_journaling_commits.id, signalfx_time_chart.mongodbatlas_process_journaling_data_files.id, signalfx_time_chart.mongodbatlas_process_journaling_written.id, signalfx_time_chart.mongodbatlas_process_memory_usage.id, signalfx_time_chart.mongodbatlas_process_network_io.id, signalfx_time_chart.mongodbatlas_process_network_requests.id, signalfx_time_chart.mongodbatlas_process_oplog_time.id, signalfx_time_chart.mongodbatlas_process_oplog_rate.id, signalfx_time_chart.mongodbatlas_process_db_operations_rate.id, signalfx_time_chart.mongodbatlas_process_db_operations_time.id, signalfx_time_chart.mongodbatlas_process_page_faults.id, signalfx_time_chart.mongodbatlas_process_db_query_executor_scanned.id, signalfx_time_chart.mongodbatlas_process_db_query_targeting_scanned_per_returned.id, signalfx_time_chart.mongodbatlas_process_restarts.id, signalfx_time_chart.mongodbatlas_system_paging_usage_max.id, signalfx_time_chart.mongodbatlas_system_paging_usage_average.id, signalfx_time_chart.mongodbatlas_system_paging_io_max.id, signalfx_time_chart.mongodbatlas_system_paging_io_average.id, signalfx_time_chart.mongodbatlas_system_cpu_usage_max.id, signalfx_time_chart.mongodbatlas_system_cpu_usage_average.id, signalfx_time_chart.mongodbatlas_system_memory_usage_max.id, signalfx_time_chart.mongodbatlas_system_memory_usage_average.id, signalfx_time_chart.mongodbatlas_system_network_io_max.id, signalfx_time_chart.mongodbatlas_system_network_io_average.id, signalfx_time_chart.mongodbatlas_system_cpu_normalized_usage_max.id, signalfx_time_chart.mongodbatlas_system_cpu_normalized_usage_average.id, signalfx_time_chart.mongodbatlas_process_tickets.id, signalfx_time_chart.mongodbatlas_disk_partition_iops_max.id, signalfx_time_chart.mongodbatlas_disk_partition_iops_average.id, signalfx_time_chart.mongodbatlas_disk_partition_usage_max.id, signalfx_time_chart.mongodbatlas_disk_partition_usage_average.id, signalfx_time_chart.mongodbatlas_disk_partition_utilization_max.id, signalfx_time_chart.mongodbatlas_disk_partition_utilization_average.id, signalfx_time_chart.mongodbatlas_disk_partition_latency_max.id, signalfx_time_chart.mongodbatlas_disk_partition_latency_average.id, signalfx_time_chart.mongodbatlas_disk_partition_space_max.id, signalfx_time_chart.mongodbatlas_disk_partition_space_average.id, signalfx_time_chart.mongodbatlas_db_size.id, signalfx_time_chart.mongodbatlas_db_counts.id, signalfx_time_chart.mongodbatlas_system_fts_memory_usage.id, signalfx_time_chart.mongodbatlas_system_fts_disk_used.id, signalfx_time_chart.mongodbatlas_system_fts_cpu_usage.id, signalfx_time_chart.mongodbatlas_system_fts_cpu_normalized_usage.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "mongodbatlasdashboardgroup0" {
  name        = "mongodbatlas generated OTel dashboard group"
  description = "mongodbatlas generated OTel dashboard group"
}

resource "signalfx_time_chart" "mongodbatlas_process_asserts" {
  name = "Number of assertions per second"

  program_text = <<-EOF
    data("mongodbatlas.process.asserts").publish(label="Number of assertions per second")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_background_flush" {
  name = "Amount of data flushed in the background"

  program_text = <<-EOF
    data("mongodbatlas.process.background_flush").publish(label="Amount of data flushed in the background")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cache_io" {
  name = "Cache throughput (per second)"

  program_text = <<-EOF
    data("mongodbatlas.process.cache.io").publish(label="Cache throughput (per second)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cache_size" {
  name = "Cache sizes"

  program_text = <<-EOF
    data("mongodbatlas.process.cache.size").publish(label="Cache sizes")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_connections" {
  name = "Number of current connections"

  program_text = <<-EOF
    data("mongodbatlas.process.connections").publish(label="Number of current connections")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_usage_max" {
  name = "CPU Usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.usage.max").publish(label="CPU Usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_usage_average" {
  name = "CPU Usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.usage.average").publish(label="CPU Usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_children_usage_max" {
  name = "CPU Usage for child processes (%)"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.children.usage.max").publish(label="CPU Usage for child processes (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_children_usage_average" {
  name = "CPU Usage for child processes (%)"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.children.usage.average").publish(label="CPU Usage for child processes (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_children_normalized_usage_max" {
  name = "CPU Usage for child processes, normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.children.normalized.usage.max").publish(label="CPU Usage for child processes, normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_children_normalized_usage_average" {
  name = "CPU Usage for child processes, normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.children.normalized.usage.average").publish(label="CPU Usage for child processes, normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_normalized_usage_max" {
  name = "CPU Usage, normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.normalized.usage.max").publish(label="CPU Usage, normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cpu_normalized_usage_average" {
  name = "CPU Usage, normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.process.cpu.normalized.usage.average").publish(label="CPU Usage, normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_cursors" {
  name = "Number of cursors"

  program_text = <<-EOF
    data("mongodbatlas.process.cursors").publish(label="Number of cursors")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_storage" {
  name = "Storage used by the database"

  program_text = <<-EOF
    data("mongodbatlas.process.db.storage").publish(label="Storage used by the database")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_document_rate" {
  name = "Document access rates"

  program_text = <<-EOF
    data("mongodbatlas.process.db.document.rate").publish(label="Document access rates")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_global_lock" {
  name = "Number and status of locks"

  program_text = <<-EOF
    data("mongodbatlas.process.global_lock").publish(label="Number and status of locks")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_index_btree_miss_ratio" {
  name = "Index miss ratio (%)"

  program_text = <<-EOF
    data("mongodbatlas.process.index.btree_miss_ratio").publish(label="Index miss ratio (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_index_counters" {
  name = "Indexes"

  program_text = <<-EOF
    data("mongodbatlas.process.index.counters").publish(label="Indexes")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_journaling_commits" {
  name = "Journaling commits"

  program_text = <<-EOF
    data("mongodbatlas.process.journaling.commits").publish(label="Journaling commits")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_journaling_data_files" {
  name = "Data file sizes"

  program_text = <<-EOF
    data("mongodbatlas.process.journaling.data_files").publish(label="Data file sizes")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_journaling_written" {
  name = "Journals written"

  program_text = <<-EOF
    data("mongodbatlas.process.journaling.written").publish(label="Journals written")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_memory_usage" {
  name = "Memory Usage"

  program_text = <<-EOF
    data("mongodbatlas.process.memory.usage").publish(label="Memory Usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_network_io" {
  name = "Network IO"

  program_text = <<-EOF
    data("mongodbatlas.process.network.io").publish(label="Network IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_network_requests" {
  name = "Network requests"

  program_text = <<-EOF
    data("mongodbatlas.process.network.requests").publish(label="Network requests")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_oplog_time" {
  name = "Execution time by operation"

  program_text = <<-EOF
    data("mongodbatlas.process.oplog.time").publish(label="Execution time by operation")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_oplog_rate" {
  name = "Execution rate by operation"

  program_text = <<-EOF
    data("mongodbatlas.process.oplog.rate").publish(label="Execution rate by operation")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_operations_rate" {
  name = "DB Operation Rates"

  program_text = <<-EOF
    data("mongodbatlas.process.db.operations.rate").publish(label="DB Operation Rates")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_operations_time" {
  name = "DB Operation Times"

  program_text = <<-EOF
    data("mongodbatlas.process.db.operations.time").publish(label="DB Operation Times")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_page_faults" {
  name = "Page faults"

  program_text = <<-EOF
    data("mongodbatlas.process.page_faults").publish(label="Page faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_query_executor_scanned" {
  name = "Scanned objects"

  program_text = <<-EOF
    data("mongodbatlas.process.db.query_executor.scanned").publish(label="Scanned objects")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_db_query_targeting_scanned_per_returned" {
  name = "Scanned objects per returned"

  program_text = <<-EOF
    data("mongodbatlas.process.db.query_targeting.scanned_per_returned").publish(label="Scanned objects per returned")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_restarts" {
  name = "Restarts in last hour"

  program_text = <<-EOF
    data("mongodbatlas.process.restarts").publish(label="Restarts in last hour")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_paging_usage_max" {
  name = "Swap usage"

  program_text = <<-EOF
    data("mongodbatlas.system.paging.usage.max").publish(label="Swap usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_paging_usage_average" {
  name = "Swap usage"

  program_text = <<-EOF
    data("mongodbatlas.system.paging.usage.average").publish(label="Swap usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_paging_io_max" {
  name = "Swap IO"

  program_text = <<-EOF
    data("mongodbatlas.system.paging.io.max").publish(label="Swap IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_paging_io_average" {
  name = "Swap IO"

  program_text = <<-EOF
    data("mongodbatlas.system.paging.io.average").publish(label="Swap IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_cpu_usage_max" {
  name = "System CPU Usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.system.cpu.usage.max").publish(label="System CPU Usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_cpu_usage_average" {
  name = "System CPU Usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.system.cpu.usage.average").publish(label="System CPU Usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_memory_usage_max" {
  name = "System Memory Usage"

  program_text = <<-EOF
    data("mongodbatlas.system.memory.usage.max").publish(label="System Memory Usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_memory_usage_average" {
  name = "System Memory Usage"

  program_text = <<-EOF
    data("mongodbatlas.system.memory.usage.average").publish(label="System Memory Usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_network_io_max" {
  name = "System Network IO"

  program_text = <<-EOF
    data("mongodbatlas.system.network.io.max").publish(label="System Network IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_network_io_average" {
  name = "System Network IO"

  program_text = <<-EOF
    data("mongodbatlas.system.network.io.average").publish(label="System Network IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_cpu_normalized_usage_max" {
  name = "System CPU Normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.system.cpu.normalized.usage.max").publish(label="System CPU Normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_cpu_normalized_usage_average" {
  name = "System CPU Normalized to pct"

  program_text = <<-EOF
    data("mongodbatlas.system.cpu.normalized.usage.average").publish(label="System CPU Normalized to pct")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_process_tickets" {
  name = "Tickets"

  program_text = <<-EOF
    data("mongodbatlas.process.tickets").publish(label="Tickets")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_iops_max" {
  name = "Disk partition iops"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.iops.max").publish(label="Disk partition iops")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_iops_average" {
  name = "Disk partition iops"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.iops.average").publish(label="Disk partition iops")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_usage_max" {
  name = "Disk partition usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.usage.max").publish(label="Disk partition usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_usage_average" {
  name = "Disk partition usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.usage.average").publish(label="Disk partition usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_utilization_max" {
  name = "The maximum percentage of time during which requests are being issued to and serviced by the partition."

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.utilization.max").publish(label="The maximum percentage of time during which requests are being issued to and serviced by the partition.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_utilization_average" {
  name = "The percentage of time during which requests are being issued to and serviced by the partition."

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.utilization.average").publish(label="The percentage of time during which requests are being issued to and serviced by the partition.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_latency_max" {
  name = "Disk partition latency"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.latency.max").publish(label="Disk partition latency")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_latency_average" {
  name = "Disk partition latency"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.latency.average").publish(label="Disk partition latency")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_space_max" {
  name = "Disk partition space"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.space.max").publish(label="Disk partition space")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_disk_partition_space_average" {
  name = "Disk partition space"

  program_text = <<-EOF
    data("mongodbatlas.disk.partition.space.average").publish(label="Disk partition space")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_db_size" {
  name = "Database feature size"

  program_text = <<-EOF
    data("mongodbatlas.db.size").publish(label="Database feature size")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_db_counts" {
  name = "Database feature size"

  program_text = <<-EOF
    data("mongodbatlas.db.counts").publish(label="Database feature size")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_fts_memory_usage" {
  name = "Full-text search"

  program_text = <<-EOF
    data("mongodbatlas.system.fts.memory.usage").publish(label="Full-text search")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_fts_disk_used" {
  name = "Full text search disk usage"

  program_text = <<-EOF
    data("mongodbatlas.system.fts.disk.used").publish(label="Full text search disk usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_fts_cpu_usage" {
  name = "Full-text search (%)"

  program_text = <<-EOF
    data("mongodbatlas.system.fts.cpu.usage").publish(label="Full-text search (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mongodbatlas_system_fts_cpu_normalized_usage" {
  name = "Full text search disk usage (%)"

  program_text = <<-EOF
    data("mongodbatlas.system.fts.cpu.normalized.usage").publish(label="Full text search disk usage (%)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
