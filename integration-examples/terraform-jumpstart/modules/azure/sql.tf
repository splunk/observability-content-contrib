resource "signalfx_detector" "azure_SQL_errors" {
  name         = "${var.o11y_prefix} Various Azure SQL Errors"
  description  = "Alerts when for various scenarios for Azure SQL both Database or elasticpools"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases')).mean_plus_stddev(stddevs=1, over='10m').publish(label='A', enable=False)
    B = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools')).mean_plus_stddev(stddevs=1, over='10m').publish(label='B', enable=False)
    C = data('dtu_consumption_percent', filter=filter('resource_type', 'Microsoft.Sql/servers')).mean(over='10m').publish(label='C', enable=False)
    D = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases')).stddev(over='5m').publish(label='D', enable=False)
    E = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools')).stddev(over='5m').publish(label='E', enable=False)
    F = data('physical_data_read_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases')).stddev(over='5m').publish(label='F', enable=False)
    G = data('physical_data_read_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools')).stddev(over='5m').publish(label='G', enable=False)
    against_periods.detector_mean_std(stream=A, window_to_compare='10m', space_between_windows='3h', num_windows=4, fire_num_stddev=4, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('Azure SQL database CPU % is significantly greater than the last 3 hours')
    against_periods.detector_mean_std(stream=B, window_to_compare='10m', space_between_windows='3h', num_windows=4, fire_num_stddev=4, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('Azure SQL elasticpools CPU % is significantly greater than the last 3 hours')
    detect(when(C > 80)).publish('Azure SQL DTU Consumption is greater than 80% over the past 10 minutes')
    detect((when(D > 99)) or (when(E > 99))).publish('Azure SQL CPU % has been at 100% for the past 5 minutes')
    detect((when(F > 95)) or (when(G > 95))).publish('Azure SQL physical data read above 95%')
  EOF
  rule {
    detect_label       = "Azure SQL elasticpools CPU % is significantly greater than the last 3 hours"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Azure SQL DTU Consumption is greater than 80% over the past 10 minutes"
    severity           = "Minor"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Azure SQL CPU % has been at 100% for the past 5 minutes"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Azure SQL physical data read above 95%"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Azure SQL database CPU % is significantly greater than the last 3 hours"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}
