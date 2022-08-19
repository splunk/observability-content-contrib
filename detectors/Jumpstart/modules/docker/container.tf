resource "signalfx_detector" "container_cpu_utilization" {
  name         = "${var.alert_prefix} Container CPU utilization % high"
  description  = "Alerts when CPU Utilization % is between 70% & 80% for 10mins and > 80% for 5mins"
  program_text = <<-EOF
    A = data('cpu.usage.total', filter=filter('plugin', 'docker')).publish(label='A', enable=False)
    B = data('cpu.usage.system', filter=filter('plugin', 'docker')).publish(label='B', enable=False)
    C = (A/B*100).publish(label='Container CPU')
    detect(when(C > 80, lasting='5m')).publish('Container CPU utilization % is above 80 for 5m')
    detect(when(not (C > 80) and not (C < 70), lasting='10m')).publish('Container CPU utilization % is within 70 and 80 for 10m')
  EOF
  rule {
    detect_label       = "Container CPU utilization % is within 70 and 80 for 10m"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Container CPU utilization % is above 80 for 5m"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}