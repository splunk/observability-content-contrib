
resource "signalfx_dashboard" "sqlserverdashboard" {
  name            = "sqlserver"
  dashboard_group = signalfx_dashboard_group.sqlserverdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.sqlserver_user_connection_count.id, signalfx_time_chart.sqlserver_lock_wait_time_avg.id, signalfx_time_chart.sqlserver_lock_wait_rate.id, signalfx_time_chart.sqlserver_batch_request_rate.id, signalfx_time_chart.sqlserver_batch_sql_compilation_rate.id, signalfx_time_chart.sqlserver_batch_sql_recompilation_rate.id, signalfx_time_chart.sqlserver_page_buffer_cache_hit_ratio.id, signalfx_time_chart.sqlserver_page_life_expectancy.id, signalfx_time_chart.sqlserver_page_split_rate.id, signalfx_time_chart.sqlserver_page_lazy_write_rate.id, signalfx_time_chart.sqlserver_page_checkpoint_flush_rate.id, signalfx_time_chart.sqlserver_page_operation_rate.id, signalfx_time_chart.sqlserver_transaction_log_growth_count.id, signalfx_time_chart.sqlserver_transaction_log_shrink_count.id, signalfx_time_chart.sqlserver_transaction_log_usage.id, signalfx_time_chart.sqlserver_transaction_log_flush_wait_rate.id, signalfx_time_chart.sqlserver_transaction_log_flush_rate.id, signalfx_time_chart.sqlserver_transaction_log_flush_data_rate.id, signalfx_time_chart.sqlserver_transaction_rate.id, signalfx_time_chart.sqlserver_transaction_write_rate.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "sqlserverdashboardgroup0" {
  name        = "sqlserver generated OTel dashboard group"
  description = "sqlserver generated OTel dashboard group"
}

resource "signalfx_time_chart" "sqlserver_user_connection_count" {
  name = "Number of users connected to the SQL Server."

  program_text = <<-EOF
    data("sqlserver.user.connection.count").publish(label="Number of users connected to the SQL Server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_lock_wait_time_avg" {
  name = "Average wait time for all lock requests that had to wait."

  program_text = <<-EOF
    data("sqlserver.lock.wait_time.avg").publish(label="Average wait time for all lock requests that had to wait.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_lock_wait_rate" {
  name = "Number of lock requests resulting in a wait."

  program_text = <<-EOF
    data("sqlserver.lock.wait.rate").publish(label="Number of lock requests resulting in a wait.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_batch_request_rate" {
  name = "Number of batch requests received by SQL Server."

  program_text = <<-EOF
    data("sqlserver.batch.request.rate").publish(label="Number of batch requests received by SQL Server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_batch_sql_compilation_rate" {
  name = "Number of SQL compilations needed."

  program_text = <<-EOF
    data("sqlserver.batch.sql_compilation.rate").publish(label="Number of SQL compilations needed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_batch_sql_recompilation_rate" {
  name = "Number of SQL recompilations needed."

  program_text = <<-EOF
    data("sqlserver.batch.sql_recompilation.rate").publish(label="Number of SQL recompilations needed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_buffer_cache_hit_ratio" {
  name = "Pages found in the buffer pool without having to read from disk."

  program_text = <<-EOF
    data("sqlserver.page.buffer_cache.hit_ratio").publish(label="Pages found in the buffer pool without having to read from disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_life_expectancy" {
  name = "Time a page will stay in the buffer pool."

  program_text = <<-EOF
    data("sqlserver.page.life_expectancy").publish(label="Time a page will stay in the buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_split_rate" {
  name = "Number of pages split as a result of overflowing index pages."

  program_text = <<-EOF
    data("sqlserver.page.split.rate").publish(label="Number of pages split as a result of overflowing index pages.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_lazy_write_rate" {
  name = "Number of lazy writes moving dirty pages to disk."

  program_text = <<-EOF
    data("sqlserver.page.lazy_write.rate").publish(label="Number of lazy writes moving dirty pages to disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_checkpoint_flush_rate" {
  name = "Number of pages flushed by operations requiring dirty pages to be flushed."

  program_text = <<-EOF
    data("sqlserver.page.checkpoint.flush.rate").publish(label="Number of pages flushed by operations requiring dirty pages to be flushed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_page_operation_rate" {
  name = "Number of physical database page operations issued."

  program_text = <<-EOF
    data("sqlserver.page.operation.rate").publish(label="Number of physical database page operations issued.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_growth_count" {
  name = "Total number of transaction log expansions for a database."

  program_text = <<-EOF
    data("sqlserver.transaction_log.growth.count").publish(label="Total number of transaction log expansions for a database.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_shrink_count" {
  name = "Total number of transaction log shrinks for a database."

  program_text = <<-EOF
    data("sqlserver.transaction_log.shrink.count").publish(label="Total number of transaction log shrinks for a database.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_usage" {
  name = "Percent of transaction log space used."

  program_text = <<-EOF
    data("sqlserver.transaction_log.usage").publish(label="Percent of transaction log space used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_flush_wait_rate" {
  name = "Number of commits waiting for a transaction log flush."

  program_text = <<-EOF
    data("sqlserver.transaction_log.flush.wait.rate").publish(label="Number of commits waiting for a transaction log flush.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_flush_rate" {
  name = "Number of log flushes."

  program_text = <<-EOF
    data("sqlserver.transaction_log.flush.rate").publish(label="Number of log flushes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_log_flush_data_rate" {
  name = "Total number of log bytes flushed."

  program_text = <<-EOF
    data("sqlserver.transaction_log.flush.data.rate").publish(label="Total number of log bytes flushed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_rate" {
  name = "Number of transactions started for the database (not including XTP-only transactions)."

  program_text = <<-EOF
    data("sqlserver.transaction.rate").publish(label="Number of transactions started for the database (not including XTP-only transactions).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sqlserver_transaction_write_rate" {
  name = "Number of transactions that wrote to the database and committed."

  program_text = <<-EOF
    data("sqlserver.transaction.write.rate").publish(label="Number of transactions that wrote to the database and committed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
