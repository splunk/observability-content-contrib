
resource "signalfx_dashboard" "expvardashboard" {
  name            = "expvar"
  dashboard_group = signalfx_dashboard_group.expvardashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.process_runtime_memstats_total_alloc.id, signalfx_time_chart.process_runtime_memstats_sys.id, signalfx_time_chart.process_runtime_memstats_lookups.id, signalfx_time_chart.process_runtime_memstats_mallocs.id, signalfx_time_chart.process_runtime_memstats_frees.id, signalfx_time_chart.process_runtime_memstats_heap_alloc.id, signalfx_time_chart.process_runtime_memstats_heap_sys.id, signalfx_time_chart.process_runtime_memstats_heap_idle.id, signalfx_time_chart.process_runtime_memstats_heap_inuse.id, signalfx_time_chart.process_runtime_memstats_heap_released.id, signalfx_time_chart.process_runtime_memstats_heap_objects.id, signalfx_time_chart.process_runtime_memstats_stack_inuse.id, signalfx_time_chart.process_runtime_memstats_stack_sys.id, signalfx_time_chart.process_runtime_memstats_mspan_inuse.id, signalfx_time_chart.process_runtime_memstats_mspan_sys.id, signalfx_time_chart.process_runtime_memstats_mcache_inuse.id, signalfx_time_chart.process_runtime_memstats_mcache_sys.id, signalfx_time_chart.process_runtime_memstats_buck_hash_sys.id, signalfx_time_chart.process_runtime_memstats_gc_sys.id, signalfx_time_chart.process_runtime_memstats_other_sys.id, signalfx_time_chart.process_runtime_memstats_next_gc.id, signalfx_time_chart.process_runtime_memstats_pause_total.id, signalfx_time_chart.process_runtime_memstats_last_pause.id, signalfx_time_chart.process_runtime_memstats_num_gc.id, signalfx_time_chart.process_runtime_memstats_num_forced_gc.id, signalfx_time_chart.process_runtime_memstats_gc_cpu_fraction.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "expvardashboardgroup0" {
  name        = "expvar generated OTel dashboard group"
  description = "expvar generated OTel dashboard group"
}

resource "signalfx_time_chart" "process_runtime_memstats_total_alloc" {
  name = "Cumulative bytes allocated for heap objects."

  program_text = <<-EOF
    data("process.runtime.memstats.total_alloc").publish(label="Cumulative bytes allocated for heap objects.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_sys" {
  name = "Total bytes of memory obtained from the OS."

  program_text = <<-EOF
    data("process.runtime.memstats.sys").publish(label="Total bytes of memory obtained from the OS.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_lookups" {
  name = "Number of pointer lookups performed by the runtime."

  program_text = <<-EOF
    data("process.runtime.memstats.lookups").publish(label="Number of pointer lookups performed by the runtime.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_mallocs" {
  name = "Cumulative count of heap objects allocated."

  program_text = <<-EOF
    data("process.runtime.memstats.mallocs").publish(label="Cumulative count of heap objects allocated.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_frees" {
  name = "Cumulative count of heap objects freed."

  program_text = <<-EOF
    data("process.runtime.memstats.frees").publish(label="Cumulative count of heap objects freed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_alloc" {
  name = "Bytes of allocated heap objects."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_alloc").publish(label="Bytes of allocated heap objects.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_sys" {
  name = "Bytes of heap memory obtained by the OS."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_sys").publish(label="Bytes of heap memory obtained by the OS.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_idle" {
  name = "Bytes in idle (unused) spans."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_idle").publish(label="Bytes in idle (unused) spans.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_inuse" {
  name = "Bytes in in-use spans."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_inuse").publish(label="Bytes in in-use spans.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_released" {
  name = "Bytes of physical memory returned to the OS."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_released").publish(label="Bytes of physical memory returned to the OS.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_heap_objects" {
  name = "Number of allocated heap objects."

  program_text = <<-EOF
    data("process.runtime.memstats.heap_objects").publish(label="Number of allocated heap objects.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_stack_inuse" {
  name = "Bytes in stack spans."

  program_text = <<-EOF
    data("process.runtime.memstats.stack_inuse").publish(label="Bytes in stack spans.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_stack_sys" {
  name = "Bytes of stack memory obtained from the OS."

  program_text = <<-EOF
    data("process.runtime.memstats.stack_sys").publish(label="Bytes of stack memory obtained from the OS.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_mspan_inuse" {
  name = "Bytes of allocated mspan structures."

  program_text = <<-EOF
    data("process.runtime.memstats.mspan_inuse").publish(label="Bytes of allocated mspan structures.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_mspan_sys" {
  name = "Bytes of memory obtained from the OS for mspan structures."

  program_text = <<-EOF
    data("process.runtime.memstats.mspan_sys").publish(label="Bytes of memory obtained from the OS for mspan structures.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_mcache_inuse" {
  name = "Bytes of allocated mcache structures."

  program_text = <<-EOF
    data("process.runtime.memstats.mcache_inuse").publish(label="Bytes of allocated mcache structures.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_mcache_sys" {
  name = "Bytes of memory obtained from the OS for mcache structures."

  program_text = <<-EOF
    data("process.runtime.memstats.mcache_sys").publish(label="Bytes of memory obtained from the OS for mcache structures.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_buck_hash_sys" {
  name = "Bytes of memory in profiling bucket hash tables."

  program_text = <<-EOF
    data("process.runtime.memstats.buck_hash_sys").publish(label="Bytes of memory in profiling bucket hash tables.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_gc_sys" {
  name = "Bytes of memory in garbage collection metadata."

  program_text = <<-EOF
    data("process.runtime.memstats.gc_sys").publish(label="Bytes of memory in garbage collection metadata.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_other_sys" {
  name = "Bytes of memory in miscellaneous off-heap runtime allocations."

  program_text = <<-EOF
    data("process.runtime.memstats.other_sys").publish(label="Bytes of memory in miscellaneous off-heap runtime allocations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_next_gc" {
  name = "The target heap size of the next GC cycle."

  program_text = <<-EOF
    data("process.runtime.memstats.next_gc").publish(label="The target heap size of the next GC cycle.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_pause_total" {
  name = "The cumulative nanoseconds in GC stop-the-world pauses since the program started."

  program_text = <<-EOF
    data("process.runtime.memstats.pause_total").publish(label="The cumulative nanoseconds in GC stop-the-world pauses since the program started.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_last_pause" {
  name = "The most recent stop-the-world pause time."

  program_text = <<-EOF
    data("process.runtime.memstats.last_pause").publish(label="The most recent stop-the-world pause time.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_num_gc" {
  name = "Number of completed GC cycles."

  program_text = <<-EOF
    data("process.runtime.memstats.num_gc").publish(label="Number of completed GC cycles.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_num_forced_gc" {
  name = "Number of GC cycles that were forced by the application calling the GC function."

  program_text = <<-EOF
    data("process.runtime.memstats.num_forced_gc").publish(label="Number of GC cycles that were forced by the application calling the GC function.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "process_runtime_memstats_gc_cpu_fraction" {
  name = "The fraction of this program's available CPU time used by the GC since the program started."

  program_text = <<-EOF
    data("process.runtime.memstats.gc_cpu_fraction").publish(label="The fraction of this program's available CPU time used by the GC since the program started.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
