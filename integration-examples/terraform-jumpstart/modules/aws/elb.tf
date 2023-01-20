resource "signalfx_detector" "httpcode_elb_5xx" {
  name        = "${var.o11y_prefix} AWS/ELB has high 5XX response ratio"
  description = "Alerts when 10% of requests were 5XX for last 5m"

  program_text = <<-EOF
    A = data('HTTPCode_ELB_5XX', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='HTTPCode_ELB_5XX', enable=False)
    B = data('RequestCount', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='RequestCount', enable=False)
    detect(when(((A/B)*100) >= 10, lasting='5m')).publish('AWS/ELB 10% of requests were 5XX for last 5m')    
  EOF

  rule {
    detect_label       = "AWS/ELB 10% of requests were 5XX for last 5m"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "surgequeuelength_elb" {
  name        = "${var.o11y_prefix} AWS/ELB has high Surge Queue Length (>= 90%)"
  description = "Alerts when Surge Queue Length is >= 90%"

  program_text = <<-EOF
    A = data('SurgeQueueLength', filter=filter('stat', 'upper') and (not filter('AvailabilityZone', '*'))).publish(label='A')
    detect(when((A/1024)*100 >= 90, lasting='5m')).publish('AWS/ELB SurgeQueueLength is close to capacity')    
  EOF

  rule {
    detect_label       = "AWS/ELB SurgeQueueLength is close to capacity"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "spillover_elb" {
  name        = "${var.o11y_prefix} AWS/ELB has spillover"
  description = "Alerts when ELB Spillover is detected (generates 503 for users)"

  program_text = <<-EOF
    A = data('SpilloverCount', filter=filter('stat', 'sum') and filter('namespace', 'AWS/ELB') and (not filter('AvailabilityZone', '*'))).publish(label='A')
    detect(when(A > 0)).publish('AWS/ELB Spillover detected')    
  EOF

  rule {
    detect_label       = "AWS/ELB Spillover detected"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}
