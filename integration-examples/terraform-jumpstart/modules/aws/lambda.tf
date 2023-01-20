resource "signalfx_detector" "lambda_errors" {
  name         = "${var.o11y_prefix} AWS/Lambda Errors"
  description  = "AWS/Lambda Function Error Rates"
  program_text = <<-EOF
    function_errors = data('Errors', filter=(filter('namespace', 'AWS/Lambda') and filter('FunctionName', '*') and filter('Resource', '*') and filter('stat', 'sum'))).publish(label='function_errors', enable=False)
    detect((when(function_errors > 10, lasting='5m'))).publish('AWS/Lambda function error rate is greater than 10 for the last 5m')
    from signalfx.detectors.against_periods import against_periods
    hist_duration_errors = data('Duration', filter=filter('namespace', 'AWS/Lambda')).mean().publish(label='hist_duration_errors', enable=False)
    against_periods.detector_mean_std(stream=hist_duration_errors, window_to_compare='15m', space_between_windows='60m', num_windows=4, fire_num_stddev=3, clear_num_stddev=2, discard_historical_outliers=True, orientation='above').publish('AWS/Lambda Lambda duration has been greater then historical norm during the past 15 minutes')
    from signalfx.detectors.against_periods import against_periods
    cold_start_errors = data('function.cold_starts',filter=filter('namespace', 'AWS/Lambda')).publish(label='cold_start_errors', enable=False)
    against_periods.detector_mean_std(stream=cold_start_errors, window_to_compare='10m', space_between_windows='24h', num_windows=4, fire_num_stddev=3, clear_num_stddev=2.5, discard_historical_outliers=True, orientation='above').publish('AWS/Lambda Wrapper coldstart count has been greater then historical norm during the past 10 minutes')
  EOF
  rule {
    detect_label       = "AWS/Lambda function error rate is greater than 10 for the last 5m"
    severity           = "Major"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "AWS/Lambda Lambda duration has been greater then historical norm during the past 15 minutes"
    severity           = "Minor"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "AWS/Lambda Wrapper coldstart count has been greater then historical norm during the past 10 minutes"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}