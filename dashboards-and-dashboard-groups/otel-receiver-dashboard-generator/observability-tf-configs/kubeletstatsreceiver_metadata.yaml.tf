
resource "signalfx_dashboard" "kubeletstatsdashboard" {
  name            = "kubeletstats"
  dashboard_group = signalfx_dashboard_group.kubeletstatsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.k8s_node_cpu_utilization.id, signalfx_time_chart.k8s_node_cpu_time.id, signalfx_time_chart.k8s_node_memory_available.id, signalfx_time_chart.k8s_node_memory_usage.id, signalfx_time_chart.k8s_node_memory_rss.id, signalfx_time_chart.k8s_node_memory_working_set.id, signalfx_time_chart.k8s_node_memory_page_faults.id, signalfx_time_chart.k8s_node_memory_major_page_faults.id, signalfx_time_chart.k8s_node_filesystem_available.id, signalfx_time_chart.k8s_node_filesystem_capacity.id, signalfx_time_chart.k8s_node_filesystem_usage.id, signalfx_time_chart.k8s_node_network_io.id, signalfx_time_chart.k8s_node_network_errors.id, signalfx_time_chart.k8s_node_uptime.id, signalfx_time_chart.k8s_pod_cpu_utilization.id, signalfx_time_chart.k8s_pod_cpu_time.id, signalfx_time_chart.k8s_pod_memory_available.id, signalfx_time_chart.k8s_pod_memory_usage.id, signalfx_time_chart.k8s_pod_cpu_limit_utilization.id, signalfx_time_chart.k8s_pod_cpu_request_utilization.id, signalfx_time_chart.k8s_pod_memory_limit_utilization.id, signalfx_time_chart.k8s_pod_memory_request_utilization.id, signalfx_time_chart.k8s_pod_memory_rss.id, signalfx_time_chart.k8s_pod_memory_working_set.id, signalfx_time_chart.k8s_pod_memory_page_faults.id, signalfx_time_chart.k8s_pod_memory_major_page_faults.id, signalfx_time_chart.k8s_pod_filesystem_available.id, signalfx_time_chart.k8s_pod_filesystem_capacity.id, signalfx_time_chart.k8s_pod_filesystem_usage.id, signalfx_time_chart.k8s_pod_network_io.id, signalfx_time_chart.k8s_pod_network_errors.id, signalfx_time_chart.k8s_pod_uptime.id, signalfx_time_chart.container_cpu_utilization.id, signalfx_time_chart.container_cpu_time.id, signalfx_time_chart.container_memory_available.id, signalfx_time_chart.container_memory_usage.id, signalfx_time_chart.k8s_container_cpu_limit_utilization.id, signalfx_time_chart.k8s_container_cpu_request_utilization.id, signalfx_time_chart.k8s_container_memory_limit_utilization.id, signalfx_time_chart.k8s_container_memory_request_utilization.id, signalfx_time_chart.container_memory_rss.id, signalfx_time_chart.container_memory_working_set.id, signalfx_time_chart.container_memory_page_faults.id, signalfx_time_chart.container_memory_major_page_faults.id, signalfx_time_chart.container_filesystem_available.id, signalfx_time_chart.container_filesystem_capacity.id, signalfx_time_chart.container_filesystem_usage.id, signalfx_time_chart.container_uptime.id, signalfx_time_chart.k8s_volume_available.id, signalfx_time_chart.k8s_volume_capacity.id, signalfx_time_chart.k8s_volume_inodes.id, signalfx_time_chart.k8s_volume_inodes_free.id, signalfx_time_chart.k8s_volume_inodes_used.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "kubeletstatsdashboardgroup0" {
  name        = "kubeletstats generated OTel dashboard group"
  description = "kubeletstats generated OTel dashboard group"
}

resource "signalfx_time_chart" "k8s_node_cpu_utilization" {
  name = "Node CPU utilization"

  program_text = <<-EOF
    data("k8s.node.cpu.utilization").publish(label="Node CPU utilization")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_cpu_time" {
  name = "Node CPU time"

  program_text = <<-EOF
    data("k8s.node.cpu.time").publish(label="Node CPU time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_available" {
  name = "Node memory available"

  program_text = <<-EOF
    data("k8s.node.memory.available").publish(label="Node memory available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_usage" {
  name = "Node memory usage"

  program_text = <<-EOF
    data("k8s.node.memory.usage").publish(label="Node memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_rss" {
  name = "Node memory rss"

  program_text = <<-EOF
    data("k8s.node.memory.rss").publish(label="Node memory rss")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_working_set" {
  name = "Node memory working_set"

  program_text = <<-EOF
    data("k8s.node.memory.working_set").publish(label="Node memory working_set")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_page_faults" {
  name = "Node memory page_faults"

  program_text = <<-EOF
    data("k8s.node.memory.page_faults").publish(label="Node memory page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_memory_major_page_faults" {
  name = "Node memory major_page_faults"

  program_text = <<-EOF
    data("k8s.node.memory.major_page_faults").publish(label="Node memory major_page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_filesystem_available" {
  name = "Node filesystem available"

  program_text = <<-EOF
    data("k8s.node.filesystem.available").publish(label="Node filesystem available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_filesystem_capacity" {
  name = "Node filesystem capacity"

  program_text = <<-EOF
    data("k8s.node.filesystem.capacity").publish(label="Node filesystem capacity")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_filesystem_usage" {
  name = "Node filesystem usage"

  program_text = <<-EOF
    data("k8s.node.filesystem.usage").publish(label="Node filesystem usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_network_io" {
  name = "Node network IO"

  program_text = <<-EOF
    data("k8s.node.network.io").publish(label="Node network IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_network_errors" {
  name = "Node network errors"

  program_text = <<-EOF
    data("k8s.node.network.errors").publish(label="Node network errors")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_uptime" {
  name = "The time since the node started"

  program_text = <<-EOF
    data("k8s.node.uptime").publish(label="The time since the node started")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_cpu_utilization" {
  name = "Pod CPU utilization"

  program_text = <<-EOF
    data("k8s.pod.cpu.utilization").publish(label="Pod CPU utilization")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_cpu_time" {
  name = "Pod CPU time"

  program_text = <<-EOF
    data("k8s.pod.cpu.time").publish(label="Pod CPU time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_available" {
  name = "Pod memory available"

  program_text = <<-EOF
    data("k8s.pod.memory.available").publish(label="Pod memory available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_usage" {
  name = "Pod memory usage"

  program_text = <<-EOF
    data("k8s.pod.memory.usage").publish(label="Pod memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_cpu_limit_utilization" {
  name = "Pod cpu utilization as a ratio of the pod's total container limits. If any container is missing a limit the metric is not emitted."

  program_text = <<-EOF
    data("k8s.pod.cpu_limit_utilization").publish(label="Pod cpu utilization as a ratio of the pod's total container limits. If any container is missing a limit the metric is not emitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_cpu_request_utilization" {
  name = "Pod cpu utilization as a ratio of the pod's total container requests. If any container is missing a request the metric is not emitted."

  program_text = <<-EOF
    data("k8s.pod.cpu_request_utilization").publish(label="Pod cpu utilization as a ratio of the pod's total container requests. If any container is missing a request the metric is not emitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_limit_utilization" {
  name = "Pod memory utilization as a ratio of the pod's total container limits. If any container is missing a limit the metric is not emitted."

  program_text = <<-EOF
    data("k8s.pod.memory_limit_utilization").publish(label="Pod memory utilization as a ratio of the pod's total container limits. If any container is missing a limit the metric is not emitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_request_utilization" {
  name = "Pod memory utilization as a ratio of the pod's total container requests. If any container is missing a request the metric is not emitted."

  program_text = <<-EOF
    data("k8s.pod.memory_request_utilization").publish(label="Pod memory utilization as a ratio of the pod's total container requests. If any container is missing a request the metric is not emitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_rss" {
  name = "Pod memory rss"

  program_text = <<-EOF
    data("k8s.pod.memory.rss").publish(label="Pod memory rss")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_working_set" {
  name = "Pod memory working_set"

  program_text = <<-EOF
    data("k8s.pod.memory.working_set").publish(label="Pod memory working_set")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_page_faults" {
  name = "Pod memory page_faults"

  program_text = <<-EOF
    data("k8s.pod.memory.page_faults").publish(label="Pod memory page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_memory_major_page_faults" {
  name = "Pod memory major_page_faults"

  program_text = <<-EOF
    data("k8s.pod.memory.major_page_faults").publish(label="Pod memory major_page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_filesystem_available" {
  name = "Pod filesystem available"

  program_text = <<-EOF
    data("k8s.pod.filesystem.available").publish(label="Pod filesystem available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_filesystem_capacity" {
  name = "Pod filesystem capacity"

  program_text = <<-EOF
    data("k8s.pod.filesystem.capacity").publish(label="Pod filesystem capacity")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_filesystem_usage" {
  name = "Pod filesystem usage"

  program_text = <<-EOF
    data("k8s.pod.filesystem.usage").publish(label="Pod filesystem usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_network_io" {
  name = "Pod network IO"

  program_text = <<-EOF
    data("k8s.pod.network.io").publish(label="Pod network IO")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_network_errors" {
  name = "Pod network errors"

  program_text = <<-EOF
    data("k8s.pod.network.errors").publish(label="Pod network errors")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_uptime" {
  name = "The time since the pod started"

  program_text = <<-EOF
    data("k8s.pod.uptime").publish(label="The time since the pod started")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_utilization" {
  name = "Container CPU utilization"

  program_text = <<-EOF
    data("container.cpu.utilization").publish(label="Container CPU utilization")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_cpu_time" {
  name = "Container CPU time"

  program_text = <<-EOF
    data("container.cpu.time").publish(label="Container CPU time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_available" {
  name = "Container memory available"

  program_text = <<-EOF
    data("container.memory.available").publish(label="Container memory available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_usage" {
  name = "Container memory usage"

  program_text = <<-EOF
    data("container.memory.usage").publish(label="Container memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_cpu_limit_utilization" {
  name = "Container cpu utilization as a ratio of the container's limits"

  program_text = <<-EOF
    data("k8s.container.cpu_limit_utilization").publish(label="Container cpu utilization as a ratio of the container's limits")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_cpu_request_utilization" {
  name = "Container cpu utilization as a ratio of the container's requests"

  program_text = <<-EOF
    data("k8s.container.cpu_request_utilization").publish(label="Container cpu utilization as a ratio of the container's requests")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_memory_limit_utilization" {
  name = "Container memory utilization as a ratio of the container's limits"

  program_text = <<-EOF
    data("k8s.container.memory_limit_utilization").publish(label="Container memory utilization as a ratio of the container's limits")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_memory_request_utilization" {
  name = "Container memory utilization as a ratio of the container's requests"

  program_text = <<-EOF
    data("k8s.container.memory_request_utilization").publish(label="Container memory utilization as a ratio of the container's requests")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_rss" {
  name = "Container memory rss"

  program_text = <<-EOF
    data("container.memory.rss").publish(label="Container memory rss")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_working_set" {
  name = "Container memory working_set"

  program_text = <<-EOF
    data("container.memory.working_set").publish(label="Container memory working_set")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_page_faults" {
  name = "Container memory page_faults"

  program_text = <<-EOF
    data("container.memory.page_faults").publish(label="Container memory page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_memory_major_page_faults" {
  name = "Container memory major_page_faults"

  program_text = <<-EOF
    data("container.memory.major_page_faults").publish(label="Container memory major_page_faults")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_filesystem_available" {
  name = "Container filesystem available"

  program_text = <<-EOF
    data("container.filesystem.available").publish(label="Container filesystem available")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_filesystem_capacity" {
  name = "Container filesystem capacity"

  program_text = <<-EOF
    data("container.filesystem.capacity").publish(label="Container filesystem capacity")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_filesystem_usage" {
  name = "Container filesystem usage"

  program_text = <<-EOF
    data("container.filesystem.usage").publish(label="Container filesystem usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "container_uptime" {
  name = "The time since the container started"

  program_text = <<-EOF
    data("container.uptime").publish(label="The time since the container started")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_volume_available" {
  name = "The number of available bytes in the volume."

  program_text = <<-EOF
    data("k8s.volume.available").publish(label="The number of available bytes in the volume.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_volume_capacity" {
  name = "The total capacity in bytes of the volume."

  program_text = <<-EOF
    data("k8s.volume.capacity").publish(label="The total capacity in bytes of the volume.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_volume_inodes" {
  name = "The total inodes in the filesystem."

  program_text = <<-EOF
    data("k8s.volume.inodes").publish(label="The total inodes in the filesystem.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_volume_inodes_free" {
  name = "The free inodes in the filesystem."

  program_text = <<-EOF
    data("k8s.volume.inodes.free").publish(label="The free inodes in the filesystem.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_volume_inodes_used" {
  name = "The inodes used by the filesystem. This may not equal inodes - free because filesystem may share inodes with other filesystems."

  program_text = <<-EOF
    data("k8s.volume.inodes.used").publish(label="The inodes used by the filesystem. This may not equal inodes - free because filesystem may share inodes with other filesystems.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
