resource "signalfx_detector" "pivotal_cloudfoundry_DREM_errors" {
  name         = "${var.o11y_prefix} Pivotal CloudFoundry Diego Route Emitter Metrics errors"
  description  = "Alerts for various Pivotal CloudFoundry Route Emitter Metrics related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    from signalfx.detectors.not_reporting import not_reporting
    from signalfx.detectors.countdown import countdown
    TMP1 = data('route_emitter.RouteEmitterSyncDuration', filter=filter('metric_source', 'cloudfoundry'), rollup='max').max(over='15m').publish(label='TMP1', enable=False)
    RouteEmitterSyncDuration = (TMP1/1000000000).publish(label='C', enable=False)
    detect(when((RouteEmitterSyncDuration >= 5) and (RouteEmitterSyncDuration < 10))).publish('Pivotal Cloudfoundry - RouteEmitterSyncDuration between 5 and 10 seconds.')
    detect(when(RouteEmitterSyncDuration >= 10)).publish('Pivotal Cloudfoundry - RouteEmitterSyncDuration greater or eaqual to 10 seconds.')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - RouteEmitterSyncDuration between 5 and 10 seconds."
    severity           = "Minor"
    tip                = "If all or many jobs showing as impacted, there is likely an issue with Diego.\n 1 - Investigate the Route Emitter and Diego BBS logs for errors.\n2 - Verify that app routes are functional by making a request to an app, pushing an app and pinging it, or if applicable, checking that your smoke tests have passed.\nIf one or a few jobs showing as impacted, there is likely a connectivity issue and the impacted job should be investigated further."
    parameterized_body = var.message_body
  }

  rule {
    detect_label       = "Pivotal Cloudfoundry - RouteEmitterSyncDuration greater or eaqual to 10 seconds."
    severity           = "Minor"
    tip                = "If all or many jobs showing as impacted, there is likely an issue with Diego.\n 1 - Investigate the Route Emitter and Diego BBS logs for errors.\n2 - Verify that app routes are functional by making a request to an app, pushing an app and pinging it, or if applicable, checking that your smoke tests have passed.\nIf one or a few jobs showing as impacted, there is likely a connectivity issue and the impacted job should be investigated further."
    parameterized_body = var.message_body
  }

}