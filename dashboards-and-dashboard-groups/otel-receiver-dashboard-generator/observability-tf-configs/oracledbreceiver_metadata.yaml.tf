
resource "signalfx_dashboard" "oracledbdashboard" {
  name            = "oracledb"
  dashboard_group = signalfx_dashboard_group.oracledbdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.oracledb_cpu_time.id, signalfx_time_chart.oracledb_enqueue_deadlocks.id, signalfx_time_chart.oracledb_exchange_deadlocks.id, signalfx_time_chart.oracledb_executions.id, signalfx_time_chart.oracledb_logical_reads.id, signalfx_time_chart.oracledb_hard_parses.id, signalfx_time_chart.oracledb_parse_calls.id, signalfx_time_chart.oracledb_pga_memory.id, signalfx_time_chart.oracledb_physical_reads.id, signalfx_time_chart.oracledb_user_commits.id, signalfx_time_chart.oracledb_user_rollbacks.id, signalfx_time_chart.oracledb_sessions_usage.id, signalfx_time_chart.oracledb_processes_usage.id, signalfx_time_chart.oracledb_processes_limit.id, signalfx_time_chart.oracledb_sessions_limit.id, signalfx_time_chart.oracledb_enqueue_locks_usage.id, signalfx_time_chart.oracledb_enqueue_locks_limit.id, signalfx_time_chart.oracledb_dml_locks_usage.id, signalfx_time_chart.oracledb_dml_locks_limit.id, signalfx_time_chart.oracledb_enqueue_resources_usage.id, signalfx_time_chart.oracledb_enqueue_resources_limit.id, signalfx_time_chart.oracledb_transactions_usage.id, signalfx_time_chart.oracledb_transactions_limit.id, signalfx_time_chart.oracledb_tablespace_size_limit.id, signalfx_time_chart.oracledb_tablespace_size_usage.id, signalfx_time_chart.oracledb_db_block_gets.id, signalfx_time_chart.oracledb_consistent_gets.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "oracledbdashboardgroup0" {
  name        = "oracledb generated OTel dashboard group"
  description = "oracledb generated OTel dashboard group"
}

resource "signalfx_time_chart" "oracledb_cpu_time" {
  name = "Cumulative CPU time, in seconds"

  program_text = <<-EOF
    data("oracledb.cpu_time").publish(label="Cumulative CPU time, in seconds")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_enqueue_deadlocks" {
  name = "Total number of deadlocks between table or row locks in different sessions."

  program_text = <<-EOF
    data("oracledb.enqueue_deadlocks").publish(label="Total number of deadlocks between table or row locks in different sessions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_exchange_deadlocks" {
  name = "Number of times that a process detected a potential deadlock when exchanging two buffers and raised an internal, restartable error. Index scans are the only operations that perform exchanges."

  program_text = <<-EOF
    data("oracledb.exchange_deadlocks").publish(label="Number of times that a process detected a potential deadlock when exchanging two buffers and raised an internal, restartable error. Index scans are the only operations that perform exchanges.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_executions" {
  name = "Total number of calls (user and recursive) that executed SQL statements"

  program_text = <<-EOF
    data("oracledb.executions").publish(label="Total number of calls (user and recursive) that executed SQL statements")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_logical_reads" {
  name = "Number of logical reads"

  program_text = <<-EOF
    data("oracledb.logical_reads").publish(label="Number of logical reads")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_hard_parses" {
  name = "Number of hard parses"

  program_text = <<-EOF
    data("oracledb.hard_parses").publish(label="Number of hard parses")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_parse_calls" {
  name = "Total number of parse calls."

  program_text = <<-EOF
    data("oracledb.parse_calls").publish(label="Total number of parse calls.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_pga_memory" {
  name = "Session PGA (Program Global Area) memory"

  program_text = <<-EOF
    data("oracledb.pga_memory").publish(label="Session PGA (Program Global Area) memory")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_physical_reads" {
  name = "Number of physical reads"

  program_text = <<-EOF
    data("oracledb.physical_reads").publish(label="Number of physical reads")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_user_commits" {
  name = "Number of user commits. When a user commits a transaction, the redo generated that reflects the changes made to database blocks must be written to disk. Commits often represent the closest thing to a user transaction rate."

  program_text = <<-EOF
    data("oracledb.user_commits").publish(label="Number of user commits. When a user commits a transaction, the redo generated that reflects the changes made to database blocks must be written to disk. Commits often represent the closest thing to a user transaction rate.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_user_rollbacks" {
  name = "Number of times users manually issue the ROLLBACK statement or an error occurs during a user's transactions"

  program_text = <<-EOF
    data("oracledb.user_rollbacks").publish(label="Number of times users manually issue the ROLLBACK statement or an error occurs during a user's transactions")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_sessions_usage" {
  name = "Count of active sessions."

  program_text = <<-EOF
    data("oracledb.sessions.usage").publish(label="Count of active sessions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_processes_usage" {
  name = "Current count of active processes."

  program_text = <<-EOF
    data("oracledb.processes.usage").publish(label="Current count of active processes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_processes_limit" {
  name = "Maximum limit of active processes, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.processes.limit").publish(label="Maximum limit of active processes, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_sessions_limit" {
  name = "Maximum limit of active sessions, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.sessions.limit").publish(label="Maximum limit of active sessions, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_enqueue_locks_usage" {
  name = "Current count of active enqueue locks."

  program_text = <<-EOF
    data("oracledb.enqueue_locks.usage").publish(label="Current count of active enqueue locks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_enqueue_locks_limit" {
  name = "Maximum limit of active enqueue locks, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.enqueue_locks.limit").publish(label="Maximum limit of active enqueue locks, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_dml_locks_usage" {
  name = "Current count of active DML (Data Manipulation Language) locks."

  program_text = <<-EOF
    data("oracledb.dml_locks.usage").publish(label="Current count of active DML (Data Manipulation Language) locks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_dml_locks_limit" {
  name = "Maximum limit of active DML (Data Manipulation Language) locks, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.dml_locks.limit").publish(label="Maximum limit of active DML (Data Manipulation Language) locks, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_enqueue_resources_usage" {
  name = "Current count of active enqueue resources."

  program_text = <<-EOF
    data("oracledb.enqueue_resources.usage").publish(label="Current count of active enqueue resources.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_enqueue_resources_limit" {
  name = "Maximum limit of active enqueue resources, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.enqueue_resources.limit").publish(label="Maximum limit of active enqueue resources, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_transactions_usage" {
  name = "Current count of active transactions."

  program_text = <<-EOF
    data("oracledb.transactions.usage").publish(label="Current count of active transactions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_transactions_limit" {
  name = "Maximum limit of active transactions, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.transactions.limit").publish(label="Maximum limit of active transactions, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_tablespace_size_limit" {
  name = "Maximum size of tablespace in bytes, -1 if unlimited."

  program_text = <<-EOF
    data("oracledb.tablespace_size.limit").publish(label="Maximum size of tablespace in bytes, -1 if unlimited.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_tablespace_size_usage" {
  name = "Used tablespace in bytes."

  program_text = <<-EOF
    data("oracledb.tablespace_size.usage").publish(label="Used tablespace in bytes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_db_block_gets" {
  name = "Number of times a current block was requested from the buffer cache."

  program_text = <<-EOF
    data("oracledb.db_block_gets").publish(label="Number of times a current block was requested from the buffer cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "oracledb_consistent_gets" {
  name = "Number of times a consistent read was requested for a block from the buffer cache."

  program_text = <<-EOF
    data("oracledb.consistent_gets").publish(label="Number of times a consistent read was requested for a block from the buffer cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
