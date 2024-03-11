
resource "signalfx_dashboard" "vcenterdashboard" {
  name            = "vcenter"
  dashboard_group = signalfx_dashboard_group.vcenterdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.vcenter_cluster_cpu_limit.id, signalfx_time_chart.vcenter_cluster_cpu_effective.id, signalfx_time_chart.vcenter_cluster_memory_limit.id, signalfx_time_chart.vcenter_cluster_memory_effective.id, signalfx_time_chart.vcenter_cluster_memory_used.id, signalfx_time_chart.vcenter_cluster_vm_count.id, signalfx_time_chart.vcenter_cluster_host_count.id, signalfx_time_chart.vcenter_datastore_disk_usage.id, signalfx_time_chart.vcenter_datastore_disk_utilization.id, signalfx_time_chart.vcenter_host_cpu_utilization.id, signalfx_time_chart.vcenter_host_cpu_usage.id, signalfx_time_chart.vcenter_host_disk_throughput.id, signalfx_time_chart.vcenter_host_disk_latency_avg.id, signalfx_time_chart.vcenter_host_disk_latency_max.id, signalfx_time_chart.vcenter_host_memory_utilization.id, signalfx_time_chart.vcenter_host_memory_usage.id, signalfx_time_chart.vcenter_host_network_throughput.id, signalfx_time_chart.vcenter_host_network_usage.id, signalfx_time_chart.vcenter_host_network_packet_errors.id, signalfx_time_chart.vcenter_host_network_packet_count.id, signalfx_time_chart.vcenter_resource_pool_memory_usage.id, signalfx_time_chart.vcenter_resource_pool_memory_shares.id, signalfx_time_chart.vcenter_resource_pool_cpu_usage.id, signalfx_time_chart.vcenter_resource_pool_cpu_shares.id, signalfx_time_chart.vcenter_vm_memory_ballooned.id, signalfx_time_chart.vcenter_vm_memory_usage.id, signalfx_time_chart.vcenter_vm_memory_swapped.id, signalfx_time_chart.vcenter_vm_memory_swapped_ssd.id, signalfx_time_chart.vcenter_vm_disk_usage.id, signalfx_time_chart.vcenter_vm_disk_utilization.id, signalfx_time_chart.vcenter_vm_disk_latency_avg.id, signalfx_time_chart.vcenter_vm_disk_latency_max.id, signalfx_time_chart.vcenter_vm_disk_throughput.id, signalfx_time_chart.vcenter_vm_network_throughput.id, signalfx_time_chart.vcenter_vm_network_packet_count.id, signalfx_time_chart.vcenter_vm_network_usage.id, signalfx_time_chart.vcenter_vm_cpu_utilization.id, signalfx_time_chart.vcenter_vm_cpu_usage.id, signalfx_time_chart.vcenter_vm_memory_utilization.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "vcenterdashboardgroup0" {
  name        = "vcenter generated OTel dashboard group"
  description = "vcenter generated OTel dashboard group"
}

resource "signalfx_time_chart" "vcenter_cluster_cpu_limit" {
  name = "The amount of CPU available to the cluster."

  program_text = <<-EOF
    data("vcenter.cluster.cpu.limit").publish(label="The amount of CPU available to the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_cpu_effective" {
  name = "The effective CPU available to the cluster. This value excludes CPU from hosts in maintenance mode or are unresponsive."

  program_text = <<-EOF
    data("vcenter.cluster.cpu.effective").publish(label="The effective CPU available to the cluster. This value excludes CPU from hosts in maintenance mode or are unresponsive.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_memory_limit" {
  name = "The available memory of the cluster."

  program_text = <<-EOF
    data("vcenter.cluster.memory.limit").publish(label="The available memory of the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_memory_effective" {
  name = "The effective memory of the cluster. This value excludes memory from hosts in maintenance mode or are unresponsive."

  program_text = <<-EOF
    data("vcenter.cluster.memory.effective").publish(label="The effective memory of the cluster. This value excludes memory from hosts in maintenance mode or are unresponsive.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_memory_used" {
  name = "The memory that is currently used by the cluster."

  program_text = <<-EOF
    data("vcenter.cluster.memory.used").publish(label="The memory that is currently used by the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_vm_count" {
  name = "the number of virtual machines in the cluster."

  program_text = <<-EOF
    data("vcenter.cluster.vm.count").publish(label="the number of virtual machines in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_cluster_host_count" {
  name = "The number of hosts in the cluster."

  program_text = <<-EOF
    data("vcenter.cluster.host.count").publish(label="The number of hosts in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_datastore_disk_usage" {
  name = "The amount of space in the datastore."

  program_text = <<-EOF
    data("vcenter.datastore.disk.usage").publish(label="The amount of space in the datastore.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_datastore_disk_utilization" {
  name = "The utilization of the datastore."

  program_text = <<-EOF
    data("vcenter.datastore.disk.utilization").publish(label="The utilization of the datastore.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_cpu_utilization" {
  name = "The CPU utilization of the host system."

  program_text = <<-EOF
    data("vcenter.host.cpu.utilization").publish(label="The CPU utilization of the host system.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_cpu_usage" {
  name = "The amount of CPU used by the host."

  program_text = <<-EOF
    data("vcenter.host.cpu.usage").publish(label="The amount of CPU used by the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_disk_throughput" {
  name = "Average number of kilobytes read from or written to the disk each second."

  program_text = <<-EOF
    data("vcenter.host.disk.throughput").publish(label="Average number of kilobytes read from or written to the disk each second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_disk_latency_avg" {
  name = "The latency of operations to the host system's disk."

  program_text = <<-EOF
    data("vcenter.host.disk.latency.avg").publish(label="The latency of operations to the host system's disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_disk_latency_max" {
  name = "Highest latency value across all disks used by the host."

  program_text = <<-EOF
    data("vcenter.host.disk.latency.max").publish(label="Highest latency value across all disks used by the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_memory_utilization" {
  name = "The percentage of the host system's memory capacity that is being utilized."

  program_text = <<-EOF
    data("vcenter.host.memory.utilization").publish(label="The percentage of the host system's memory capacity that is being utilized.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_memory_usage" {
  name = "The amount of memory the host system is using."

  program_text = <<-EOF
    data("vcenter.host.memory.usage").publish(label="The amount of memory the host system is using.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_network_throughput" {
  name = "The amount of data that was transmitted or received over the network by the host."

  program_text = <<-EOF
    data("vcenter.host.network.throughput").publish(label="The amount of data that was transmitted or received over the network by the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_network_usage" {
  name = "The sum of the data transmitted and received for all the NIC instances of the host."

  program_text = <<-EOF
    data("vcenter.host.network.usage").publish(label="The sum of the data transmitted and received for all the NIC instances of the host.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_network_packet_errors" {
  name = "The summation of packet errors on the host network."

  program_text = <<-EOF
    data("vcenter.host.network.packet.errors").publish(label="The summation of packet errors on the host network.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_host_network_packet_count" {
  name = "The number of packets transmitted and received, as measured over the most recent 20s interval."

  program_text = <<-EOF
    data("vcenter.host.network.packet.count").publish(label="The number of packets transmitted and received, as measured over the most recent 20s interval.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_resource_pool_memory_usage" {
  name = "The usage of the memory by the resource pool."

  program_text = <<-EOF
    data("vcenter.resource_pool.memory.usage").publish(label="The usage of the memory by the resource pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_resource_pool_memory_shares" {
  name = "The amount of shares of memory in the resource pool."

  program_text = <<-EOF
    data("vcenter.resource_pool.memory.shares").publish(label="The amount of shares of memory in the resource pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_resource_pool_cpu_usage" {
  name = "The usage of the CPU used by the resource pool."

  program_text = <<-EOF
    data("vcenter.resource_pool.cpu.usage").publish(label="The usage of the CPU used by the resource pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_resource_pool_cpu_shares" {
  name = "The amount of shares of CPU in the resource pool."

  program_text = <<-EOF
    data("vcenter.resource_pool.cpu.shares").publish(label="The amount of shares of CPU in the resource pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_memory_ballooned" {
  name = "The amount of memory that is ballooned due to virtualization."

  program_text = <<-EOF
    data("vcenter.vm.memory.ballooned").publish(label="The amount of memory that is ballooned due to virtualization.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_memory_usage" {
  name = "The amount of memory that is used by the virtual machine."

  program_text = <<-EOF
    data("vcenter.vm.memory.usage").publish(label="The amount of memory that is used by the virtual machine.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_memory_swapped" {
  name = "The portion of memory that is granted to this VM from the host's swap space."

  program_text = <<-EOF
    data("vcenter.vm.memory.swapped").publish(label="The portion of memory that is granted to this VM from the host's swap space.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_memory_swapped_ssd" {
  name = "The amount of memory swapped to fast disk device such as SSD."

  program_text = <<-EOF
    data("vcenter.vm.memory.swapped_ssd").publish(label="The amount of memory swapped to fast disk device such as SSD.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_disk_usage" {
  name = "The amount of storage space used by the virtual machine."

  program_text = <<-EOF
    data("vcenter.vm.disk.usage").publish(label="The amount of storage space used by the virtual machine.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_disk_utilization" {
  name = "The utilization of storage on the virtual machine."

  program_text = <<-EOF
    data("vcenter.vm.disk.utilization").publish(label="The utilization of storage on the virtual machine.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_disk_latency_avg" {
  name = "The latency of operations to the virtual machine's disk."

  program_text = <<-EOF
    data("vcenter.vm.disk.latency.avg").publish(label="The latency of operations to the virtual machine's disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_disk_latency_max" {
  name = "The highest reported total latency (device and kernel times) over an interval of 20 seconds."

  program_text = <<-EOF
    data("vcenter.vm.disk.latency.max").publish(label="The highest reported total latency (device and kernel times) over an interval of 20 seconds.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_disk_throughput" {
  name = "The throughput of the virtual machine's disk."

  program_text = <<-EOF
    data("vcenter.vm.disk.throughput").publish(label="The throughput of the virtual machine's disk.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_network_throughput" {
  name = "The amount of data that was transmitted or received over the network of the virtual machine."

  program_text = <<-EOF
    data("vcenter.vm.network.throughput").publish(label="The amount of data that was transmitted or received over the network of the virtual machine.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_network_packet_count" {
  name = "The amount of packets that was received or transmitted over the instance's network."

  program_text = <<-EOF
    data("vcenter.vm.network.packet.count").publish(label="The amount of packets that was received or transmitted over the instance's network.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_network_usage" {
  name = "The network utilization combined transmit and receive rates during an interval."

  program_text = <<-EOF
    data("vcenter.vm.network.usage").publish(label="The network utilization combined transmit and receive rates during an interval.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_cpu_utilization" {
  name = "The CPU utilization of the VM."

  program_text = <<-EOF
    data("vcenter.vm.cpu.utilization").publish(label="The CPU utilization of the VM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_cpu_usage" {
  name = "The amount of CPU used by the VM."

  program_text = <<-EOF
    data("vcenter.vm.cpu.usage").publish(label="The amount of CPU used by the VM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "vcenter_vm_memory_utilization" {
  name = "The memory utilization of the VM."

  program_text = <<-EOF
    data("vcenter.vm.memory.utilization").publish(label="The memory utilization of the VM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
