resource "signalfx_detector" "mem_historical_norm" {
  name         = "${var.alert_prefix} Mem utilization % greater than historical norm"
  description  = "Alerts when Mem usage for this host for the last 30 minutes was significantly higher than normal, as compared to the last 24 hours"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('memory.utilization').publish(label='A', enable=True)
    against_recent.detector_mean_std(stream=A, current_window='30m', historical_window='24h', fire_num_stddev=3, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Memory utilization is significantly greater than normal, and increasing')
  EOF
  rule {
    detect_label       = "Memory utilization is significantly greater than normal, and increasing"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "mem_historical_cyclical_norm" {
  name         = "${var.alert_prefix} Memory utilization % greater than 3.5 std dev compared to the same time window over the last 3 days"
  description  = "Alerts when Memory usage for this host for the last 30 minutes was significantly higher than normal, as compared to the last 24 hours"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('memory.utilization').publish(label='A', enable=True)
    against_periods.detector_mean_std(stream=A, window_to_compare='30m', space_between_windows='24h', num_windows=3, fire_num_stddev=3.5, clear_num_stddev=2, discard_historical_outliers=True, orientation='above').publish('Memory Utilization is greater than normal for the same time window compared to the last 3 days')
  EOF
  rule {
    detect_label       = "Memory Utilization is greater than normal for the same time window compared to the last 3 days"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}
