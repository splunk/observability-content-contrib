resource "signalfx_detector" "pivotal_cloudfoundry_gorouter_errors" {
  name         = "${var.o11y_prefix} Pivotal cloudFoundry gorouter errors"
  description  = "Alerts for various Pivotal CloudFoundry gorouter related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    total_requests = data('gorouter.total_requests', filter=filter('metric_source', 'cloudfoundry'), rollup='average').delta().mean(over='5m').publish(label='total_requests', enable=True)
    latency = data('gorouter.latency', filter=filter('metric_source', 'cloudfoundry'), rollup='average').mean(over='30m').publish(label='latency', enable=True)
    detect((when(total_requests >= 0.5) and (total_requests < 1))).publish('Pivotal Cloudfoundry - The number of Tasks that the auctioneer failed to place on Diego cellis between .5 and 1.')
    detect(when(total_requests >=1)).publish('Pivotal Cloudfoundry - The number of Tasks that the auctioneer failed to place on Diego cell is greater or equal to 1.')
    detect(when(latency > 100)).publish('Pivotal Cloudfoundry - gorouter latency above 100 ms')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - The number of Tasks that the auctioneer failed to place on Diego cellis between .5 and 1."
    severity           = "Minor"
    tip                = "To increase throughput and maintain low latency, scale the Gorouters either horizontally or vertically and watch that the system.cpu.user metric for the Gorouter stays in the suggested range of 60-70% CPU Utilization."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - The number of Tasks that the auctioneer failed to place on Diego cell is greater or equal to 1."
    severity           = "Critical"
    tip                = "To increase throughput and maintain low latency, scale the Gorouters either horizontally or vertically and watch that the system.cpu.user metric for the Gorouter stays in the suggested range of 60-70% CPU Utilization."
    parameterized_body = var.message_body
  }

  rule {
    detect_label       = "Pivotal Cloudfoundry - gorouter latency above 100 ms"
    severity           = "Warning"
    tip                = "First inspect logs for network issues and indications of misbehaving backends./nIf it appears that the Gorouter needs to scale due to ongoing traffic congestion, do not scale on the latency metric alone. You should also look at the CPU utilization of the Gorouter VMs and keep it within a maximum 60-70% range./nResolve high utilization by scaling the Gorouter."
    parameterized_body = var.message_body
  }

}