resource "signalfx_detector" "kafka_under_replicated_partitions" {
  name         = "${var.alert_prefix} Kafka - Under Replicated Partitions"
  description  = "Alerts when at least one kafka partition is under replicated for atleast 5m"
  program_text = <<-EOF
    A = data('gauge.kafka-underreplicated-partitions').publish(label='A')
    detect(when(A > threshold(0), lasting='5m')).publish('At least one Kafka partition is under-replicated')
  EOF
  rule {
    detect_label       = "At least one Kafka partition is under-replicated"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "kafka_no_active_controller" {
  name         = "${var.alert_prefix} Kafka - No Active Controller"
  description  = "Alerts when there are no active controllers in a cluster, there is only 1 broker set as an active controller per cluster"
  program_text = <<-EOF
    A = data('gauge.kafka-active-controllers').min(by=['cluster']).publish(label='A')
    detect(when(A < threshold(1))).publish('There is no active Kafka controller in this cluster')
  EOF
  rule {
    detect_label       = "There is no active Kafka controller in this cluster"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "kafka_high-log-flush-time" {
  name         = "${var.alert_prefix} Kafka - Max Log Flush Time > 100ms"
  description  = "Alerts when the log flush time for brokers in a cluster exceeds 100ms"
  program_text = <<-EOF
    A = data('gauge.kafka-log-flush-time-ms-p95').max(by=['cluster']).publish(label='A')
    detect(when(A > threshold(100))).publish('Log Flush Time P95 > 100ms for a cluster')
  EOF
  rule {
    detect_label       = "Log Flush Time P95 > 100ms for a cluster"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "kafka_offline_partitions" {
  name         = "${var.alert_prefix} Kafka - Offline partitions"
  description  = "Alerts when there is no active leader for a partition, the partition cannot be read from or written to"
  program_text = <<-EOF
    A = data('gauge.kafka-offline-partitions').max(by=['cluster', 'host']).publish(label='A')
    detect(when(A > threshold(0))).publish('Offline partitions > 0 on a broker')
  EOF
  rule {
    detect_label       = "Offline partitions > 0 on a broker"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "kafka_consumergroup_lag" {
  name         = "${var.alert_prefix} Kafka - Consumer Lag > 100 for 1m"
  description  = "Alerts when a consumergroup is lagging behind the latest offset by a 100"
  program_text = <<-EOF
    A = data('kafka_consumergroup_lag').sum(by=['host', 'topic', 'partition', 'consumergroup']).publish(label='A')
    detect(when(A > threshold(100), lasting='1m')).publish('consumergroup is lagging for this partition')
  EOF
  rule {
    detect_label       = "consumergroup is lagging for this partition"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

