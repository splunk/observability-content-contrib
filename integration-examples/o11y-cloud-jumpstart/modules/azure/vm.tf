resource "signalfx_detector" "azure_cpu_historical_norm" {
  name         = "${var.o11y_prefix} Azure VM CPU % greater than historical norm"
  description  = "Alerts when CPU usage for this host for the last 10 minutes was significantly higher than normal, as compared to the last 24 hours"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('Percentage CPU', filter=(filter('primary_aggregation_type', 'true'))).publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='24h', fire_num_stddev=3, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('CPU % is significantly greater than normal, and increasing')
  EOF
  rule {
    detect_label       = "CPU % is significantly greater than normal, and increasing"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}