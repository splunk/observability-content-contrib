
resource "signalfx_dashboard" "snowflakedashboard" {
  name            = "snowflake"
  dashboard_group = signalfx_dashboard_group.snowflakedashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.snowflake_billing_cloud_service_total.id, signalfx_time_chart.snowflake_billing_total_credit_total.id, signalfx_time_chart.snowflake_billing_virtual_warehouse_total.id, signalfx_time_chart.snowflake_billing_warehouse_cloud_service_total.id, signalfx_time_chart.snowflake_billing_warehouse_total_credit_total.id, signalfx_time_chart.snowflake_billing_warehouse_virtual_warehouse_total.id, signalfx_time_chart.snowflake_logins_total.id, signalfx_time_chart.snowflake_query_blocked.id, signalfx_time_chart.snowflake_query_executed.id, signalfx_time_chart.snowflake_query_queued_overload.id, signalfx_time_chart.snowflake_query_queued_provision.id, signalfx_time_chart.snowflake_database_query_count.id, signalfx_time_chart.snowflake_database_bytes_scanned_avg.id, signalfx_time_chart.snowflake_query_bytes_deleted_avg.id, signalfx_time_chart.snowflake_query_bytes_spilled_local_avg.id, signalfx_time_chart.snowflake_query_bytes_spilled_remote_avg.id, signalfx_time_chart.snowflake_query_bytes_written_avg.id, signalfx_time_chart.snowflake_query_compilation_time_avg.id, signalfx_time_chart.snowflake_query_data_scanned_cache_avg.id, signalfx_time_chart.snowflake_query_execution_time_avg.id, signalfx_time_chart.snowflake_query_partitions_scanned_avg.id, signalfx_time_chart.snowflake_queued_overload_time_avg.id, signalfx_time_chart.snowflake_queued_provisioning_time_avg.id, signalfx_time_chart.snowflake_queued_repair_time_avg.id, signalfx_time_chart.snowflake_rows_inserted_avg.id, signalfx_time_chart.snowflake_rows_deleted_avg.id, signalfx_time_chart.snowflake_rows_produced_avg.id, signalfx_time_chart.snowflake_rows_unloaded_avg.id, signalfx_time_chart.snowflake_rows_updated_avg.id, signalfx_time_chart.snowflake_total_elapsed_time_avg.id, signalfx_time_chart.snowflake_session_id_count.id, signalfx_time_chart.snowflake_pipe_credits_used_total.id, signalfx_time_chart.snowflake_storage_storage_bytes_total.id, signalfx_time_chart.snowflake_storage_stage_bytes_total.id, signalfx_time_chart.snowflake_storage_failsafe_bytes_total.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "snowflakedashboardgroup0" {
  name        = "snowflake generated OTel dashboard group"
  description = "snowflake generated OTel dashboard group"
}

resource "signalfx_time_chart" "snowflake_billing_cloud_service_total" {
  name = "Reported total credits used in the cloud service over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.cloud_service.total").publish(label="Reported total credits used in the cloud service over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_billing_total_credit_total" {
  name = "Reported total credits used across account over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.total_credit.total").publish(label="Reported total credits used across account over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_billing_virtual_warehouse_total" {
  name = "Reported total credits used by virtual warehouse service over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.virtual_warehouse.total").publish(label="Reported total credits used by virtual warehouse service over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_billing_warehouse_cloud_service_total" {
  name = "Credits used across cloud service for given warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.warehouse.cloud_service.total").publish(label="Credits used across cloud service for given warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_billing_warehouse_total_credit_total" {
  name = "Total credits used associated with given warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.warehouse.total_credit.total").publish(label="Total credits used associated with given warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_billing_warehouse_virtual_warehouse_total" {
  name = "Total credits used by virtual warehouse service for given warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.billing.warehouse.virtual_warehouse.total").publish(label="Total credits used by virtual warehouse service for given warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_logins_total" {
  name = "Total login attempts for account over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.logins.total").publish(label="Total login attempts for account over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_blocked" {
  name = "Blocked query count for warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.blocked").publish(label="Blocked query count for warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_executed" {
  name = "Executed query count for warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.executed").publish(label="Executed query count for warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_queued_overload" {
  name = "Overloaded query count for warehouse over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.queued_overload").publish(label="Overloaded query count for warehouse over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_queued_provision" {
  name = "Number of compute resources queued for provisioning over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.queued_provision").publish(label="Number of compute resources queued for provisioning over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_database_query_count" {
  name = "Total query count for database over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.database.query.count").publish(label="Total query count for database over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_database_bytes_scanned_avg" {
  name = "Average bytes scanned in a database over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.database.bytes_scanned.avg").publish(label="Average bytes scanned in a database over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_bytes_deleted_avg" {
  name = "Average bytes deleted in database over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.bytes_deleted.avg").publish(label="Average bytes deleted in database over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_bytes_spilled_local_avg" {
  name = "Avergae bytes spilled (intermediate results do not fit in memory) by local storage over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.bytes_spilled.local.avg").publish(label="Avergae bytes spilled (intermediate results do not fit in memory) by local storage over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_bytes_spilled_remote_avg" {
  name = "Avergae bytes spilled (intermediate results do not fit in memory) by remote storage over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.bytes_spilled.remote.avg").publish(label="Avergae bytes spilled (intermediate results do not fit in memory) by remote storage over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_bytes_written_avg" {
  name = "Average bytes written by database over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.bytes_written.avg").publish(label="Average bytes written by database over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_compilation_time_avg" {
  name = "Average time taken to compile query over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.compilation_time.avg").publish(label="Average time taken to compile query over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_data_scanned_cache_avg" {
  name = "Average percentage of data scanned from cache over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.data_scanned_cache.avg").publish(label="Average percentage of data scanned from cache over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_execution_time_avg" {
  name = "Average time spent executing queries in database over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.execution_time.avg").publish(label="Average time spent executing queries in database over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_query_partitions_scanned_avg" {
  name = "Number of partitions scanned during query so far over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.query.partitions_scanned.avg").publish(label="Number of partitions scanned during query so far over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_queued_overload_time_avg" {
  name = "Average time spent in warehouse queue due to warehouse being overloaded over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.queued_overload_time.avg").publish(label="Average time spent in warehouse queue due to warehouse being overloaded over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_queued_provisioning_time_avg" {
  name = "Average time spent in warehouse queue waiting for resources to provision over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.queued_provisioning_time.avg").publish(label="Average time spent in warehouse queue waiting for resources to provision over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_queued_repair_time_avg" {
  name = "Average time spent in warehouse queue waiting for compute resources to be repaired over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.queued_repair_time.avg").publish(label="Average time spent in warehouse queue waiting for compute resources to be repaired over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_rows_inserted_avg" {
  name = "Number of rows inserted into a table (or tables) over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.rows_inserted.avg").publish(label="Number of rows inserted into a table (or tables) over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_rows_deleted_avg" {
  name = "Number of rows deleted from a table (or tables) over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.rows_deleted.avg").publish(label="Number of rows deleted from a table (or tables) over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_rows_produced_avg" {
  name = "Average number of rows produced by statement over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.rows_produced.avg").publish(label="Average number of rows produced by statement over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_rows_unloaded_avg" {
  name = "Average number of rows unloaded during data export over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.rows_unloaded.avg").publish(label="Average number of rows unloaded during data export over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_rows_updated_avg" {
  name = "Average number of rows updated in a table over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.rows_updated.avg").publish(label="Average number of rows updated in a table over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_total_elapsed_time_avg" {
  name = "Average elapsed time over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.total_elapsed_time.avg").publish(label="Average elapsed time over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_session_id_count" {
  name = "Distinct session id's associated with snowflake username over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.session_id.count").publish(label="Distinct session id's associated with snowflake username over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_pipe_credits_used_total" {
  name = "Snow pipe credits contotaled over the last 24 hour window."

  program_text = <<-EOF
    data("snowflake.pipe.credits_used.total").publish(label="Snow pipe credits contotaled over the last 24 hour window.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_storage_storage_bytes_total" {
  name = "Number of bytes of table storage used, including bytes for data currently in Time Travel."

  program_text = <<-EOF
    data("snowflake.storage.storage_bytes.total").publish(label="Number of bytes of table storage used, including bytes for data currently in Time Travel.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_storage_stage_bytes_total" {
  name = "Number of bytes of stage storage used by files in all internal stages (named, table, user)."

  program_text = <<-EOF
    data("snowflake.storage.stage_bytes.total").publish(label="Number of bytes of stage storage used by files in all internal stages (named, table, user).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "snowflake_storage_failsafe_bytes_total" {
  name = "Number of bytes of data in Fail-safe."

  program_text = <<-EOF
    data("snowflake.storage.failsafe_bytes.total").publish(label="Number of bytes of data in Fail-safe.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
