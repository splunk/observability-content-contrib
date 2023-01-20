resource "signalfx_detector" "pivotal_cloudfoundry_system_errors" {
  name         = "${var.o11y_prefix} Pivotal cloudFoundry system errors"
  description  = "Alerts for various Pivotal CloudFoundry system related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    system_healthy = data('system.healthy', filter=filter('metric_source', 'cloudfoundry'), rollup='average').mean(over='5m').publish(label='system_healthy', enable=False)
    detect(when(system_healthy > 1)).publish('Pivotal Cloudfoundry - The value of system.healthy - Mean(5m) is above 1.')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - The value of system.healthy - Mean(5m) is above 1."
    severity           = "Minor"
    tip                = "Investigate CF logs for the unhealthy component(s)."
    parameterized_body = var.message_body
  }
}