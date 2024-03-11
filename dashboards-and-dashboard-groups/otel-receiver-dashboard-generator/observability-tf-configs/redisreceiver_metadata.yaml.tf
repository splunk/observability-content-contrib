
resource "signalfx_dashboard" "redisdashboard" {
  name            = "redis"
  dashboard_group = signalfx_dashboard_group.redisdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.redis_maxmemory.id, signalfx_time_chart.redis_role.id, signalfx_time_chart.redis_cmd_calls.id, signalfx_time_chart.redis_cmd_usec.id, signalfx_time_chart.redis_cmd_latency.id, signalfx_time_chart.redis_uptime.id, signalfx_time_chart.redis_cpu_time.id, signalfx_time_chart.redis_clients_connected.id, signalfx_time_chart.redis_clients_max_input_buffer.id, signalfx_time_chart.redis_clients_max_output_buffer.id, signalfx_time_chart.redis_clients_blocked.id, signalfx_time_chart.redis_keys_expired.id, signalfx_time_chart.redis_keys_evicted.id, signalfx_time_chart.redis_connections_received.id, signalfx_time_chart.redis_connections_rejected.id, signalfx_time_chart.redis_memory_used.id, signalfx_time_chart.redis_memory_peak.id, signalfx_time_chart.redis_memory_rss.id, signalfx_time_chart.redis_memory_lua.id, signalfx_time_chart.redis_memory_fragmentation_ratio.id, signalfx_time_chart.redis_rdb_changes_since_last_save.id, signalfx_time_chart.redis_commands.id, signalfx_time_chart.redis_commands_processed.id, signalfx_time_chart.redis_net_input.id, signalfx_time_chart.redis_net_output.id, signalfx_time_chart.redis_keyspace_hits.id, signalfx_time_chart.redis_keyspace_misses.id, signalfx_time_chart.redis_latest_fork.id, signalfx_time_chart.redis_slaves_connected.id, signalfx_time_chart.redis_replication_backlog_first_byte_offset.id, signalfx_time_chart.redis_replication_offset.id, signalfx_time_chart.redis_db_keys.id, signalfx_time_chart.redis_db_expires.id, signalfx_time_chart.redis_db_avg_ttl.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "redisdashboardgroup0" {
  name        = "redis generated OTel dashboard group"
  description = "redis generated OTel dashboard group"
}

resource "signalfx_time_chart" "redis_maxmemory" {
  name = "The value of the maxmemory configuration directive"

  program_text = <<-EOF
    data("redis.maxmemory").publish(label="The value of the maxmemory configuration directive")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_role" {
  name = "Redis node's role"

  program_text = <<-EOF
    data("redis.role").publish(label="Redis node's role")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_cmd_calls" {
  name = "Total number of calls for a command"

  program_text = <<-EOF
    data("redis.cmd.calls").publish(label="Total number of calls for a command")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_cmd_usec" {
  name = "Total time for all executions of this command"

  program_text = <<-EOF
    data("redis.cmd.usec").publish(label="Total time for all executions of this command")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_cmd_latency" {
  name = "Command execution latency"

  program_text = <<-EOF
    data("redis.cmd.latency").publish(label="Command execution latency")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_uptime" {
  name = "Number of seconds since Redis server start"

  program_text = <<-EOF
    data("redis.uptime").publish(label="Number of seconds since Redis server start")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_cpu_time" {
  name = "System CPU consumed by the Redis server in seconds since server start"

  program_text = <<-EOF
    data("redis.cpu.time").publish(label="System CPU consumed by the Redis server in seconds since server start")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_clients_connected" {
  name = "Number of client connections (excluding connections from replicas)"

  program_text = <<-EOF
    data("redis.clients.connected").publish(label="Number of client connections (excluding connections from replicas)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_clients_max_input_buffer" {
  name = "Biggest input buffer among current client connections"

  program_text = <<-EOF
    data("redis.clients.max_input_buffer").publish(label="Biggest input buffer among current client connections")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_clients_max_output_buffer" {
  name = "Longest output list among current client connections"

  program_text = <<-EOF
    data("redis.clients.max_output_buffer").publish(label="Longest output list among current client connections")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_clients_blocked" {
  name = "Number of clients pending on a blocking call"

  program_text = <<-EOF
    data("redis.clients.blocked").publish(label="Number of clients pending on a blocking call")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_keys_expired" {
  name = "Total number of key expiration events"

  program_text = <<-EOF
    data("redis.keys.expired").publish(label="Total number of key expiration events")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_keys_evicted" {
  name = "Number of evicted keys due to maxmemory limit"

  program_text = <<-EOF
    data("redis.keys.evicted").publish(label="Number of evicted keys due to maxmemory limit")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_connections_received" {
  name = "Total number of connections accepted by the server"

  program_text = <<-EOF
    data("redis.connections.received").publish(label="Total number of connections accepted by the server")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_connections_rejected" {
  name = "Number of connections rejected because of maxclients limit"

  program_text = <<-EOF
    data("redis.connections.rejected").publish(label="Number of connections rejected because of maxclients limit")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_memory_used" {
  name = "Total number of bytes allocated by Redis using its allocator"

  program_text = <<-EOF
    data("redis.memory.used").publish(label="Total number of bytes allocated by Redis using its allocator")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_memory_peak" {
  name = "Peak memory consumed by Redis (in bytes)"

  program_text = <<-EOF
    data("redis.memory.peak").publish(label="Peak memory consumed by Redis (in bytes)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_memory_rss" {
  name = "Number of bytes that Redis allocated as seen by the operating system"

  program_text = <<-EOF
    data("redis.memory.rss").publish(label="Number of bytes that Redis allocated as seen by the operating system")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_memory_lua" {
  name = "Number of bytes used by the Lua engine"

  program_text = <<-EOF
    data("redis.memory.lua").publish(label="Number of bytes used by the Lua engine")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_memory_fragmentation_ratio" {
  name = "Ratio between used_memory_rss and used_memory"

  program_text = <<-EOF
    data("redis.memory.fragmentation_ratio").publish(label="Ratio between used_memory_rss and used_memory")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_rdb_changes_since_last_save" {
  name = "Number of changes since the last dump"

  program_text = <<-EOF
    data("redis.rdb.changes_since_last_save").publish(label="Number of changes since the last dump")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_commands" {
  name = "Number of commands processed per second"

  program_text = <<-EOF
    data("redis.commands").publish(label="Number of commands processed per second")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_commands_processed" {
  name = "Total number of commands processed by the server"

  program_text = <<-EOF
    data("redis.commands.processed").publish(label="Total number of commands processed by the server")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_net_input" {
  name = "The total number of bytes read from the network"

  program_text = <<-EOF
    data("redis.net.input").publish(label="The total number of bytes read from the network")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_net_output" {
  name = "The total number of bytes written to the network"

  program_text = <<-EOF
    data("redis.net.output").publish(label="The total number of bytes written to the network")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_keyspace_hits" {
  name = "Number of successful lookup of keys in the main dictionary"

  program_text = <<-EOF
    data("redis.keyspace.hits").publish(label="Number of successful lookup of keys in the main dictionary")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_keyspace_misses" {
  name = "Number of failed lookup of keys in the main dictionary"

  program_text = <<-EOF
    data("redis.keyspace.misses").publish(label="Number of failed lookup of keys in the main dictionary")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_latest_fork" {
  name = "Duration of the latest fork operation in microseconds"

  program_text = <<-EOF
    data("redis.latest_fork").publish(label="Duration of the latest fork operation in microseconds")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_slaves_connected" {
  name = "Number of connected replicas"

  program_text = <<-EOF
    data("redis.slaves.connected").publish(label="Number of connected replicas")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_replication_backlog_first_byte_offset" {
  name = "The master offset of the replication backlog buffer"

  program_text = <<-EOF
    data("redis.replication.backlog_first_byte_offset").publish(label="The master offset of the replication backlog buffer")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_replication_offset" {
  name = "The server's current replication offset"

  program_text = <<-EOF
    data("redis.replication.offset").publish(label="The server's current replication offset")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_db_keys" {
  name = "Number of keyspace keys"

  program_text = <<-EOF
    data("redis.db.keys").publish(label="Number of keyspace keys")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_db_expires" {
  name = "Number of keyspace keys with an expiration"

  program_text = <<-EOF
    data("redis.db.expires").publish(label="Number of keyspace keys with an expiration")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "redis_db_avg_ttl" {
  name = "Average keyspace keys TTL"

  program_text = <<-EOF
    data("redis.db.avg_ttl").publish(label="Average keyspace keys TTL")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
