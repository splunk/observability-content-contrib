
resource "signalfx_dashboard" "rabbitmqdashboard" {
  name            = "rabbitmq"
  dashboard_group = signalfx_dashboard_group.rabbitmqdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.rabbitmq_consumer_count.id, signalfx_time_chart.rabbitmq_message_delivered.id, signalfx_time_chart.rabbitmq_message_published.id, signalfx_time_chart.rabbitmq_message_acknowledged.id, signalfx_time_chart.rabbitmq_message_dropped.id, signalfx_time_chart.rabbitmq_message_current.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "rabbitmqdashboardgroup0" {
  name        = "rabbitmq generated OTel dashboard group"
  description = "rabbitmq generated OTel dashboard group"
}

resource "signalfx_time_chart" "rabbitmq_consumer_count" {
  name = "The number of consumers currently reading from the queue."

  program_text = <<-EOF
    data("rabbitmq.consumer.count").publish(label="The number of consumers currently reading from the queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "rabbitmq_message_delivered" {
  name = "The number of messages delivered to consumers."

  program_text = <<-EOF
    data("rabbitmq.message.delivered").publish(label="The number of messages delivered to consumers.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "rabbitmq_message_published" {
  name = "The number of messages published to a queue."

  program_text = <<-EOF
    data("rabbitmq.message.published").publish(label="The number of messages published to a queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "rabbitmq_message_acknowledged" {
  name = "The number of messages acknowledged by consumers."

  program_text = <<-EOF
    data("rabbitmq.message.acknowledged").publish(label="The number of messages acknowledged by consumers.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "rabbitmq_message_dropped" {
  name = "The number of messages dropped as unroutable."

  program_text = <<-EOF
    data("rabbitmq.message.dropped").publish(label="The number of messages dropped as unroutable.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "rabbitmq_message_current" {
  name = "The total number of messages currently in the queue."

  program_text = <<-EOF
    data("rabbitmq.message.current").publish(label="The total number of messages currently in the queue.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
