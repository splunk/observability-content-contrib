
resource "signalfx_dashboard" "postgresqldashboard" {
  name            = "postgresql"
  dashboard_group = signalfx_dashboard_group.postgresqldashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.postgresql_bgwriter_buffers_allocated.id, signalfx_time_chart.postgresql_bgwriter_buffers_writes.id, signalfx_time_chart.postgresql_bgwriter_checkpoint_count.id, signalfx_time_chart.postgresql_bgwriter_duration.id, signalfx_time_chart.postgresql_bgwriter_maxwritten.id, signalfx_time_chart.postgresql_blocks_read.id, signalfx_time_chart.postgresql_commits.id, signalfx_time_chart.postgresql_database_count.id, signalfx_time_chart.postgresql_database_locks.id, signalfx_time_chart.postgresql_db_size.id, signalfx_time_chart.postgresql_backends.id, signalfx_time_chart.postgresql_connection_max.id, signalfx_time_chart.postgresql_rows.id, signalfx_time_chart.postgresql_index_scans.id, signalfx_time_chart.postgresql_index_size.id, signalfx_time_chart.postgresql_operations.id, signalfx_time_chart.postgresql_replication_data_delay.id, signalfx_time_chart.postgresql_rollbacks.id, signalfx_time_chart.postgresql_deadlocks.id, signalfx_time_chart.postgresql_sequential_scans.id, signalfx_time_chart.postgresql_table_count.id, signalfx_time_chart.postgresql_table_size.id, signalfx_time_chart.postgresql_table_vacuum_count.id, signalfx_time_chart.postgresql_temp_files.id, signalfx_time_chart.postgresql_wal_age.id, signalfx_time_chart.postgresql_wal_lag.id, signalfx_time_chart.postgresql_wal_delay.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "postgresqldashboardgroup0" {
  name        = "postgresql generated OTel dashboard group"
  description = "postgresql generated OTel dashboard group"
}

resource "signalfx_time_chart" "postgresql_bgwriter_buffers_allocated" {
  name = "Number of buffers allocated."

  program_text = <<-EOF
    data("postgresql.bgwriter.buffers.allocated").publish(label="Number of buffers allocated.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_bgwriter_buffers_writes" {
  name = "Number of buffers written."

  program_text = <<-EOF
    data("postgresql.bgwriter.buffers.writes").publish(label="Number of buffers written.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_bgwriter_checkpoint_count" {
  name = "The number of checkpoints performed."

  program_text = <<-EOF
    data("postgresql.bgwriter.checkpoint.count").publish(label="The number of checkpoints performed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_bgwriter_duration" {
  name = "Total time spent writing and syncing files to disk by checkpoints."

  program_text = <<-EOF
    data("postgresql.bgwriter.duration").publish(label="Total time spent writing and syncing files to disk by checkpoints.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_bgwriter_maxwritten" {
  name = "Number of times the background writer stopped a cleaning scan because it had written too many buffers."

  program_text = <<-EOF
    data("postgresql.bgwriter.maxwritten").publish(label="Number of times the background writer stopped a cleaning scan because it had written too many buffers.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_blocks_read" {
  name = "The number of blocks read."

  program_text = <<-EOF
    data("postgresql.blocks_read").publish(label="The number of blocks read.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_commits" {
  name = "The number of commits."

  program_text = <<-EOF
    data("postgresql.commits").publish(label="The number of commits.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_database_count" {
  name = "Number of user databases."

  program_text = <<-EOF
    data("postgresql.database.count").publish(label="Number of user databases.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_database_locks" {
  name = "The number of database locks."

  program_text = <<-EOF
    data("postgresql.database.locks").publish(label="The number of database locks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_db_size" {
  name = "The database disk usage."

  program_text = <<-EOF
    data("postgresql.db_size").publish(label="The database disk usage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_backends" {
  name = "The number of backends."

  program_text = <<-EOF
    data("postgresql.backends").publish(label="The number of backends.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_connection_max" {
  name = "Configured maximum number of client connections allowed"

  program_text = <<-EOF
    data("postgresql.connection.max").publish(label="Configured maximum number of client connections allowed")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_rows" {
  name = "The number of rows in the database."

  program_text = <<-EOF
    data("postgresql.rows").publish(label="The number of rows in the database.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_index_scans" {
  name = "The number of index scans on a table."

  program_text = <<-EOF
    data("postgresql.index.scans").publish(label="The number of index scans on a table.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_index_size" {
  name = "The size of the index on disk."

  program_text = <<-EOF
    data("postgresql.index.size").publish(label="The size of the index on disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_operations" {
  name = "The number of db row operations."

  program_text = <<-EOF
    data("postgresql.operations").publish(label="The number of db row operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_replication_data_delay" {
  name = "The amount of data delayed in replication."

  program_text = <<-EOF
    data("postgresql.replication.data_delay").publish(label="The amount of data delayed in replication.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_rollbacks" {
  name = "The number of rollbacks."

  program_text = <<-EOF
    data("postgresql.rollbacks").publish(label="The number of rollbacks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_deadlocks" {
  name = "The number of deadlocks."

  program_text = <<-EOF
    data("postgresql.deadlocks").publish(label="The number of deadlocks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_sequential_scans" {
  name = "The number of sequential scans."

  program_text = <<-EOF
    data("postgresql.sequential_scans").publish(label="The number of sequential scans.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_table_count" {
  name = "Number of user tables in a database."

  program_text = <<-EOF
    data("postgresql.table.count").publish(label="Number of user tables in a database.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_table_size" {
  name = "Disk space used by a table."

  program_text = <<-EOF
    data("postgresql.table.size").publish(label="Disk space used by a table.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_table_vacuum_count" {
  name = "Number of times a table has manually been vacuumed."

  program_text = <<-EOF
    data("postgresql.table.vacuum.count").publish(label="Number of times a table has manually been vacuumed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_temp_files" {
  name = "The number of temp files."

  program_text = <<-EOF
    data("postgresql.temp_files").publish(label="The number of temp files.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_wal_age" {
  name = "Age of the oldest WAL file."

  program_text = <<-EOF
    data("postgresql.wal.age").publish(label="Age of the oldest WAL file.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_wal_lag" {
  name = "Time between flushing recent WAL locally and receiving notification that the standby server has completed an operation with it."

  program_text = <<-EOF
    data("postgresql.wal.lag").publish(label="Time between flushing recent WAL locally and receiving notification that the standby server has completed an operation with it.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "postgresql_wal_delay" {
  name = "Time between flushing recent WAL locally and receiving notification that the standby server has completed an operation with it."

  program_text = <<-EOF
    data("postgresql.wal.delay").publish(label="Time between flushing recent WAL locally and receiving notification that the standby server has completed an operation with it.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
