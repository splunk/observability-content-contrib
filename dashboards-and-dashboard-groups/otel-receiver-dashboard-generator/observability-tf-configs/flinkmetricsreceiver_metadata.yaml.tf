
resource "signalfx_dashboard" "flinkmetricsdashboard" {
  name            = "flinkmetrics"
  dashboard_group = signalfx_dashboard_group.flinkmetricsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.flink_jvm_cpu_load.id, signalfx_time_chart.flink_jvm_cpu_time.id, signalfx_time_chart.flink_jvm_memory_heap_used.id, signalfx_time_chart.flink_jvm_memory_heap_committed.id, signalfx_time_chart.flink_jvm_memory_heap_max.id, signalfx_time_chart.flink_jvm_memory_nonheap_used.id, signalfx_time_chart.flink_jvm_memory_nonheap_committed.id, signalfx_time_chart.flink_jvm_memory_nonheap_max.id, signalfx_time_chart.flink_jvm_memory_metaspace_used.id, signalfx_time_chart.flink_jvm_memory_metaspace_committed.id, signalfx_time_chart.flink_jvm_memory_metaspace_max.id, signalfx_time_chart.flink_jvm_memory_direct_used.id, signalfx_time_chart.flink_jvm_memory_direct_total_capacity.id, signalfx_time_chart.flink_jvm_memory_mapped_used.id, signalfx_time_chart.flink_jvm_memory_mapped_total_capacity.id, signalfx_time_chart.flink_memory_managed_used.id, signalfx_time_chart.flink_memory_managed_total.id, signalfx_time_chart.flink_jvm_threads_count.id, signalfx_time_chart.flink_jvm_gc_collections_count.id, signalfx_time_chart.flink_jvm_gc_collections_time.id, signalfx_time_chart.flink_jvm_class_loader_classes_loaded.id, signalfx_time_chart.flink_job_restart_count.id, signalfx_time_chart.flink_job_last_checkpoint_time.id, signalfx_time_chart.flink_job_last_checkpoint_size.id, signalfx_time_chart.flink_job_checkpoint_count.id, signalfx_time_chart.flink_job_checkpoint_in_progress.id, signalfx_time_chart.flink_task_record_count.id, signalfx_time_chart.flink_operator_record_count.id, signalfx_time_chart.flink_operator_watermark_output.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "flinkmetricsdashboardgroup0" {
  name        = "flinkmetrics generated OTel dashboard group"
  description = "flinkmetrics generated OTel dashboard group"
}

resource "signalfx_time_chart" "flink_jvm_cpu_load" {
  name = "The CPU usage of the JVM for a jobmanager or taskmanager."

  program_text = <<-EOF
    data("flink.jvm.cpu.load").publish(label="The CPU usage of the JVM for a jobmanager or taskmanager.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_cpu_time" {
  name = "The CPU time used by the JVM for a jobmanager or taskmanager."

  program_text = <<-EOF
    data("flink.jvm.cpu.time").publish(label="The CPU time used by the JVM for a jobmanager or taskmanager.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_heap_used" {
  name = "The amount of heap memory currently used."

  program_text = <<-EOF
    data("flink.jvm.memory.heap.used").publish(label="The amount of heap memory currently used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_heap_committed" {
  name = "The amount of heap memory guaranteed to be available to the JVM."

  program_text = <<-EOF
    data("flink.jvm.memory.heap.committed").publish(label="The amount of heap memory guaranteed to be available to the JVM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_heap_max" {
  name = "The maximum amount of heap memory that can be used for memory management."

  program_text = <<-EOF
    data("flink.jvm.memory.heap.max").publish(label="The maximum amount of heap memory that can be used for memory management.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_nonheap_used" {
  name = "The amount of non-heap memory currently used."

  program_text = <<-EOF
    data("flink.jvm.memory.nonheap.used").publish(label="The amount of non-heap memory currently used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_nonheap_committed" {
  name = "The amount of non-heap memory guaranteed to be available to the JVM."

  program_text = <<-EOF
    data("flink.jvm.memory.nonheap.committed").publish(label="The amount of non-heap memory guaranteed to be available to the JVM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_nonheap_max" {
  name = "The maximum amount of non-heap memory that can be used for memory management."

  program_text = <<-EOF
    data("flink.jvm.memory.nonheap.max").publish(label="The maximum amount of non-heap memory that can be used for memory management.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_metaspace_used" {
  name = "The amount of memory currently used in the Metaspace memory pool."

  program_text = <<-EOF
    data("flink.jvm.memory.metaspace.used").publish(label="The amount of memory currently used in the Metaspace memory pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_metaspace_committed" {
  name = "The amount of memory guaranteed to be available to the JVM in the Metaspace memory pool."

  program_text = <<-EOF
    data("flink.jvm.memory.metaspace.committed").publish(label="The amount of memory guaranteed to be available to the JVM in the Metaspace memory pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_metaspace_max" {
  name = "The maximum amount of memory that can be used in the Metaspace memory pool."

  program_text = <<-EOF
    data("flink.jvm.memory.metaspace.max").publish(label="The maximum amount of memory that can be used in the Metaspace memory pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_direct_used" {
  name = "The amount of memory used by the JVM for the direct buffer pool."

  program_text = <<-EOF
    data("flink.jvm.memory.direct.used").publish(label="The amount of memory used by the JVM for the direct buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_direct_total_capacity" {
  name = "The total capacity of all buffers in the direct buffer pool."

  program_text = <<-EOF
    data("flink.jvm.memory.direct.total_capacity").publish(label="The total capacity of all buffers in the direct buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_mapped_used" {
  name = "The amount of memory used by the JVM for the mapped buffer pool."

  program_text = <<-EOF
    data("flink.jvm.memory.mapped.used").publish(label="The amount of memory used by the JVM for the mapped buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_memory_mapped_total_capacity" {
  name = "The number of buffers in the mapped buffer pool."

  program_text = <<-EOF
    data("flink.jvm.memory.mapped.total_capacity").publish(label="The number of buffers in the mapped buffer pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_memory_managed_used" {
  name = "The amount of managed memory currently used."

  program_text = <<-EOF
    data("flink.memory.managed.used").publish(label="The amount of managed memory currently used.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_memory_managed_total" {
  name = "The total amount of managed memory."

  program_text = <<-EOF
    data("flink.memory.managed.total").publish(label="The total amount of managed memory.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_threads_count" {
  name = "The total number of live threads."

  program_text = <<-EOF
    data("flink.jvm.threads.count").publish(label="The total number of live threads.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_gc_collections_count" {
  name = "The total number of collections that have occurred."

  program_text = <<-EOF
    data("flink.jvm.gc.collections.count").publish(label="The total number of collections that have occurred.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_gc_collections_time" {
  name = "The total time spent performing garbage collection."

  program_text = <<-EOF
    data("flink.jvm.gc.collections.time").publish(label="The total time spent performing garbage collection.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_jvm_class_loader_classes_loaded" {
  name = "The total number of classes loaded since the start of the JVM."

  program_text = <<-EOF
    data("flink.jvm.class_loader.classes_loaded").publish(label="The total number of classes loaded since the start of the JVM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_job_restart_count" {
  name = "The total number of restarts since this job was submitted, including full restarts and fine-grained restarts."

  program_text = <<-EOF
    data("flink.job.restart.count").publish(label="The total number of restarts since this job was submitted, including full restarts and fine-grained restarts.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_job_last_checkpoint_time" {
  name = "The end to end duration of the last checkpoint."

  program_text = <<-EOF
    data("flink.job.last_checkpoint.time").publish(label="The end to end duration of the last checkpoint.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_job_last_checkpoint_size" {
  name = "The total size of the last checkpoint."

  program_text = <<-EOF
    data("flink.job.last_checkpoint.size").publish(label="The total size of the last checkpoint.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_job_checkpoint_count" {
  name = "The number of checkpoints completed or failed."

  program_text = <<-EOF
    data("flink.job.checkpoint.count").publish(label="The number of checkpoints completed or failed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_job_checkpoint_in_progress" {
  name = "The number of checkpoints in progress."

  program_text = <<-EOF
    data("flink.job.checkpoint.in_progress").publish(label="The number of checkpoints in progress.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_task_record_count" {
  name = "The number of records a task has."

  program_text = <<-EOF
    data("flink.task.record.count").publish(label="The number of records a task has.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_operator_record_count" {
  name = "The number of records an operator has."

  program_text = <<-EOF
    data("flink.operator.record.count").publish(label="The number of records an operator has.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "flink_operator_watermark_output" {
  name = "The last watermark this operator has emitted."

  program_text = <<-EOF
    data("flink.operator.watermark.output").publish(label="The last watermark this operator has emitted.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
