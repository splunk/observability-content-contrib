
resource "signalfx_dashboard" "splunkenterprisedashboard" {
  name            = "splunkenterprise"
  dashboard_group = signalfx_dashboard_group.splunkenterprisedashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.splunk_license_index_usage.id, signalfx_time_chart.splunk_indexer_throughput.id, signalfx_time_chart.splunk_data_indexes_extended_total_size.id, signalfx_time_chart.splunk_data_indexes_extended_event_count.id, signalfx_time_chart.splunk_data_indexes_extended_bucket_count.id, signalfx_time_chart.splunk_data_indexes_extended_raw_size.id, signalfx_time_chart.splunk_data_indexes_extended_bucket_event_count.id, signalfx_time_chart.splunk_data_indexes_extended_bucket_hot_count.id, signalfx_time_chart.splunk_data_indexes_extended_bucket_warm_count.id, signalfx_time_chart.splunk_server_introspection_queues_current.id, signalfx_time_chart.splunk_server_introspection_queues_current_bytes.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "splunkenterprisedashboardgroup0" {
  name        = "splunkenterprise generated OTel dashboard group"
  description = "splunkenterprise generated OTel dashboard group"
}

resource "signalfx_time_chart" "splunk_license_index_usage" {
  name = "Gauge tracking the indexed license usage per index"

  program_text = <<-EOF
    data("splunk.license.index.usage").publish(label="Gauge tracking the indexed license usage per index")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_indexer_throughput" {
  name = "Gauge tracking average bytes per second throughput of indexer"

  program_text = <<-EOF
    data("splunk.indexer.throughput").publish(label="Gauge tracking average bytes per second throughput of indexer")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_total_size" {
  name = "Size in bytes on disk of this index"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.total.size").publish(label="Size in bytes on disk of this index")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_event_count" {
  name = "Count of events for index, excluding frozen events. Approximately equal to the event_count sum of all buckets."

  program_text = <<-EOF
    data("splunk.data.indexes.extended.event.count").publish(label="Count of events for index, excluding frozen events. Approximately equal to the event_count sum of all buckets.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_bucket_count" {
  name = "Count of buckets per index"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.bucket.count").publish(label="Count of buckets per index")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_raw_size" {
  name = "Size in bytes on disk of the <bucket>/rawdata/ directories of all buckets in this index, excluding frozen"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.raw.size").publish(label="Size in bytes on disk of the <bucket>/rawdata/ directories of all buckets in this index, excluding frozen")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_bucket_event_count" {
  name = "Count of events in this bucket super-directory"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.bucket.event.count").publish(label="Count of events in this bucket super-directory")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_bucket_hot_count" {
  name = "(If size > 0) Number of hot buckets"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.bucket.hot.count").publish(label="(If size > 0) Number of hot buckets")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_data_indexes_extended_bucket_warm_count" {
  name = "(If size > 0) Number of warm buckets"

  program_text = <<-EOF
    data("splunk.data.indexes.extended.bucket.warm.count").publish(label="(If size > 0) Number of warm buckets")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_server_introspection_queues_current" {
  name = "Gauge tracking current length of queue"

  program_text = <<-EOF
    data("splunk.server.introspection.queues.current").publish(label="Gauge tracking current length of queue")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "splunk_server_introspection_queues_current_bytes" {
  name = "Gauge tracking current bytes waiting in queue"

  program_text = <<-EOF
    data("splunk.server.introspection.queues.current.bytes").publish(label="Gauge tracking current bytes waiting in queue")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
