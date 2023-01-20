resource "signalfx_detector" "pivotal_cloudfoundry_log_errors" {
  name         = "${var.o11y_prefix} Pivotal cloudFoundry Log errors"
  description  = "Alerts for various Pivotal CloudFoundry Log related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    LOG_ERROR = data('cc.log_count.error').publish(label='LOG_ERROR', enable=False)
    LOG_DEBUG = data('cc.log_count.debug').publish(label='LOG_DEBUG', enable=False)
    LOG_DEBUG2 = data('cc.log_count.debug2').publish(label='LOG_DEBUG2', enable=False)
    LOG_FATAL = data('cc.log_count.fatal').publish(label='LOG_FATAL', enable=False)
    LOG_INFO = data('cc.log_count.info').publish(label='LOG_INFO', enable=False)
    against_recent.detector_mean_std(stream=LOG_ERROR, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity error.')
    against_recent.detector_mean_std(stream=LOG_DEBUG, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug.')
    against_recent.detector_mean_std(stream=LOG_DEBUG2, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug2.')
    against_recent.detector_mean_std(stream=LOG_FATAL, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity fatal.')
    against_recent.detector_mean_std(stream=LOG_INFO, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity info.')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity error."
    severity           = "Minor"
    tip                = "Verify the logs for any application that may cause this"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug."
    severity           = "Warning"
    tip                = "Verify the logs for any application that may cause this"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug2."
    severity           = "Warning"
    tip                = "Verify the logs for any application that may cause this"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity fatal."
    severity           = "Critical"
    tip                = "Verify the logs for any application that may cause this"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity info."
    severity           = "Warning"
    tip                = "Verify the logs for any application that may cause this"
    parameterized_body = var.message_body
  }

}