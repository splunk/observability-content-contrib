
resource "signalfx_dashboard" "kafkametricsdashboard" {
  name            = "kafkametrics"
  dashboard_group = signalfx_dashboard_group.kafkametricsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.kafka_brokers.id, signalfx_time_chart.kafka_topic_partitions.id, signalfx_time_chart.kafka_partition_current_offset.id, signalfx_time_chart.kafka_partition_oldest_offset.id, signalfx_time_chart.kafka_partition_replicas.id, signalfx_time_chart.kafka_partition_replicas_in_sync.id, signalfx_time_chart.kafka_consumer_group_members.id, signalfx_time_chart.kafka_consumer_group_offset.id, signalfx_time_chart.kafka_consumer_group_offset_sum.id, signalfx_time_chart.kafka_consumer_group_lag.id, signalfx_time_chart.kafka_consumer_group_lag_sum.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "kafkametricsdashboardgroup0" {
  name        = "kafkametrics generated OTel dashboard group"
  description = "kafkametrics generated OTel dashboard group"
}

resource "signalfx_time_chart" "kafka_brokers" {
  name = "Number of brokers in the cluster."

  program_text = <<-EOF
    data("kafka.brokers").publish(label="Number of brokers in the cluster.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_topic_partitions" {
  name = "Number of partitions in topic."

  program_text = <<-EOF
    data("kafka.topic.partitions").publish(label="Number of partitions in topic.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_partition_current_offset" {
  name = "Current offset of partition of topic."

  program_text = <<-EOF
    data("kafka.partition.current_offset").publish(label="Current offset of partition of topic.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_partition_oldest_offset" {
  name = "Oldest offset of partition of topic"

  program_text = <<-EOF
    data("kafka.partition.oldest_offset").publish(label="Oldest offset of partition of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_partition_replicas" {
  name = "Number of replicas for partition of topic"

  program_text = <<-EOF
    data("kafka.partition.replicas").publish(label="Number of replicas for partition of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_partition_replicas_in_sync" {
  name = "Number of synchronized replicas of partition"

  program_text = <<-EOF
    data("kafka.partition.replicas_in_sync").publish(label="Number of synchronized replicas of partition")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_consumer_group_members" {
  name = "Count of members in the consumer group"

  program_text = <<-EOF
    data("kafka.consumer_group.members").publish(label="Count of members in the consumer group")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_consumer_group_offset" {
  name = "Current offset of the consumer group at partition of topic"

  program_text = <<-EOF
    data("kafka.consumer_group.offset").publish(label="Current offset of the consumer group at partition of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_consumer_group_offset_sum" {
  name = "Sum of consumer group offset across partitions of topic"

  program_text = <<-EOF
    data("kafka.consumer_group.offset_sum").publish(label="Sum of consumer group offset across partitions of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_consumer_group_lag" {
  name = "Current approximate lag of consumer group at partition of topic"

  program_text = <<-EOF
    data("kafka.consumer_group.lag").publish(label="Current approximate lag of consumer group at partition of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "kafka_consumer_group_lag_sum" {
  name = "Current approximate sum of consumer group lag across all partitions of topic"

  program_text = <<-EOF
    data("kafka.consumer_group.lag_sum").publish(label="Current approximate sum of consumer group lag across all partitions of topic")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
