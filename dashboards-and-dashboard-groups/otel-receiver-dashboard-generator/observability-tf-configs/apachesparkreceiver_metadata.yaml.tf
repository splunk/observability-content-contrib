
resource "signalfx_dashboard" "apachesparkdashboard" {
  name            = "apachespark"
  dashboard_group = signalfx_dashboard_group.apachesparkdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.spark_stage_status.id, signalfx_time_chart.spark_stage_task_active.id, signalfx_time_chart.spark_stage_task_result.id, signalfx_time_chart.spark_stage_executor_run_time.id, signalfx_time_chart.spark_stage_executor_cpu_time.id, signalfx_time_chart.spark_stage_task_result_size.id, signalfx_time_chart.spark_stage_jvm_gc_time.id, signalfx_time_chart.spark_stage_memory_spilled.id, signalfx_time_chart.spark_stage_disk_spilled.id, signalfx_time_chart.spark_stage_memory_peak.id, signalfx_time_chart.spark_stage_io_size.id, signalfx_time_chart.spark_stage_io_records.id, signalfx_time_chart.spark_stage_shuffle_blocks_fetched.id, signalfx_time_chart.spark_stage_shuffle_fetch_wait_time.id, signalfx_time_chart.spark_stage_shuffle_io_disk.id, signalfx_time_chart.spark_stage_shuffle_io_read_size.id, signalfx_time_chart.spark_stage_shuffle_io_write_size.id, signalfx_time_chart.spark_stage_shuffle_io_records.id, signalfx_time_chart.spark_stage_shuffle_write_time.id, signalfx_time_chart.spark_executor_memory_usage.id, signalfx_time_chart.spark_executor_disk_usage.id, signalfx_time_chart.spark_executor_task_limit.id, signalfx_time_chart.spark_executor_task_active.id, signalfx_time_chart.spark_executor_task_result.id, signalfx_time_chart.spark_executor_time.id, signalfx_time_chart.spark_executor_gc_time.id, signalfx_time_chart.spark_executor_input_size.id, signalfx_time_chart.spark_executor_shuffle_io_size.id, signalfx_time_chart.spark_executor_storage_memory_usage.id, signalfx_time_chart.spark_job_task_active.id, signalfx_time_chart.spark_job_task_result.id, signalfx_time_chart.spark_job_stage_active.id, signalfx_time_chart.spark_job_stage_result.id, signalfx_time_chart.spark_driver_block_manager_disk_usage.id, signalfx_time_chart.spark_driver_block_manager_memory_usage.id, signalfx_time_chart.spark_driver_hive_external_catalog_file_cache_hits.id, signalfx_time_chart.spark_driver_hive_external_catalog_files_discovered.id, signalfx_time_chart.spark_driver_hive_external_catalog_hive_client_calls.id, signalfx_time_chart.spark_driver_hive_external_catalog_parallel_listing_jobs.id, signalfx_time_chart.spark_driver_hive_external_catalog_partitions_fetched.id, signalfx_time_chart.spark_driver_code_generator_compilation_count.id, signalfx_time_chart.spark_driver_code_generator_compilation_average_time.id, signalfx_time_chart.spark_driver_code_generator_generated_class_count.id, signalfx_time_chart.spark_driver_code_generator_generated_class_average_size.id, signalfx_time_chart.spark_driver_code_generator_generated_method_count.id, signalfx_time_chart.spark_driver_code_generator_generated_method_average_size.id, signalfx_time_chart.spark_driver_code_generator_source_code_operations.id, signalfx_time_chart.spark_driver_code_generator_source_code_average_size.id, signalfx_time_chart.spark_driver_dag_scheduler_job_active.id, signalfx_time_chart.spark_driver_dag_scheduler_job_count.id, signalfx_time_chart.spark_driver_dag_scheduler_stage_failed.id, signalfx_time_chart.spark_driver_dag_scheduler_stage_count.id, signalfx_time_chart.spark_driver_live_listener_bus_posted.id, signalfx_time_chart.spark_driver_live_listener_bus_processing_time_average.id, signalfx_time_chart.spark_driver_live_listener_bus_dropped.id, signalfx_time_chart.spark_driver_live_listener_bus_queue_size.id, signalfx_time_chart.spark_driver_jvm_cpu_time.id, signalfx_time_chart.spark_driver_executor_memory_jvm.id, signalfx_time_chart.spark_driver_executor_memory_execution.id, signalfx_time_chart.spark_driver_executor_memory_storage.id, signalfx_time_chart.spark_driver_executor_memory_pool.id, signalfx_time_chart.spark_driver_executor_gc_operations.id, signalfx_time_chart.spark_driver_executor_gc_time.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "apachesparkdashboardgroup0" {
  name        = "apachespark generated OTel dashboard group"
  description = "apachespark generated OTel dashboard group"
}

resource "signalfx_time_chart" "spark_stage_status" {
  name = "A one-hot encoding representing the status of this stage."

  program_text = <<-EOF
    data("spark.stage.status").publish(label="A one-hot encoding representing the status of this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_task_active" {
  name = "Number of active tasks in this stage."

  program_text = <<-EOF
    data("spark.stage.task.active").publish(label="Number of active tasks in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_task_result" {
  name = "Number of tasks with a specific result in this stage."

  program_text = <<-EOF
    data("spark.stage.task.result").publish(label="Number of tasks with a specific result in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_executor_run_time" {
  name = "Amount of time spent by the executor in this stage."

  program_text = <<-EOF
    data("spark.stage.executor.run_time").publish(label="Amount of time spent by the executor in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_executor_cpu_time" {
  name = "CPU time spent by the executor in this stage."

  program_text = <<-EOF
    data("spark.stage.executor.cpu_time").publish(label="CPU time spent by the executor in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_task_result_size" {
  name = "The amount of data transmitted back to the driver by all the tasks in this stage."

  program_text = <<-EOF
    data("spark.stage.task.result_size").publish(label="The amount of data transmitted back to the driver by all the tasks in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_jvm_gc_time" {
  name = "The amount of time the JVM spent on garbage collection in this stage."

  program_text = <<-EOF
    data("spark.stage.jvm_gc_time").publish(label="The amount of time the JVM spent on garbage collection in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_memory_spilled" {
  name = "The amount of memory moved to disk due to size constraints (spilled) in this stage."

  program_text = <<-EOF
    data("spark.stage.memory.spilled").publish(label="The amount of memory moved to disk due to size constraints (spilled) in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_disk_spilled" {
  name = "The amount of disk space used for storing portions of overly large data chunks that couldn't fit in memory in this stage."

  program_text = <<-EOF
    data("spark.stage.disk.spilled").publish(label="The amount of disk space used for storing portions of overly large data chunks that couldn't fit in memory in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_memory_peak" {
  name = "Peak memory used by internal data structures created during shuffles, aggregations and joins in this stage."

  program_text = <<-EOF
    data("spark.stage.memory.peak").publish(label="Peak memory used by internal data structures created during shuffles, aggregations and joins in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_io_size" {
  name = "Amount of data written and read at this stage."

  program_text = <<-EOF
    data("spark.stage.io.size").publish(label="Amount of data written and read at this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_io_records" {
  name = "Number of records written and read in this stage."

  program_text = <<-EOF
    data("spark.stage.io.records").publish(label="Number of records written and read in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_blocks_fetched" {
  name = "Number of blocks fetched in shuffle operations in this stage."

  program_text = <<-EOF
    data("spark.stage.shuffle.blocks_fetched").publish(label="Number of blocks fetched in shuffle operations in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_fetch_wait_time" {
  name = "Time spent in this stage waiting for remote shuffle blocks."

  program_text = <<-EOF
    data("spark.stage.shuffle.fetch_wait_time").publish(label="Time spent in this stage waiting for remote shuffle blocks.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_io_disk" {
  name = "Amount of data read to disk in shuffle operations (sometimes required for large blocks, as opposed to the default behavior of reading into memory)."

  program_text = <<-EOF
    data("spark.stage.shuffle.io.disk").publish(label="Amount of data read to disk in shuffle operations (sometimes required for large blocks, as opposed to the default behavior of reading into memory).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_io_read_size" {
  name = "Amount of data read in shuffle operations in this stage."

  program_text = <<-EOF
    data("spark.stage.shuffle.io.read.size").publish(label="Amount of data read in shuffle operations in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_io_write_size" {
  name = "Amount of data written in shuffle operations in this stage."

  program_text = <<-EOF
    data("spark.stage.shuffle.io.write.size").publish(label="Amount of data written in shuffle operations in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_io_records" {
  name = "Number of records written or read in shuffle operations in this stage."

  program_text = <<-EOF
    data("spark.stage.shuffle.io.records").publish(label="Number of records written or read in shuffle operations in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_stage_shuffle_write_time" {
  name = "Time spent blocking on writes to disk or buffer cache in this stage."

  program_text = <<-EOF
    data("spark.stage.shuffle.write_time").publish(label="Time spent blocking on writes to disk or buffer cache in this stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_memory_usage" {
  name = "Storage memory used by this executor."

  program_text = <<-EOF
    data("spark.executor.memory.usage").publish(label="Storage memory used by this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_disk_usage" {
  name = "Disk space used by this executor for RDD storage."

  program_text = <<-EOF
    data("spark.executor.disk.usage").publish(label="Disk space used by this executor for RDD storage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_task_limit" {
  name = "Maximum number of tasks that can run concurrently in this executor."

  program_text = <<-EOF
    data("spark.executor.task.limit").publish(label="Maximum number of tasks that can run concurrently in this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_task_active" {
  name = "Number of tasks currently running in this executor."

  program_text = <<-EOF
    data("spark.executor.task.active").publish(label="Number of tasks currently running in this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_task_result" {
  name = "Number of tasks with a specific result in this executor."

  program_text = <<-EOF
    data("spark.executor.task.result").publish(label="Number of tasks with a specific result in this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_time" {
  name = "Elapsed time the JVM spent executing tasks in this executor."

  program_text = <<-EOF
    data("spark.executor.time").publish(label="Elapsed time the JVM spent executing tasks in this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_gc_time" {
  name = "Elapsed time the JVM spent in garbage collection in this executor."

  program_text = <<-EOF
    data("spark.executor.gc_time").publish(label="Elapsed time the JVM spent in garbage collection in this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_input_size" {
  name = "Amount of data input for this executor."

  program_text = <<-EOF
    data("spark.executor.input_size").publish(label="Amount of data input for this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_shuffle_io_size" {
  name = "Amount of data written and read during shuffle operations for this executor."

  program_text = <<-EOF
    data("spark.executor.shuffle.io.size").publish(label="Amount of data written and read during shuffle operations for this executor.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_executor_storage_memory_usage" {
  name = "The executor's storage memory usage."

  program_text = <<-EOF
    data("spark.executor.storage_memory.usage").publish(label="The executor's storage memory usage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_job_task_active" {
  name = "Number of active tasks in this job."

  program_text = <<-EOF
    data("spark.job.task.active").publish(label="Number of active tasks in this job.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_job_task_result" {
  name = "Number of tasks with a specific result in this job."

  program_text = <<-EOF
    data("spark.job.task.result").publish(label="Number of tasks with a specific result in this job.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_job_stage_active" {
  name = "Number of active stages in this job."

  program_text = <<-EOF
    data("spark.job.stage.active").publish(label="Number of active stages in this job.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_job_stage_result" {
  name = "Number of stages with a specific result in this job."

  program_text = <<-EOF
    data("spark.job.stage.result").publish(label="Number of stages with a specific result in this job.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_block_manager_disk_usage" {
  name = "Disk space used by the BlockManager."

  program_text = <<-EOF
    data("spark.driver.block_manager.disk.usage").publish(label="Disk space used by the BlockManager.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_block_manager_memory_usage" {
  name = "Memory usage for the driver's BlockManager."

  program_text = <<-EOF
    data("spark.driver.block_manager.memory.usage").publish(label="Memory usage for the driver's BlockManager.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_hive_external_catalog_file_cache_hits" {
  name = "Number of file cache hits on the HiveExternalCatalog."

  program_text = <<-EOF
    data("spark.driver.hive_external_catalog.file_cache_hits").publish(label="Number of file cache hits on the HiveExternalCatalog.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_hive_external_catalog_files_discovered" {
  name = "Number of files discovered while listing the partitions of a table in the Hive metastore"

  program_text = <<-EOF
    data("spark.driver.hive_external_catalog.files_discovered").publish(label="Number of files discovered while listing the partitions of a table in the Hive metastore")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_hive_external_catalog_hive_client_calls" {
  name = "Number of calls to the underlying Hive Metastore client made by the Spark application."

  program_text = <<-EOF
    data("spark.driver.hive_external_catalog.hive_client_calls").publish(label="Number of calls to the underlying Hive Metastore client made by the Spark application.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_hive_external_catalog_parallel_listing_jobs" {
  name = "Number of parallel listing jobs initiated by the HiveExternalCatalog when listing partitions of a table."

  program_text = <<-EOF
    data("spark.driver.hive_external_catalog.parallel_listing_jobs").publish(label="Number of parallel listing jobs initiated by the HiveExternalCatalog when listing partitions of a table.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_hive_external_catalog_partitions_fetched" {
  name = "Table partitions fetched by the HiveExternalCatalog."

  program_text = <<-EOF
    data("spark.driver.hive_external_catalog.partitions_fetched").publish(label="Table partitions fetched by the HiveExternalCatalog.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_compilation_count" {
  name = "Number of source code compilation operations performed by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.compilation.count").publish(label="Number of source code compilation operations performed by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_compilation_average_time" {
  name = "Average time spent during CodeGenerator source code compilation operations."

  program_text = <<-EOF
    data("spark.driver.code_generator.compilation.average_time").publish(label="Average time spent during CodeGenerator source code compilation operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_generated_class_count" {
  name = "Number of classes generated by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.generated_class.count").publish(label="Number of classes generated by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_generated_class_average_size" {
  name = "Average class size of the classes generated by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.generated_class.average_size").publish(label="Average class size of the classes generated by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_generated_method_count" {
  name = "Number of methods generated by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.generated_method.count").publish(label="Number of methods generated by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_generated_method_average_size" {
  name = "Average method size of the classes generated by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.generated_method.average_size").publish(label="Average method size of the classes generated by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_source_code_operations" {
  name = "Number of source code generation operations performed by the CodeGenerator."

  program_text = <<-EOF
    data("spark.driver.code_generator.source_code.operations").publish(label="Number of source code generation operations performed by the CodeGenerator.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_code_generator_source_code_average_size" {
  name = "Average size of the source code generated by a CodeGenerator code generation operation."

  program_text = <<-EOF
    data("spark.driver.code_generator.source_code.average_size").publish(label="Average size of the source code generated by a CodeGenerator code generation operation.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_dag_scheduler_job_active" {
  name = "Number of active jobs currently being processed by the DAGScheduler."

  program_text = <<-EOF
    data("spark.driver.dag_scheduler.job.active").publish(label="Number of active jobs currently being processed by the DAGScheduler.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_dag_scheduler_job_count" {
  name = "Number of jobs that have been submitted to the DAGScheduler."

  program_text = <<-EOF
    data("spark.driver.dag_scheduler.job.count").publish(label="Number of jobs that have been submitted to the DAGScheduler.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_dag_scheduler_stage_failed" {
  name = "Number of failed stages run by the DAGScheduler."

  program_text = <<-EOF
    data("spark.driver.dag_scheduler.stage.failed").publish(label="Number of failed stages run by the DAGScheduler.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_dag_scheduler_stage_count" {
  name = "Number of stages the DAGScheduler is either running or needs to run."

  program_text = <<-EOF
    data("spark.driver.dag_scheduler.stage.count").publish(label="Number of stages the DAGScheduler is either running or needs to run.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_live_listener_bus_posted" {
  name = "Number of events that have been posted on the LiveListenerBus."

  program_text = <<-EOF
    data("spark.driver.live_listener_bus.posted").publish(label="Number of events that have been posted on the LiveListenerBus.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_live_listener_bus_processing_time_average" {
  name = "Average time taken for the LiveListenerBus to process an event posted to it."

  program_text = <<-EOF
    data("spark.driver.live_listener_bus.processing_time.average").publish(label="Average time taken for the LiveListenerBus to process an event posted to it.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_live_listener_bus_dropped" {
  name = "Number of events that have been dropped by the LiveListenerBus."

  program_text = <<-EOF
    data("spark.driver.live_listener_bus.dropped").publish(label="Number of events that have been dropped by the LiveListenerBus.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_live_listener_bus_queue_size" {
  name = "Number of events currently waiting to be processed by the LiveListenerBus."

  program_text = <<-EOF
    data("spark.driver.live_listener_bus.queue_size").publish(label="Number of events currently waiting to be processed by the LiveListenerBus.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_jvm_cpu_time" {
  name = "Current CPU time taken by the Spark driver."

  program_text = <<-EOF
    data("spark.driver.jvm_cpu_time").publish(label="Current CPU time taken by the Spark driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_memory_jvm" {
  name = "Amount of memory used by the driver's JVM."

  program_text = <<-EOF
    data("spark.driver.executor.memory.jvm").publish(label="Amount of memory used by the driver's JVM.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_memory_execution" {
  name = "Amount of execution memory currently used by the driver."

  program_text = <<-EOF
    data("spark.driver.executor.memory.execution").publish(label="Amount of execution memory currently used by the driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_memory_storage" {
  name = "Amount of storage memory currently used by the driver."

  program_text = <<-EOF
    data("spark.driver.executor.memory.storage").publish(label="Amount of storage memory currently used by the driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_memory_pool" {
  name = "Amount of pool memory currently used by the driver."

  program_text = <<-EOF
    data("spark.driver.executor.memory.pool").publish(label="Amount of pool memory currently used by the driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_gc_operations" {
  name = "Number of garbage collection operations performed by the driver."

  program_text = <<-EOF
    data("spark.driver.executor.gc.operations").publish(label="Number of garbage collection operations performed by the driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "spark_driver_executor_gc_time" {
  name = "Total elapsed time during garbage collection operations performed by the driver."

  program_text = <<-EOF
    data("spark.driver.executor.gc.time").publish(label="Total elapsed time during garbage collection operations performed by the driver.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
