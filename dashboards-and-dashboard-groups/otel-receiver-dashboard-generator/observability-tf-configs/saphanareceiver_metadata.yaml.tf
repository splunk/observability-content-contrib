
resource "signalfx_dashboard" "saphanadashboard" {
  name            = "saphana"
  dashboard_group = signalfx_dashboard_group.saphanadashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.saphana_connection_count.id, signalfx_time_chart.saphana_cpu_used.id, signalfx_time_chart.saphana_alert_count.id, signalfx_time_chart.saphana_uptime.id, signalfx_time_chart.saphana_replication_backlog_time.id, signalfx_time_chart.saphana_replication_backlog_size.id, signalfx_time_chart.saphana_replication_average_time.id, signalfx_time_chart.saphana_backup_latest.id, signalfx_time_chart.saphana_transaction_count.id, signalfx_time_chart.saphana_transaction_blocked.id, signalfx_time_chart.saphana_license_expiration_time.id, signalfx_time_chart.saphana_license_limit.id, signalfx_time_chart.saphana_license_peak.id, signalfx_time_chart.saphana_instance_memory_current.id, signalfx_time_chart.saphana_instance_memory_used_peak.id, signalfx_time_chart.saphana_instance_code_size.id, signalfx_time_chart.saphana_instance_memory_shared_allocated.id, signalfx_time_chart.saphana_host_memory_current.id, signalfx_time_chart.saphana_host_swap_current.id, signalfx_time_chart.saphana_column_memory_used.id, signalfx_time_chart.saphana_row_store_memory_used.id, signalfx_time_chart.saphana_component_memory_used.id, signalfx_time_chart.saphana_schema_memory_used_current.id, signalfx_time_chart.saphana_schema_memory_used_max.id, signalfx_time_chart.saphana_schema_record_count.id, signalfx_time_chart.saphana_schema_record_compressed_count.id, signalfx_time_chart.saphana_schema_operation_count.id, signalfx_time_chart.saphana_service_count.id, signalfx_time_chart.saphana_service_thread_count.id, signalfx_time_chart.saphana_service_memory_used.id, signalfx_time_chart.saphana_service_code_size.id, signalfx_time_chart.saphana_service_stack_size.id, signalfx_time_chart.saphana_service_memory_heap_current.id, signalfx_time_chart.saphana_service_memory_shared_current.id, signalfx_time_chart.saphana_service_memory_compactors_allocated.id, signalfx_time_chart.saphana_service_memory_compactors_freeable.id, signalfx_time_chart.saphana_service_memory_limit.id, signalfx_time_chart.saphana_service_memory_effective_limit.id, signalfx_time_chart.saphana_disk_size_current.id, signalfx_time_chart.saphana_volume_operation_count.id, signalfx_time_chart.saphana_volume_operation_size.id, signalfx_time_chart.saphana_volume_operation_time.id, signalfx_time_chart.saphana_network_request_count.id, signalfx_time_chart.saphana_network_request_finished_count.id, signalfx_time_chart.saphana_network_request_average_time.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "saphanadashboardgroup0" {
  name        = "saphana generated OTel dashboard group"
  description = "saphana generated OTel dashboard group"
}

resource "signalfx_time_chart" "saphana_connection_count" {
  name = "The number of current connections."

  program_text = <<-EOF
    data("saphana.connection.count").publish(label="The number of current connections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_cpu_used" {
  name = "Total CPU time spent."

  program_text = <<-EOF
    data("saphana.cpu.used").publish(label="Total CPU time spent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_alert_count" {
  name = "Number of current alerts."

  program_text = <<-EOF
    data("saphana.alert.count").publish(label="Number of current alerts.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_uptime" {
  name = "The uptime of the database."

  program_text = <<-EOF
    data("saphana.uptime").publish(label="The uptime of the database.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_replication_backlog_time" {
  name = "The current replication backlog."

  program_text = <<-EOF
    data("saphana.replication.backlog.time").publish(label="The current replication backlog.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_replication_backlog_size" {
  name = "The current replication backlog size."

  program_text = <<-EOF
    data("saphana.replication.backlog.size").publish(label="The current replication backlog size.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_replication_average_time" {
  name = "The average amount of time consumed replicating a log."

  program_text = <<-EOF
    data("saphana.replication.average_time").publish(label="The average amount of time consumed replicating a log.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_backup_latest" {
  name = "The age of the latest backup by start time."

  program_text = <<-EOF
    data("saphana.backup.latest").publish(label="The age of the latest backup by start time.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_transaction_count" {
  name = "The number of transactions."

  program_text = <<-EOF
    data("saphana.transaction.count").publish(label="The number of transactions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_transaction_blocked" {
  name = "The number of transactions waiting for a lock."

  program_text = <<-EOF
    data("saphana.transaction.blocked").publish(label="The number of transactions waiting for a lock.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_license_expiration_time" {
  name = "The amount of time remaining before license expiration."

  program_text = <<-EOF
    data("saphana.license.expiration.time").publish(label="The amount of time remaining before license expiration.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_license_limit" {
  name = "The allowed product usage as specified by the license (for example, main memory)."

  program_text = <<-EOF
    data("saphana.license.limit").publish(label="The allowed product usage as specified by the license (for example, main memory).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_license_peak" {
  name = "The peak product usage value during last 13 months, measured periodically."

  program_text = <<-EOF
    data("saphana.license.peak").publish(label="The peak product usage value during last 13 months, measured periodically.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_instance_memory_current" {
  name = "The size of the memory pool for all SAP HANA processes."

  program_text = <<-EOF
    data("saphana.instance.memory.current").publish(label="The size of the memory pool for all SAP HANA processes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_instance_memory_used_peak" {
  name = "The peak memory from the memory pool used by SAP HANA processes since the instance started (this is a sample-based value)."

  program_text = <<-EOF
    data("saphana.instance.memory.used.peak").publish(label="The peak memory from the memory pool used by SAP HANA processes since the instance started (this is a sample-based value).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_instance_code_size" {
  name = "The instance code size, including shared libraries of SAP HANA processes."

  program_text = <<-EOF
    data("saphana.instance.code_size").publish(label="The instance code size, including shared libraries of SAP HANA processes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_instance_memory_shared_allocated" {
  name = "The shared memory size of SAP HANA processes."

  program_text = <<-EOF
    data("saphana.instance.memory.shared.allocated").publish(label="The shared memory size of SAP HANA processes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_host_memory_current" {
  name = "The amount of physical memory on the host."

  program_text = <<-EOF
    data("saphana.host.memory.current").publish(label="The amount of physical memory on the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_host_swap_current" {
  name = "The amount of swap space on the host."

  program_text = <<-EOF
    data("saphana.host.swap.current").publish(label="The amount of swap space on the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_column_memory_used" {
  name = "The memory used in all columns."

  program_text = <<-EOF
    data("saphana.column.memory.used").publish(label="The memory used in all columns.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_row_store_memory_used" {
  name = "The used memory for all row tables."

  program_text = <<-EOF
    data("saphana.row_store.memory.used").publish(label="The used memory for all row tables.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_component_memory_used" {
  name = "The memory used in components."

  program_text = <<-EOF
    data("saphana.component.memory.used").publish(label="The memory used in components.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_schema_memory_used_current" {
  name = "The memory size for all tables in schema."

  program_text = <<-EOF
    data("saphana.schema.memory.used.current").publish(label="The memory size for all tables in schema.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_schema_memory_used_max" {
  name = "The estimated maximum memory consumption for all fully loaded tables in schema (data for open transactions is not included)."

  program_text = <<-EOF
    data("saphana.schema.memory.used.max").publish(label="The estimated maximum memory consumption for all fully loaded tables in schema (data for open transactions is not included).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_schema_record_count" {
  name = "The number of records for all tables in schema."

  program_text = <<-EOF
    data("saphana.schema.record.count").publish(label="The number of records for all tables in schema.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_schema_record_compressed_count" {
  name = "The number of entries in main during the last optimize compression run for all tables in schema."

  program_text = <<-EOF
    data("saphana.schema.record.compressed.count").publish(label="The number of entries in main during the last optimize compression run for all tables in schema.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_schema_operation_count" {
  name = "The number of operations done on all tables in schema."

  program_text = <<-EOF
    data("saphana.schema.operation.count").publish(label="The number of operations done on all tables in schema.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_count" {
  name = "The number of services in a given status."

  program_text = <<-EOF
    data("saphana.service.count").publish(label="The number of services in a given status.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_thread_count" {
  name = "The number of service threads in a given status."

  program_text = <<-EOF
    data("saphana.service.thread.count").publish(label="The number of service threads in a given status.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_used" {
  name = "The used memory from the operating system perspective."

  program_text = <<-EOF
    data("saphana.service.memory.used").publish(label="The used memory from the operating system perspective.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_code_size" {
  name = "The service code size, including shared libraries."

  program_text = <<-EOF
    data("saphana.service.code_size").publish(label="The service code size, including shared libraries.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_stack_size" {
  name = "The service stack size."

  program_text = <<-EOF
    data("saphana.service.stack_size").publish(label="The service stack size.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_heap_current" {
  name = "The size of the heap portion of the memory pool."

  program_text = <<-EOF
    data("saphana.service.memory.heap.current").publish(label="The size of the heap portion of the memory pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_shared_current" {
  name = "The size of the shared portion of the memory pool."

  program_text = <<-EOF
    data("saphana.service.memory.shared.current").publish(label="The size of the shared portion of the memory pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_compactors_allocated" {
  name = "The part of the memory pool that can potentially (if unpinned) be freed during a memory shortage."

  program_text = <<-EOF
    data("saphana.service.memory.compactors.allocated").publish(label="The part of the memory pool that can potentially (if unpinned) be freed during a memory shortage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_compactors_freeable" {
  name = "The memory that can be freed during a memory shortage."

  program_text = <<-EOF
    data("saphana.service.memory.compactors.freeable").publish(label="The memory that can be freed during a memory shortage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_limit" {
  name = "The configured maximum memory pool size."

  program_text = <<-EOF
    data("saphana.service.memory.limit").publish(label="The configured maximum memory pool size.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_service_memory_effective_limit" {
  name = "The effective maximum memory pool size, calculated considering the pool sizes of other processes."

  program_text = <<-EOF
    data("saphana.service.memory.effective_limit").publish(label="The effective maximum memory pool size, calculated considering the pool sizes of other processes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_disk_size_current" {
  name = "The disk size."

  program_text = <<-EOF
    data("saphana.disk.size.current").publish(label="The disk size.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_volume_operation_count" {
  name = "The number of operations executed."

  program_text = <<-EOF
    data("saphana.volume.operation.count").publish(label="The number of operations executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_volume_operation_size" {
  name = "The size of operations executed."

  program_text = <<-EOF
    data("saphana.volume.operation.size").publish(label="The size of operations executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_volume_operation_time" {
  name = "The time spent executing operations."

  program_text = <<-EOF
    data("saphana.volume.operation.time").publish(label="The time spent executing operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_network_request_count" {
  name = "The number of active and pending service requests."

  program_text = <<-EOF
    data("saphana.network.request.count").publish(label="The number of active and pending service requests.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_network_request_finished_count" {
  name = "The number of service requests that have completed."

  program_text = <<-EOF
    data("saphana.network.request.finished.count").publish(label="The number of service requests that have completed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "saphana_network_request_average_time" {
  name = "The average response time calculated over recent requests"

  program_text = <<-EOF
    data("saphana.network.request.average_time").publish(label="The average response time calculated over recent requests")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
