
resource "signalfx_dashboard" "elasticsearchdashboard" {
  name            = "elasticsearch"
  dashboard_group = signalfx_dashboard_group.elasticsearchdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.elasticsearch_breaker_memory_estimated.id, signalfx_time_chart.elasticsearch_breaker_memory_limit.id, signalfx_time_chart.elasticsearch_breaker_tripped.id, signalfx_time_chart.elasticsearch_node_cache_memory_usage.id, signalfx_time_chart.elasticsearch_node_cache_evictions.id, signalfx_time_chart.elasticsearch_node_cache_count.id, signalfx_time_chart.elasticsearch_node_cache_size.id, signalfx_time_chart.elasticsearch_node_fs_disk_available.id, signalfx_time_chart.elasticsearch_node_fs_disk_free.id, signalfx_time_chart.elasticsearch_node_fs_disk_total.id, signalfx_time_chart.elasticsearch_node_disk_io_read.id, signalfx_time_chart.elasticsearch_node_disk_io_write.id, signalfx_time_chart.elasticsearch_node_cluster_io.id, signalfx_time_chart.elasticsearch_node_cluster_connections.id, signalfx_time_chart.elasticsearch_node_http_connections.id, signalfx_time_chart.elasticsearch_node_operations_current.id, signalfx_time_chart.elasticsearch_node_operations_completed.id, signalfx_time_chart.elasticsearch_node_operations_time.id, signalfx_time_chart.elasticsearch_node_operations_get_completed.id, signalfx_time_chart.elasticsearch_node_operations_get_time.id, signalfx_time_chart.elasticsearch_node_shards_size.id, signalfx_time_chart.elasticsearch_node_shards_data_set_size.id, signalfx_time_chart.elasticsearch_node_shards_reserved_size.id, signalfx_time_chart.elasticsearch_node_translog_operations.id, signalfx_time_chart.elasticsearch_node_translog_size.id, signalfx_time_chart.elasticsearch_node_translog_uncommitted_size.id, signalfx_time_chart.elasticsearch_node_thread_pool_threads.id, signalfx_time_chart.elasticsearch_node_thread_pool_tasks_queued.id, signalfx_time_chart.elasticsearch_node_thread_pool_tasks_finished.id, signalfx_time_chart.elasticsearch_node_documents.id, signalfx_time_chart.elasticsearch_node_open_files.id, signalfx_time_chart.jvm_classes_loaded.id, signalfx_time_chart.jvm_gc_collections_count.id, signalfx_time_chart.jvm_gc_collections_elapsed.id, signalfx_time_chart.jvm_memory_heap_max.id, signalfx_time_chart.jvm_memory_heap_used.id, signalfx_time_chart.jvm_memory_heap_utilization.id, signalfx_time_chart.jvm_memory_heap_committed.id, signalfx_time_chart.jvm_memory_nonheap_used.id, signalfx_time_chart.jvm_memory_nonheap_committed.id, signalfx_time_chart.jvm_memory_pool_max.id, signalfx_time_chart.jvm_memory_pool_used.id, signalfx_time_chart.jvm_threads_count.id, signalfx_time_chart.elasticsearch_cluster_pending_tasks.id, signalfx_time_chart.elasticsearch_cluster_in_flight_fetch.id, signalfx_time_chart.elasticsearch_cluster_shards.id, signalfx_time_chart.elasticsearch_cluster_data_nodes.id, signalfx_time_chart.elasticsearch_cluster_nodes.id, signalfx_time_chart.elasticsearch_cluster_health.id, signalfx_time_chart.elasticsearch_os_cpu_usage.id, signalfx_time_chart.elasticsearch_os_cpu_load_avg_1m.id, signalfx_time_chart.elasticsearch_os_cpu_load_avg_5m.id, signalfx_time_chart.elasticsearch_os_cpu_load_avg_15m.id, signalfx_time_chart.elasticsearch_os_memory.id, signalfx_time_chart.elasticsearch_memory_indexing_pressure.id, signalfx_time_chart.elasticsearch_indexing_pressure_memory_total_primary_rejections.id, signalfx_time_chart.elasticsearch_indexing_pressure_memory_total_replica_rejections.id, signalfx_time_chart.elasticsearch_indexing_pressure_memory_limit.id, signalfx_time_chart.elasticsearch_cluster_state_queue.id, signalfx_time_chart.elasticsearch_cluster_published_states_full.id, signalfx_time_chart.elasticsearch_cluster_published_states_differences.id, signalfx_time_chart.elasticsearch_cluster_state_update_count.id, signalfx_time_chart.elasticsearch_cluster_state_update_time.id, signalfx_time_chart.elasticsearch_cluster_indices_cache_evictions.id, signalfx_time_chart.elasticsearch_node_ingest_documents.id, signalfx_time_chart.elasticsearch_node_ingest_documents_current.id, signalfx_time_chart.elasticsearch_node_ingest_operations_failed.id, signalfx_time_chart.elasticsearch_node_pipeline_ingest_documents_preprocessed.id, signalfx_time_chart.elasticsearch_node_pipeline_ingest_operations_failed.id, signalfx_time_chart.elasticsearch_node_pipeline_ingest_documents_current.id, signalfx_time_chart.elasticsearch_node_script_compilations.id, signalfx_time_chart.elasticsearch_node_script_cache_evictions.id, signalfx_time_chart.elasticsearch_node_script_compilation_limit_triggered.id, signalfx_time_chart.elasticsearch_node_segments_memory.id, signalfx_time_chart.elasticsearch_index_operations_completed.id, signalfx_time_chart.elasticsearch_index_operations_time.id, signalfx_time_chart.elasticsearch_index_shards_size.id, signalfx_time_chart.elasticsearch_index_operations_merge_size.id, signalfx_time_chart.elasticsearch_index_operations_merge_docs_count.id, signalfx_time_chart.elasticsearch_index_segments_count.id, signalfx_time_chart.elasticsearch_index_segments_size.id, signalfx_time_chart.elasticsearch_index_segments_memory.id, signalfx_time_chart.elasticsearch_index_translog_operations.id, signalfx_time_chart.elasticsearch_index_translog_size.id, signalfx_time_chart.elasticsearch_index_cache_memory_usage.id, signalfx_time_chart.elasticsearch_index_cache_size.id, signalfx_time_chart.elasticsearch_index_cache_evictions.id, signalfx_time_chart.elasticsearch_index_documents.id, signalfx_time_chart.elasticsearch_process_cpu_usage.id, signalfx_time_chart.elasticsearch_process_cpu_time.id, signalfx_time_chart.elasticsearch_process_memory_virtual.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "elasticsearchdashboardgroup0" {
  name        = "elasticsearch generated OTel dashboard group"
  description = "elasticsearch generated OTel dashboard group"
}

resource "signalfx_time_chart" "elasticsearch_breaker_memory_estimated" {
  name = "Estimated memory used for the operation."

  program_text = <<-EOF
    data("elasticsearch.breaker.memory.estimated").publish(label="Estimated memory used for the operation.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_breaker_memory_limit" {
  name = "Memory limit for the circuit breaker."

  program_text = <<-EOF
    data("elasticsearch.breaker.memory.limit").publish(label="Memory limit for the circuit breaker.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_breaker_tripped" {
  name = "Total number of times the circuit breaker has been triggered and prevented an out of memory error."

  program_text = <<-EOF
    data("elasticsearch.breaker.tripped").publish(label="Total number of times the circuit breaker has been triggered and prevented an out of memory error.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cache_memory_usage" {
  name = "The size in bytes of the cache on a node."

  program_text = <<-EOF
    data("elasticsearch.node.cache.memory.usage").publish(label="The size in bytes of the cache on a node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cache_evictions" {
  name = "The number of evictions from the cache on a node."

  program_text = <<-EOF
    data("elasticsearch.node.cache.evictions").publish(label="The number of evictions from the cache on a node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cache_count" {
  name = "Total count of query cache misses across all shards assigned to selected nodes."

  program_text = <<-EOF
    data("elasticsearch.node.cache.count").publish(label="Total count of query cache misses across all shards assigned to selected nodes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cache_size" {
  name = "Total amount of memory used for the query cache across all shards assigned to the node."

  program_text = <<-EOF
    data("elasticsearch.node.cache.size").publish(label="Total amount of memory used for the query cache across all shards assigned to the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_fs_disk_available" {
  name = "The amount of disk space available to the JVM across all file stores for this node. Depending on OS or process level restrictions, this might appear less than free. This is the actual amount of free disk space the Elasticsearch node can utilise."

  program_text = <<-EOF
    data("elasticsearch.node.fs.disk.available").publish(label="The amount of disk space available to the JVM across all file stores for this node. Depending on OS or process level restrictions, this might appear less than free. This is the actual amount of free disk space the Elasticsearch node can utilise.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_fs_disk_free" {
  name = "The amount of unallocated disk space across all file stores for this node."

  program_text = <<-EOF
    data("elasticsearch.node.fs.disk.free").publish(label="The amount of unallocated disk space across all file stores for this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_fs_disk_total" {
  name = "The amount of disk space across all file stores for this node."

  program_text = <<-EOF
    data("elasticsearch.node.fs.disk.total").publish(label="The amount of disk space across all file stores for this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_disk_io_read" {
  name = "The total number of kilobytes read across all file stores for this node."

  program_text = <<-EOF
    data("elasticsearch.node.disk.io.read").publish(label="The total number of kilobytes read across all file stores for this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_disk_io_write" {
  name = "The total number of kilobytes written across all file stores for this node."

  program_text = <<-EOF
    data("elasticsearch.node.disk.io.write").publish(label="The total number of kilobytes written across all file stores for this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cluster_io" {
  name = "The number of bytes sent and received on the network for internal cluster communication."

  program_text = <<-EOF
    data("elasticsearch.node.cluster.io").publish(label="The number of bytes sent and received on the network for internal cluster communication.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_cluster_connections" {
  name = "The number of open tcp connections for internal cluster communication."

  program_text = <<-EOF
    data("elasticsearch.node.cluster.connections").publish(label="The number of open tcp connections for internal cluster communication.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_http_connections" {
  name = "The number of HTTP connections to the node."

  program_text = <<-EOF
    data("elasticsearch.node.http.connections").publish(label="The number of HTTP connections to the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_operations_current" {
  name = "Number of query operations currently running."

  program_text = <<-EOF
    data("elasticsearch.node.operations.current").publish(label="Number of query operations currently running.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_operations_completed" {
  name = "The number of operations completed by a node."

  program_text = <<-EOF
    data("elasticsearch.node.operations.completed").publish(label="The number of operations completed by a node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_operations_time" {
  name = "Time spent on operations by a node."

  program_text = <<-EOF
    data("elasticsearch.node.operations.time").publish(label="Time spent on operations by a node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_operations_get_completed" {
  name = "The number of hits and misses resulting from GET operations."

  program_text = <<-EOF
    data("elasticsearch.node.operations.get.completed").publish(label="The number of hits and misses resulting from GET operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_operations_get_time" {
  name = "The time spent on hits and misses resulting from GET operations."

  program_text = <<-EOF
    data("elasticsearch.node.operations.get.time").publish(label="The time spent on hits and misses resulting from GET operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_shards_size" {
  name = "The size of the shards assigned to this node."

  program_text = <<-EOF
    data("elasticsearch.node.shards.size").publish(label="The size of the shards assigned to this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_shards_data_set_size" {
  name = "Total data set size of all shards assigned to the node. This includes the size of shards not stored fully on the node, such as the cache for partially mounted indices."

  program_text = <<-EOF
    data("elasticsearch.node.shards.data_set.size").publish(label="Total data set size of all shards assigned to the node. This includes the size of shards not stored fully on the node, such as the cache for partially mounted indices.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_shards_reserved_size" {
  name = "A prediction of how much larger the shard stores on this node will eventually grow due to ongoing peer recoveries, restoring snapshots, and similar activities. A value of -1 indicates that this is not available."

  program_text = <<-EOF
    data("elasticsearch.node.shards.reserved.size").publish(label="A prediction of how much larger the shard stores on this node will eventually grow due to ongoing peer recoveries, restoring snapshots, and similar activities. A value of -1 indicates that this is not available.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_translog_operations" {
  name = "Number of transaction log operations."

  program_text = <<-EOF
    data("elasticsearch.node.translog.operations").publish(label="Number of transaction log operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_translog_size" {
  name = "Size of the transaction log."

  program_text = <<-EOF
    data("elasticsearch.node.translog.size").publish(label="Size of the transaction log.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_translog_uncommitted_size" {
  name = "Size of uncommitted transaction log operations."

  program_text = <<-EOF
    data("elasticsearch.node.translog.uncommitted.size").publish(label="Size of uncommitted transaction log operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_thread_pool_threads" {
  name = "The number of threads in the thread pool."

  program_text = <<-EOF
    data("elasticsearch.node.thread_pool.threads").publish(label="The number of threads in the thread pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_thread_pool_tasks_queued" {
  name = "The number of queued tasks in the thread pool."

  program_text = <<-EOF
    data("elasticsearch.node.thread_pool.tasks.queued").publish(label="The number of queued tasks in the thread pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_thread_pool_tasks_finished" {
  name = "The number of tasks finished by the thread pool."

  program_text = <<-EOF
    data("elasticsearch.node.thread_pool.tasks.finished").publish(label="The number of tasks finished by the thread pool.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_documents" {
  name = "The number of documents on the node."

  program_text = <<-EOF
    data("elasticsearch.node.documents").publish(label="The number of documents on the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_open_files" {
  name = "The number of open file descriptors held by the node."

  program_text = <<-EOF
    data("elasticsearch.node.open_files").publish(label="The number of open file descriptors held by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_classes_loaded" {
  name = "The number of loaded classes"

  program_text = <<-EOF
    data("jvm.classes.loaded").publish(label="The number of loaded classes")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_gc_collections_count" {
  name = "The total number of garbage collections that have occurred"

  program_text = <<-EOF
    data("jvm.gc.collections.count").publish(label="The total number of garbage collections that have occurred")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_gc_collections_elapsed" {
  name = "The approximate accumulated collection elapsed time"

  program_text = <<-EOF
    data("jvm.gc.collections.elapsed").publish(label="The approximate accumulated collection elapsed time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_heap_max" {
  name = "The maximum amount of memory can be used for the heap"

  program_text = <<-EOF
    data("jvm.memory.heap.max").publish(label="The maximum amount of memory can be used for the heap")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_heap_used" {
  name = "The current heap memory usage"

  program_text = <<-EOF
    data("jvm.memory.heap.used").publish(label="The current heap memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_heap_utilization" {
  name = "Fraction of heap memory usage"

  program_text = <<-EOF
    data("jvm.memory.heap.utilization").publish(label="Fraction of heap memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_heap_committed" {
  name = "The amount of memory that is guaranteed to be available for the heap"

  program_text = <<-EOF
    data("jvm.memory.heap.committed").publish(label="The amount of memory that is guaranteed to be available for the heap")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_nonheap_used" {
  name = "The current non-heap memory usage"

  program_text = <<-EOF
    data("jvm.memory.nonheap.used").publish(label="The current non-heap memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_nonheap_committed" {
  name = "The amount of memory that is guaranteed to be available for non-heap purposes"

  program_text = <<-EOF
    data("jvm.memory.nonheap.committed").publish(label="The amount of memory that is guaranteed to be available for non-heap purposes")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_pool_max" {
  name = "The maximum amount of memory can be used for the memory pool"

  program_text = <<-EOF
    data("jvm.memory.pool.max").publish(label="The maximum amount of memory can be used for the memory pool")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_memory_pool_used" {
  name = "The current memory pool memory usage"

  program_text = <<-EOF
    data("jvm.memory.pool.used").publish(label="The current memory pool memory usage")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "jvm_threads_count" {
  name = "The current number of threads"

  program_text = <<-EOF
    data("jvm.threads.count").publish(label="The current number of threads")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_pending_tasks" {
  name = "The number of cluster-level changes that have not yet been executed."

  program_text = <<-EOF
    data("elasticsearch.cluster.pending_tasks").publish(label="The number of cluster-level changes that have not yet been executed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_in_flight_fetch" {
  name = "The number of unfinished fetches."

  program_text = <<-EOF
    data("elasticsearch.cluster.in_flight_fetch").publish(label="The number of unfinished fetches.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_shards" {
  name = "The number of shards in the cluster."

  program_text = <<-EOF
    data("elasticsearch.cluster.shards").publish(label="The number of shards in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_data_nodes" {
  name = "The number of data nodes in the cluster."

  program_text = <<-EOF
    data("elasticsearch.cluster.data_nodes").publish(label="The number of data nodes in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_nodes" {
  name = "The total number of nodes in the cluster."

  program_text = <<-EOF
    data("elasticsearch.cluster.nodes").publish(label="The total number of nodes in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_health" {
  name = "The health status of the cluster."

  program_text = <<-EOF
    data("elasticsearch.cluster.health").publish(label="The health status of the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_os_cpu_usage" {
  name = "Recent CPU usage for the whole system, or -1 if not supported."

  program_text = <<-EOF
    data("elasticsearch.os.cpu.usage").publish(label="Recent CPU usage for the whole system, or -1 if not supported.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_os_cpu_load_avg_1m" {
  name = "One-minute load average on the system (field is not present if one-minute load average is not available)."

  program_text = <<-EOF
    data("elasticsearch.os.cpu.load_avg.1m").publish(label="One-minute load average on the system (field is not present if one-minute load average is not available).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_os_cpu_load_avg_5m" {
  name = "Five-minute load average on the system (field is not present if five-minute load average is not available)."

  program_text = <<-EOF
    data("elasticsearch.os.cpu.load_avg.5m").publish(label="Five-minute load average on the system (field is not present if five-minute load average is not available).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_os_cpu_load_avg_15m" {
  name = "Fifteen-minute load average on the system (field is not present if fifteen-minute load average is not available)."

  program_text = <<-EOF
    data("elasticsearch.os.cpu.load_avg.15m").publish(label="Fifteen-minute load average on the system (field is not present if fifteen-minute load average is not available).")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_os_memory" {
  name = "Amount of physical memory."

  program_text = <<-EOF
    data("elasticsearch.os.memory").publish(label="Amount of physical memory.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_memory_indexing_pressure" {
  name = "Memory consumed, in bytes, by indexing requests in the specified stage."

  program_text = <<-EOF
    data("elasticsearch.memory.indexing_pressure").publish(label="Memory consumed, in bytes, by indexing requests in the specified stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_indexing_pressure_memory_total_primary_rejections" {
  name = "Cumulative number of indexing requests rejected in the primary stage."

  program_text = <<-EOF
    data("elasticsearch.indexing_pressure.memory.total.primary_rejections").publish(label="Cumulative number of indexing requests rejected in the primary stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_indexing_pressure_memory_total_replica_rejections" {
  name = "Number of indexing requests rejected in the replica stage."

  program_text = <<-EOF
    data("elasticsearch.indexing_pressure.memory.total.replica_rejections").publish(label="Number of indexing requests rejected in the replica stage.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_indexing_pressure_memory_limit" {
  name = "Configured memory limit, in bytes, for the indexing requests."

  program_text = <<-EOF
    data("elasticsearch.indexing_pressure.memory.limit").publish(label="Configured memory limit, in bytes, for the indexing requests.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_state_queue" {
  name = "Number of cluster states in queue."

  program_text = <<-EOF
    data("elasticsearch.cluster.state_queue").publish(label="Number of cluster states in queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_published_states_full" {
  name = "Number of published cluster states."

  program_text = <<-EOF
    data("elasticsearch.cluster.published_states.full").publish(label="Number of published cluster states.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_published_states_differences" {
  name = "Number of differences between published cluster states."

  program_text = <<-EOF
    data("elasticsearch.cluster.published_states.differences").publish(label="Number of differences between published cluster states.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_state_update_count" {
  name = "The number of cluster state update attempts that changed the cluster state since the node started."

  program_text = <<-EOF
    data("elasticsearch.cluster.state_update.count").publish(label="The number of cluster state update attempts that changed the cluster state since the node started.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_state_update_time" {
  name = "The cumulative amount of time updating the cluster state since the node started."

  program_text = <<-EOF
    data("elasticsearch.cluster.state_update.time").publish(label="The cumulative amount of time updating the cluster state since the node started.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_cluster_indices_cache_evictions" {
  name = "The number of evictions from the cache for indices in cluster."

  program_text = <<-EOF
    data("elasticsearch.cluster.indices.cache.evictions").publish(label="The number of evictions from the cache for indices in cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_ingest_documents" {
  name = "Total number of documents ingested during the lifetime of this node."

  program_text = <<-EOF
    data("elasticsearch.node.ingest.documents").publish(label="Total number of documents ingested during the lifetime of this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_ingest_documents_current" {
  name = "Total number of documents currently being ingested."

  program_text = <<-EOF
    data("elasticsearch.node.ingest.documents.current").publish(label="Total number of documents currently being ingested.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_ingest_operations_failed" {
  name = "Total number of failed ingest operations during the lifetime of this node."

  program_text = <<-EOF
    data("elasticsearch.node.ingest.operations.failed").publish(label="Total number of failed ingest operations during the lifetime of this node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_pipeline_ingest_documents_preprocessed" {
  name = "Number of documents preprocessed by the ingest pipeline."

  program_text = <<-EOF
    data("elasticsearch.node.pipeline.ingest.documents.preprocessed").publish(label="Number of documents preprocessed by the ingest pipeline.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_pipeline_ingest_operations_failed" {
  name = "Total number of failed operations for the ingest pipeline."

  program_text = <<-EOF
    data("elasticsearch.node.pipeline.ingest.operations.failed").publish(label="Total number of failed operations for the ingest pipeline.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_pipeline_ingest_documents_current" {
  name = "Total number of documents currently being ingested by a pipeline."

  program_text = <<-EOF
    data("elasticsearch.node.pipeline.ingest.documents.current").publish(label="Total number of documents currently being ingested by a pipeline.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_script_compilations" {
  name = "Total number of inline script compilations performed by the node."

  program_text = <<-EOF
    data("elasticsearch.node.script.compilations").publish(label="Total number of inline script compilations performed by the node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_script_cache_evictions" {
  name = "Total number of times the script cache has evicted old data."

  program_text = <<-EOF
    data("elasticsearch.node.script.cache_evictions").publish(label="Total number of times the script cache has evicted old data.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_script_compilation_limit_triggered" {
  name = "Total number of times the script compilation circuit breaker has limited inline script compilations."

  program_text = <<-EOF
    data("elasticsearch.node.script.compilation_limit_triggered").publish(label="Total number of times the script compilation circuit breaker has limited inline script compilations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_node_segments_memory" {
  name = "Size of memory for segment object of a node."

  program_text = <<-EOF
    data("elasticsearch.node.segments.memory").publish(label="Size of memory for segment object of a node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_operations_completed" {
  name = "The number of operations completed for an index."

  program_text = <<-EOF
    data("elasticsearch.index.operations.completed").publish(label="The number of operations completed for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_operations_time" {
  name = "Time spent on operations for an index."

  program_text = <<-EOF
    data("elasticsearch.index.operations.time").publish(label="Time spent on operations for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_shards_size" {
  name = "The size of the shards assigned to this index."

  program_text = <<-EOF
    data("elasticsearch.index.shards.size").publish(label="The size of the shards assigned to this index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_operations_merge_size" {
  name = "The total size of merged segments for an index."

  program_text = <<-EOF
    data("elasticsearch.index.operations.merge.size").publish(label="The total size of merged segments for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_operations_merge_docs_count" {
  name = "The total number of documents in merge operations for an index."

  program_text = <<-EOF
    data("elasticsearch.index.operations.merge.docs_count").publish(label="The total number of documents in merge operations for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_segments_count" {
  name = "Number of segments of an index."

  program_text = <<-EOF
    data("elasticsearch.index.segments.count").publish(label="Number of segments of an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_segments_size" {
  name = "Size of segments of an index."

  program_text = <<-EOF
    data("elasticsearch.index.segments.size").publish(label="Size of segments of an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_segments_memory" {
  name = "Size of memory for segment object of an index."

  program_text = <<-EOF
    data("elasticsearch.index.segments.memory").publish(label="Size of memory for segment object of an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_translog_operations" {
  name = "Number of transaction log operations for an index."

  program_text = <<-EOF
    data("elasticsearch.index.translog.operations").publish(label="Number of transaction log operations for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_translog_size" {
  name = "Size of the transaction log for an index."

  program_text = <<-EOF
    data("elasticsearch.index.translog.size").publish(label="Size of the transaction log for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_cache_memory_usage" {
  name = "The size in bytes of the cache for an index."

  program_text = <<-EOF
    data("elasticsearch.index.cache.memory.usage").publish(label="The size in bytes of the cache for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_cache_size" {
  name = "The number of elements of the query cache for an index."

  program_text = <<-EOF
    data("elasticsearch.index.cache.size").publish(label="The number of elements of the query cache for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_cache_evictions" {
  name = "The number of evictions from the cache for an index."

  program_text = <<-EOF
    data("elasticsearch.index.cache.evictions").publish(label="The number of evictions from the cache for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_index_documents" {
  name = "The number of documents for an index."

  program_text = <<-EOF
    data("elasticsearch.index.documents").publish(label="The number of documents for an index.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_process_cpu_usage" {
  name = "CPU usage in percent."

  program_text = <<-EOF
    data("elasticsearch.process.cpu.usage").publish(label="CPU usage in percent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_process_cpu_time" {
  name = "CPU time used by the process on which the Java virtual machine is running."

  program_text = <<-EOF
    data("elasticsearch.process.cpu.time").publish(label="CPU time used by the process on which the Java virtual machine is running.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "elasticsearch_process_memory_virtual" {
  name = "Size of virtual memory that is guaranteed to be available to the running process."

  program_text = <<-EOF
    data("elasticsearch.process.memory.virtual").publish(label="Size of virtual memory that is guaranteed to be available to the running process.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
