
resource "signalfx_dashboard" "docker_statsdashboard" {
  name            = "docker_stats"
  dashboard_group = signalfx_dashboard_group.docker_statsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.container_cpu_usage_system.id, signalfx_time_chart.container_cpu_usage_total.id, signalfx_time_chart.container_cpu_usage_kernelmode.id, signalfx_time_chart.container_cpu_usage_usermode.id, signalfx_time_chart.container_cpu_usage_percpu.id, signalfx_time_chart.container_cpu_throttling_data_periods.id, signalfx_time_chart.container_cpu_throttling_data_throttled_periods.id, signalfx_time_chart.container_cpu_throttling_data_throttled_time.id, signalfx_time_chart.container_cpu_utilization.id, signalfx_time_chart.container_cpu_limit.id, signalfx_time_chart.container_cpu_shares.id, signalfx_time_chart.container_memory_usage_limit.id, signalfx_time_chart.container_memory_usage_total.id, signalfx_time_chart.container_memory_usage_max.id, signalfx_time_chart.container_memory_percent.id, signalfx_time_chart.container_memory_cache.id, signalfx_time_chart.container_memory_rss.id, signalfx_time_chart.container_memory_rss_huge.id, signalfx_time_chart.container_memory_dirty.id, signalfx_time_chart.container_memory_writeback.id, signalfx_time_chart.container_memory_mapped_file.id, signalfx_time_chart.container_memory_pgpgin.id, signalfx_time_chart.container_memory_pgpgout.id, signalfx_time_chart.container_memory_pgfault.id, signalfx_time_chart.container_memory_pgmajfault.id, signalfx_time_chart.container_memory_inactive_anon.id, signalfx_time_chart.container_memory_active_anon.id, signalfx_time_chart.container_memory_inactive_file.id, signalfx_time_chart.container_memory_active_file.id, signalfx_time_chart.container_memory_unevictable.id, signalfx_time_chart.container_memory_hierarchical_memory_limit.id, signalfx_time_chart.container_memory_hierarchical_memsw_limit.id, signalfx_time_chart.container_memory_total_cache.id, signalfx_time_chart.container_memory_total_rss.id, signalfx_time_chart.container_memory_total_rss_huge.id, signalfx_time_chart.container_memory_total_dirty.id, signalfx_time_chart.container_memory_total_writeback.id, signalfx_time_chart.container_memory_total_mapped_file.id, signalfx_time_chart.container_memory_total_pgpgin.id, signalfx_time_chart.container_memory_total_pgpgout.id, signalfx_time_chart.container_memory_total_pgfault.id, signalfx_time_chart.container_memory_total_pgmajfault.id, signalfx_time_chart.container_memory_total_inactive_anon.id, signalfx_time_chart.container_memory_total_active_anon.id, signalfx_time_chart.container_memory_total_inactive_file.id, signalfx_time_chart.container_memory_total_active_file.id, signalfx_time_chart.container_memory_total_unevictable.id, signalfx_time_chart.container_memory_anon.id, signalfx_time_chart.container_memory_file.id, signalfx_time_chart.container_blockio_io_merged_recursive.id, signalfx_time_chart.container_blockio_io_queued_recursive.id, signalfx_time_chart.container_blockio_io_service_bytes_recursive.id, signalfx_time_chart.container_blockio_io_service_time_recursive.id, signalfx_time_chart.container_blockio_io_serviced_recursive.id, signalfx_time_chart.container_blockio_io_time_recursive.id, signalfx_time_chart.container_blockio_io_wait_time_recursive.id, signalfx_time_chart.container_blockio_sectors_recursive.id, signalfx_time_chart.container_network_io_usage_rx_bytes.id, signalfx_time_chart.container_network_io_usage_tx_bytes.id, signalfx_time_chart.container_network_io_usage_rx_dropped.id, signalfx_time_chart.container_network_io_usage_tx_dropped.id, signalfx_time_chart.container_network_io_usage_rx_errors.id, signalfx_time_chart.container_network_io_usage_tx_errors.id, signalfx_time_chart.container_network_io_usage_rx_packets.id, signalfx_time_chart.container_network_io_usage_tx_packets.id, signalfx_time_chart.container_pids_count.id, signalfx_time_chart.container_pids_limit.id, signalfx_time_chart.container_uptime.id, signalfx_time_chart.container_restarts.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "docker_statsdashboardgroup0" {
  name        = "docker_stats generated OTel dashboard group"
  description = "docker_stats generated OTel dashboard group"
}

resource "signalfx_time_chart" "container_cpu_usage_system" {
  name = "System CPU usage, as reported by docker."

  program_text = <<-EOF
    data("container.cpu.usage.system").publish(label="System CPU usage, as reported by docker.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_usage_total" {
  name = "Total CPU time consumed."

  program_text = <<-EOF
    data("container.cpu.usage.total").publish(label="Total CPU time consumed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_usage_kernelmode" {
  name = "Time spent by tasks of the cgroup in kernel mode (Linux).  Time spent by all container processes in kernel mode (Windows)."

  program_text = <<-EOF
    data("container.cpu.usage.kernelmode").publish(label="Time spent by tasks of the cgroup in kernel mode (Linux).  Time spent by all container processes in kernel mode (Windows).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_usage_usermode" {
  name = "Time spent by tasks of the cgroup in user mode (Linux).  Time spent by all container processes in user mode (Windows)."

  program_text = <<-EOF
    data("container.cpu.usage.usermode").publish(label="Time spent by tasks of the cgroup in user mode (Linux).  Time spent by all container processes in user mode (Windows).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_usage_percpu" {
  name = "Per-core CPU usage by the container (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.cpu.usage.percpu").publish(label="Per-core CPU usage by the container (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_throttling_data_periods" {
  name = "Number of periods with throttling active."

  program_text = <<-EOF
    data("container.cpu.throttling_data.periods").publish(label="Number of periods with throttling active.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_throttling_data_throttled_periods" {
  name = "Number of periods when the container hits its throttling limit."

  program_text = <<-EOF
    data("container.cpu.throttling_data.throttled_periods").publish(label="Number of periods when the container hits its throttling limit.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_throttling_data_throttled_time" {
  name = "Aggregate time the container was throttled."

  program_text = <<-EOF
    data("container.cpu.throttling_data.throttled_time").publish(label="Aggregate time the container was throttled.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_utilization" {
  name = "Percent of CPU used by the container."

  program_text = <<-EOF
    data("container.cpu.utilization").publish(label="Percent of CPU used by the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_limit" {
  name = "CPU limit set for the container."

  program_text = <<-EOF
    data("container.cpu.limit").publish(label="CPU limit set for the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_shares" {
  name = "CPU shares set for the container."

  program_text = <<-EOF
    data("container.cpu.shares").publish(label="CPU shares set for the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_usage_limit" {
  name = "Memory limit of the container."

  program_text = <<-EOF
    data("container.memory.usage.limit").publish(label="Memory limit of the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_usage_total" {
  name = "Memory usage of the container. This excludes the cache."

  program_text = <<-EOF
    data("container.memory.usage.total").publish(label="Memory usage of the container. This excludes the cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_usage_max" {
  name = "Maximum memory usage."

  program_text = <<-EOF
    data("container.memory.usage.max").publish(label="Maximum memory usage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_percent" {
  name = "Percentage of memory used."

  program_text = <<-EOF
    data("container.memory.percent").publish(label="Percentage of memory used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_cache" {
  name = "The amount of memory used by the processes of this control group that can be associated precisely with a block on a block device (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.cache").publish(label="The amount of memory used by the processes of this control group that can be associated precisely with a block on a block device (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_rss" {
  name = "The amount of memory that doesn’t correspond to anything on disk: stacks, heaps, and anonymous memory maps (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.rss").publish(label="The amount of memory that doesn’t correspond to anything on disk: stacks, heaps, and anonymous memory maps (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_rss_huge" {
  name = "Number of bytes of anonymous transparent hugepages in this cgroup (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.rss_huge").publish(label="Number of bytes of anonymous transparent hugepages in this cgroup (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_dirty" {
  name = "Bytes that are waiting to get written back to the disk, from this cgroup (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.dirty").publish(label="Bytes that are waiting to get written back to the disk, from this cgroup (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_writeback" {
  name = "Number of bytes of file/anon cache that are queued for syncing to disk in this cgroup (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.writeback").publish(label="Number of bytes of file/anon cache that are queued for syncing to disk in this cgroup (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_mapped_file" {
  name = "Indicates the amount of memory mapped by the processes in the control group (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.mapped_file").publish(label="Indicates the amount of memory mapped by the processes in the control group (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_pgpgin" {
  name = "Number of pages read from disk by the cgroup (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.pgpgin").publish(label="Number of pages read from disk by the cgroup (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_pgpgout" {
  name = "Number of pages written to disk by the cgroup (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.pgpgout").publish(label="Number of pages written to disk by the cgroup (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_pgfault" {
  name = "Indicate the number of times that a process of the cgroup triggered a page fault."

  program_text = <<-EOF
    data("container.memory.pgfault").publish(label="Indicate the number of times that a process of the cgroup triggered a page fault.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_pgmajfault" {
  name = "Indicate the number of times that a process of the cgroup triggered a major fault."

  program_text = <<-EOF
    data("container.memory.pgmajfault").publish(label="Indicate the number of times that a process of the cgroup triggered a major fault.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_inactive_anon" {
  name = "The amount of anonymous memory that has been identified as inactive by the kernel."

  program_text = <<-EOF
    data("container.memory.inactive_anon").publish(label="The amount of anonymous memory that has been identified as inactive by the kernel.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_active_anon" {
  name = "The amount of anonymous memory that has been identified as active by the kernel."

  program_text = <<-EOF
    data("container.memory.active_anon").publish(label="The amount of anonymous memory that has been identified as active by the kernel.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_inactive_file" {
  name = "Cache memory that has been identified as inactive by the kernel."

  program_text = <<-EOF
    data("container.memory.inactive_file").publish(label="Cache memory that has been identified as inactive by the kernel.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_active_file" {
  name = "Cache memory that has been identified as active by the kernel."

  program_text = <<-EOF
    data("container.memory.active_file").publish(label="Cache memory that has been identified as active by the kernel.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_unevictable" {
  name = "The amount of memory that cannot be reclaimed."

  program_text = <<-EOF
    data("container.memory.unevictable").publish(label="The amount of memory that cannot be reclaimed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_hierarchical_memory_limit" {
  name = "The maximum amount of physical memory that can be used by the processes of this control group (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.hierarchical_memory_limit").publish(label="The maximum amount of physical memory that can be used by the processes of this control group (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_hierarchical_memsw_limit" {
  name = "The maximum amount of RAM + swap that can be used by the processes of this control group (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.hierarchical_memsw_limit").publish(label="The maximum amount of RAM + swap that can be used by the processes of this control group (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_cache" {
  name = "Total amount of memory used by the processes of this cgroup (and descendants) that can be associated with a block on a block device. Also accounts for memory used by tmpfs (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_cache").publish(label="Total amount of memory used by the processes of this cgroup (and descendants) that can be associated with a block on a block device. Also accounts for memory used by tmpfs (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_rss" {
  name = "The amount of memory that doesn’t correspond to anything on disk: stacks, heaps, and anonymous memory maps. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_rss").publish(label="The amount of memory that doesn’t correspond to anything on disk: stacks, heaps, and anonymous memory maps. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_rss_huge" {
  name = "Number of bytes of anonymous transparent hugepages in this cgroup and descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_rss_huge").publish(label="Number of bytes of anonymous transparent hugepages in this cgroup and descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_dirty" {
  name = "Bytes that are waiting to get written back to the disk, from this cgroup and descendants (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_dirty").publish(label="Bytes that are waiting to get written back to the disk, from this cgroup and descendants (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_writeback" {
  name = "Number of bytes of file/anon cache that are queued for syncing to disk in this cgroup and descendants (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_writeback").publish(label="Number of bytes of file/anon cache that are queued for syncing to disk in this cgroup and descendants (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_mapped_file" {
  name = "Indicates the amount of memory mapped by the processes in the control group and descendant groups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_mapped_file").publish(label="Indicates the amount of memory mapped by the processes in the control group and descendant groups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_pgpgin" {
  name = "Number of pages read from disk by the cgroup and descendant groups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_pgpgin").publish(label="Number of pages read from disk by the cgroup and descendant groups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_pgpgout" {
  name = "Number of pages written to disk by the cgroup and descendant groups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_pgpgout").publish(label="Number of pages written to disk by the cgroup and descendant groups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_pgfault" {
  name = "Indicate the number of times that a process of the cgroup (or descendant cgroups) triggered a page fault (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_pgfault").publish(label="Indicate the number of times that a process of the cgroup (or descendant cgroups) triggered a page fault (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_pgmajfault" {
  name = "Indicate the number of times that a process of the cgroup (or descendant cgroups) triggered a major fault (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_pgmajfault").publish(label="Indicate the number of times that a process of the cgroup (or descendant cgroups) triggered a major fault (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_inactive_anon" {
  name = "The amount of anonymous memory that has been identified as inactive by the kernel. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_inactive_anon").publish(label="The amount of anonymous memory that has been identified as inactive by the kernel. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_active_anon" {
  name = "The amount of anonymous memory that has been identified as active by the kernel. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_active_anon").publish(label="The amount of anonymous memory that has been identified as active by the kernel. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_inactive_file" {
  name = "Cache memory that has been identified as inactive by the kernel. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_inactive_file").publish(label="Cache memory that has been identified as inactive by the kernel. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_active_file" {
  name = "Cache memory that has been identified as active by the kernel. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_active_file").publish(label="Cache memory that has been identified as active by the kernel. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_total_unevictable" {
  name = "The amount of memory that cannot be reclaimed. Includes descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.memory.total_unevictable").publish(label="The amount of memory that cannot be reclaimed. Includes descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_anon" {
  name = "Amount of memory used in anonymous mappings such as brk(), sbrk(), and mmap(MAP_ANONYMOUS) (Only available with cgroups v2)."

  program_text = <<-EOF
    data("container.memory.anon").publish(label="Amount of memory used in anonymous mappings such as brk(), sbrk(), and mmap(MAP_ANONYMOUS) (Only available with cgroups v2).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_file" {
  name = "Amount of memory used to cache filesystem data, including tmpfs and shared memory (Only available with cgroups v2)."

  program_text = <<-EOF
    data("container.memory.file").publish(label="Amount of memory used to cache filesystem data, including tmpfs and shared memory (Only available with cgroups v2).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_merged_recursive" {
  name = "Number of bios/requests merged into requests belonging to this cgroup and its descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_merged_recursive").publish(label="Number of bios/requests merged into requests belonging to this cgroup and its descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_queued_recursive" {
  name = "Number of requests queued up for this cgroup and its descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_queued_recursive").publish(label="Number of requests queued up for this cgroup and its descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_service_bytes_recursive" {
  name = "Number of bytes transferred to/from the disk by the group and descendant groups."

  program_text = <<-EOF
    data("container.blockio.io_service_bytes_recursive").publish(label="Number of bytes transferred to/from the disk by the group and descendant groups.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_service_time_recursive" {
  name = "Total amount of time in nanoseconds between request dispatch and request completion for the IOs done by this cgroup and descendant cgroups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_service_time_recursive").publish(label="Total amount of time in nanoseconds between request dispatch and request completion for the IOs done by this cgroup and descendant cgroups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_serviced_recursive" {
  name = "Number of IOs (bio) issued to the disk by the group and descendant groups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_serviced_recursive").publish(label="Number of IOs (bio) issued to the disk by the group and descendant groups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_time_recursive" {
  name = "Disk time allocated to cgroup (and descendant cgroups) per device in milliseconds (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_time_recursive").publish(label="Disk time allocated to cgroup (and descendant cgroups) per device in milliseconds (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_io_wait_time_recursive" {
  name = "Total amount of time the IOs for this cgroup (and descendant cgroups) spent waiting in the scheduler queues for service (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.io_wait_time_recursive").publish(label="Total amount of time the IOs for this cgroup (and descendant cgroups) spent waiting in the scheduler queues for service (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_blockio_sectors_recursive" {
  name = "Number of sectors transferred to/from disk by the group and descendant groups (Only available with cgroups v1)."

  program_text = <<-EOF
    data("container.blockio.sectors_recursive").publish(label="Number of sectors transferred to/from disk by the group and descendant groups (Only available with cgroups v1).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_rx_bytes" {
  name = "Bytes received by the container."

  program_text = <<-EOF
    data("container.network.io.usage.rx_bytes").publish(label="Bytes received by the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_tx_bytes" {
  name = "Bytes sent."

  program_text = <<-EOF
    data("container.network.io.usage.tx_bytes").publish(label="Bytes sent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_rx_dropped" {
  name = "Incoming packets dropped."

  program_text = <<-EOF
    data("container.network.io.usage.rx_dropped").publish(label="Incoming packets dropped.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_tx_dropped" {
  name = "Outgoing packets dropped."

  program_text = <<-EOF
    data("container.network.io.usage.tx_dropped").publish(label="Outgoing packets dropped.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_rx_errors" {
  name = "Received errors."

  program_text = <<-EOF
    data("container.network.io.usage.rx_errors").publish(label="Received errors.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_tx_errors" {
  name = "Sent errors."

  program_text = <<-EOF
    data("container.network.io.usage.tx_errors").publish(label="Sent errors.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_rx_packets" {
  name = "Packets received."

  program_text = <<-EOF
    data("container.network.io.usage.rx_packets").publish(label="Packets received.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_network_io_usage_tx_packets" {
  name = "Packets sent."

  program_text = <<-EOF
    data("container.network.io.usage.tx_packets").publish(label="Packets sent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_pids_count" {
  name = "Number of pids in the container's cgroup."

  program_text = <<-EOF
    data("container.pids.count").publish(label="Number of pids in the container's cgroup.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_pids_limit" {
  name = "Maximum number of pids in the container's cgroup."

  program_text = <<-EOF
    data("container.pids.limit").publish(label="Maximum number of pids in the container's cgroup.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_uptime" {
  name = "Time elapsed since container start time."

  program_text = <<-EOF
    data("container.uptime").publish(label="Time elapsed since container start time.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_restarts" {
  name = "Number of restarts for the container."

  program_text = <<-EOF
    data("container.restarts").publish(label="Number of restarts for the container.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
