
resource "signalfx_dashboard" "mysqldashboard" {
  name            = "mysql"
  dashboard_group = signalfx_dashboard_group.mysqldashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.mysql_buffer_pool_pages.id, signalfx_time_chart.mysql_buffer_pool_data_pages.id, signalfx_time_chart.mysql_buffer_pool_page_flushes.id, signalfx_time_chart.mysql_buffer_pool_operations.id, signalfx_time_chart.mysql_buffer_pool_limit.id, signalfx_time_chart.mysql_buffer_pool_usage.id, signalfx_time_chart.mysql_prepared_statements.id, signalfx_time_chart.mysql_commands.id, signalfx_time_chart.mysql_handlers.id, signalfx_time_chart.mysql_double_writes.id, signalfx_time_chart.mysql_log_operations.id, signalfx_time_chart.mysql_operations.id, signalfx_time_chart.mysql_page_operations.id, signalfx_time_chart.mysql_table_io_wait_count.id, signalfx_time_chart.mysql_table_io_wait_time.id, signalfx_time_chart.mysql_index_io_wait_count.id, signalfx_time_chart.mysql_index_io_wait_time.id, signalfx_time_chart.mysql_row_locks.id, signalfx_time_chart.mysql_row_operations.id, signalfx_time_chart.mysql_locks.id, signalfx_time_chart.mysql_sorts.id, signalfx_time_chart.mysql_threads.id, signalfx_time_chart.mysql_client_network_io.id, signalfx_time_chart.mysql_opened_resources.id, signalfx_time_chart.mysql_uptime.id, signalfx_time_chart.mysql_table_lock_wait_read_count.id, signalfx_time_chart.mysql_table_lock_wait_read_time.id, signalfx_time_chart.mysql_table_lock_wait_write_count.id, signalfx_time_chart.mysql_table_lock_wait_write_time.id, signalfx_time_chart.mysql_connection_count.id, signalfx_time_chart.mysql_connection_errors.id, signalfx_time_chart.mysql_mysqlx_connections.id, signalfx_time_chart.mysql_joins.id, signalfx_time_chart.mysql_tmp_resources.id, signalfx_time_chart.mysql_replica_time_behind_source.id, signalfx_time_chart.mysql_replica_sql_delay.id, signalfx_time_chart.mysql_statement_event_count.id, signalfx_time_chart.mysql_statement_event_wait_time.id, signalfx_time_chart.mysql_mysqlx_worker_threads.id, signalfx_time_chart.mysql_table_open_cache.id, signalfx_time_chart.mysql_query_client_count.id, signalfx_time_chart.mysql_query_count.id, signalfx_time_chart.mysql_query_slow_count.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "mysqldashboardgroup0" {
  name        = "mysql generated OTel dashboard group"
  description = "mysql generated OTel dashboard group"
}

resource "signalfx_time_chart" "mysql_buffer_pool_pages" {
  name = "The number of pages in the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.pages").publish(label="The number of pages in the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_buffer_pool_data_pages" {
  name = "The number of data pages in the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.data_pages").publish(label="The number of data pages in the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_buffer_pool_page_flushes" {
  name = "The number of requests to flush pages from the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.page_flushes").publish(label="The number of requests to flush pages from the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_buffer_pool_operations" {
  name = "The number of operations on the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.operations").publish(label="The number of operations on the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_buffer_pool_limit" {
  name = "The configured size of the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.limit").publish(label="The configured size of the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_buffer_pool_usage" {
  name = "The number of bytes in the InnoDB buffer pool."

  program_text = <<-EOF
    data("mysql.buffer_pool.usage").publish(label="The number of bytes in the InnoDB buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_prepared_statements" {
  name = "The number of times each type of prepared statement command has been issued."

  program_text = <<-EOF
    data("mysql.prepared_statements").publish(label="The number of times each type of prepared statement command has been issued.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_commands" {
  name = "The number of times each type of command has been executed."

  program_text = <<-EOF
    data("mysql.commands").publish(label="The number of times each type of command has been executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_handlers" {
  name = "The number of requests to various MySQL handlers."

  program_text = <<-EOF
    data("mysql.handlers").publish(label="The number of requests to various MySQL handlers.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_double_writes" {
  name = "The number of writes to the InnoDB doublewrite buffer."

  program_text = <<-EOF
    data("mysql.double_writes").publish(label="The number of writes to the InnoDB doublewrite buffer.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_log_operations" {
  name = "The number of InnoDB log operations."

  program_text = <<-EOF
    data("mysql.log_operations").publish(label="The number of InnoDB log operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_operations" {
  name = "The number of InnoDB operations."

  program_text = <<-EOF
    data("mysql.operations").publish(label="The number of InnoDB operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_page_operations" {
  name = "The number of InnoDB page operations."

  program_text = <<-EOF
    data("mysql.page_operations").publish(label="The number of InnoDB page operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_io_wait_count" {
  name = "The total count of I/O wait events for a table."

  program_text = <<-EOF
    data("mysql.table.io.wait.count").publish(label="The total count of I/O wait events for a table.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_io_wait_time" {
  name = "The total time of I/O wait events for a table."

  program_text = <<-EOF
    data("mysql.table.io.wait.time").publish(label="The total time of I/O wait events for a table.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_index_io_wait_count" {
  name = "The total count of I/O wait events for an index."

  program_text = <<-EOF
    data("mysql.index.io.wait.count").publish(label="The total count of I/O wait events for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_index_io_wait_time" {
  name = "The total time of I/O wait events for an index."

  program_text = <<-EOF
    data("mysql.index.io.wait.time").publish(label="The total time of I/O wait events for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_row_locks" {
  name = "The number of InnoDB row locks."

  program_text = <<-EOF
    data("mysql.row_locks").publish(label="The number of InnoDB row locks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_row_operations" {
  name = "The number of InnoDB row operations."

  program_text = <<-EOF
    data("mysql.row_operations").publish(label="The number of InnoDB row operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_locks" {
  name = "The number of MySQL locks."

  program_text = <<-EOF
    data("mysql.locks").publish(label="The number of MySQL locks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_sorts" {
  name = "The number of MySQL sorts."

  program_text = <<-EOF
    data("mysql.sorts").publish(label="The number of MySQL sorts.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_threads" {
  name = "The state of MySQL threads."

  program_text = <<-EOF
    data("mysql.threads").publish(label="The state of MySQL threads.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_client_network_io" {
  name = "The number of transmitted bytes between server and clients."

  program_text = <<-EOF
    data("mysql.client.network.io").publish(label="The number of transmitted bytes between server and clients.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_opened_resources" {
  name = "The number of opened resources."

  program_text = <<-EOF
    data("mysql.opened_resources").publish(label="The number of opened resources.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_uptime" {
  name = "The number of seconds that the server has been up."

  program_text = <<-EOF
    data("mysql.uptime").publish(label="The number of seconds that the server has been up.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_lock_wait_read_count" {
  name = "The total table lock wait read events."

  program_text = <<-EOF
    data("mysql.table.lock_wait.read.count").publish(label="The total table lock wait read events.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_lock_wait_read_time" {
  name = "The total table lock wait read events times."

  program_text = <<-EOF
    data("mysql.table.lock_wait.read.time").publish(label="The total table lock wait read events times.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_lock_wait_write_count" {
  name = "The total table lock wait write events."

  program_text = <<-EOF
    data("mysql.table.lock_wait.write.count").publish(label="The total table lock wait write events.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_lock_wait_write_time" {
  name = "The total table lock wait write events times."

  program_text = <<-EOF
    data("mysql.table.lock_wait.write.time").publish(label="The total table lock wait write events times.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_connection_count" {
  name = "The number of connection attempts (successful or not) to the MySQL server."

  program_text = <<-EOF
    data("mysql.connection.count").publish(label="The number of connection attempts (successful or not) to the MySQL server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_connection_errors" {
  name = "Errors that occur during the client connection process."

  program_text = <<-EOF
    data("mysql.connection.errors").publish(label="Errors that occur during the client connection process.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_mysqlx_connections" {
  name = "The number of mysqlx connections."

  program_text = <<-EOF
    data("mysql.mysqlx_connections").publish(label="The number of mysqlx connections.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_joins" {
  name = "The number of joins that perform table scans."

  program_text = <<-EOF
    data("mysql.joins").publish(label="The number of joins that perform table scans.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_tmp_resources" {
  name = "The number of created temporary resources."

  program_text = <<-EOF
    data("mysql.tmp_resources").publish(label="The number of created temporary resources.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_replica_time_behind_source" {
  name = "This field is an indication of how “late” the replica is."

  program_text = <<-EOF
    data("mysql.replica.time_behind_source").publish(label="This field is an indication of how “late” the replica is.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_replica_sql_delay" {
  name = "The number of seconds that the replica must lag the source."

  program_text = <<-EOF
    data("mysql.replica.sql_delay").publish(label="The number of seconds that the replica must lag the source.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_statement_event_count" {
  name = "Summary of current and recent statement events."

  program_text = <<-EOF
    data("mysql.statement_event.count").publish(label="Summary of current and recent statement events.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_statement_event_wait_time" {
  name = "The total wait time of the summarized timed events."

  program_text = <<-EOF
    data("mysql.statement_event.wait.time").publish(label="The total wait time of the summarized timed events.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_mysqlx_worker_threads" {
  name = "The number of worker threads available."

  program_text = <<-EOF
    data("mysql.mysqlx_worker_threads").publish(label="The number of worker threads available.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_table_open_cache" {
  name = "The number of hits, misses or overflows for open tables cache lookups."

  program_text = <<-EOF
    data("mysql.table_open_cache").publish(label="The number of hits, misses or overflows for open tables cache lookups.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_query_client_count" {
  name = "The number of statements executed by the server. This includes only statements sent to the server by clients."

  program_text = <<-EOF
    data("mysql.query.client.count").publish(label="The number of statements executed by the server. This includes only statements sent to the server by clients.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_query_count" {
  name = "The number of statements executed by the server."

  program_text = <<-EOF
    data("mysql.query.count").publish(label="The number of statements executed by the server.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "mysql_query_slow_count" {
  name = "The number of slow queries."

  program_text = <<-EOF
    data("mysql.query.slow.count").publish(label="The number of slow queries.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
