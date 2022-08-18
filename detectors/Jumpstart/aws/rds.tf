resource "signalfx_detector" "rds_free_space" {
  name         = "${var.sfx_prefix} AWS/RDS Free Space Running Out"
  description  = "RDS free disk space is expected to be below 20% in 12 hours"
  program_text = <<-EOF
    from signalfx.detectors.countdown import countdown
    free = data('FreeStorageSpace', filter=(filter('namespace', 'AWS/RDS') and filter('DBInstanceIdentifier', '*') and filter('stat', 'mean'))).publish(label='free', enable=False)
    countdown.hours_left_stream_detector(stream=free, minimum_value=20, lower_threshold=12, fire_lasting=lasting('6m', 0.9), clear_threshold=84, clear_lasting=lasting('6m', 0.9), use_double_ewma=False).publish('AWS/RDS free disk space is expected to be below 20% in 12 hours')
  EOF
  rule {
    detect_label       = "AWS/RDS free disk space is expected to be below 20% in 12 hours"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}
resource "signalfx_detector" "rds_DiskQueueDepth_historical_error" {
  name         = "${var.sfx_prefix} AWS/RDS rds_DiskQueueDepth for the last 10 minutes where significantly higher than normal, as compared to the mean from the last 2 days"
  description  = "Alerts when the number of outstanding IOs (read/write requests) in AWS/RD was significantly higher than normal for 10 minutes, as compared to the last 12 hours"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('DiskQueueDepth', filter=filter('DBInstanceIdentifier', '*') and filter('namespace', 'AWS/RDS') and filter('stat', 'mean')).publish(label='A')
    against_periods.detector_mean_std(stream=A, window_to_compare='30m', space_between_windows='12h', num_windows=4, fire_num_stddev=3, clear_num_stddev=1, discard_historical_outliers=True, orientation='above').publish('Disk Queue Depth higher than normal')
  EOF
  rule {
    detect_label       = "Disk Queue Depth higher than normal"
    severity           = "Minor"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_CPU_high_error" {
  name         = "${var.sfx_prefix} AWS/RDS CPUUtilization for the last 10 minutes was above 95%"
  description  = "Alerts when the cpu usage for AWS/RD was above 95% for ten minutes"
  program_text = <<-EOF
    A = data('CPUUtilization', filter=filter('namespace', 'AWS/RDS')).mean_plus_stddev(stddevs=1, over='10m').publish(label='A', enable=False)
    detect(when(A > 95)).publish('AWS/RDS CPU usage has been over 95% for the past 10 minutes')
  EOF
  rule {
    detect_label       = "AWS/RDS CPU usage has been over 95% for the past 10 minutes"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_cpu_historical_norm" {
  name         = "${var.sfx_prefix} AWS/RDS CPU % has been significantly higher for the past 10 minutes then the historical norm"
  description  = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('CPUUtilization', filter=filter('namespace', 'AWS/RDS')).mean().publish(label='A', enable=False)
    against_periods.detector_mean_std(stream=A, window_to_compare='10m', space_between_windows='24h', num_windows=4, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('AWS RDS CPU has been significantly higher for the past 10 minutes then the historical norm')
  EOF
  rule {
    detect_label       = "AWS RDS CPU has been significantly higher for the past 10 minutes then the historical norm"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_deadlocks" {
  name         = "${var.sfx_prefix} AWS/RDS deadlocks exceeding 0.02 per second"
  description  = "Alerts when the average number of deadlocks in the RDS database exceeds 0.02 deadlocks/s for 5 minutes"
  program_text = <<-EOF
    Deadlocks = data('Deadlocks', filter=filter('namespace', 'AWS/RDS')).publish(label='Deadlocks', enable=False)
    detect(when(Deadlocks > 0.02, lasting='5m')).publish('AWS/RDS there are more that 0.02 deadlocks/s for 5 minutes')
  EOF
  rule {
    detect_label       = "AWS/RDS there are more that 0.02 deadlocks/s for 5 minutes"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_read_latency" {
  name         = "${var.sfx_prefix} AWS/RDS Read Latency "
  description  = "Alerts when AWS/RDS read latency is greater than normal compared to the last 2 days"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('ReadLatency', filter=filter('DBInstanceIdentifier', '*') and filter('namespace', 'AWS/RDS') and filter('stat', 'mean')).publish(label='A')
    against_periods.detector_mean_std(stream=A, window_to_compare='30m', space_between_windows='12h', num_windows=4, fire_num_stddev=3, clear_num_stddev=1, discard_historical_outliers=True, orientation='above').publish('Read Latency higher than normal')
  EOF
  rule {
    detect_label       = "Read Latency higher than normal"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_write_latency" {
  name         = "${var.sfx_prefix} AWS/RDS Write Latency "
  description  = "Alerts when AWS/RDS write latency is greater than normal compared to the last 2 days"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    A = data('WriteLatency', filter=filter('DBInstanceIdentifier', '*') and filter('namespace', 'AWS/RDS') and filter('stat', 'mean')).publish(label='A')
    against_periods.detector_mean_std(stream=A, window_to_compare='30m', space_between_windows='12h', num_windows=4, fire_num_stddev=3, clear_num_stddev=1, discard_historical_outliers=True, orientation='above').publish('Write Latency higher than normal')
  EOF
  rule {
    detect_label       = "Write Latency higher than normal"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "rds_free_memory" {
  name         = "${var.sfx_prefix} AWS/RDS Free Memory Running Out"
  description  = "Alerts when the amount of available memory, in bytes < 200MB for 1h and the amount of swap space used on the RDS DB instance in bytes  > 50MB for 1 h"
  program_text = <<-EOF
    FreeableMemory = data('FreeableMemory', filter=filter('namespace', 'AWS/RDS') and filter('stat', 'lower')).publish(label='FreeableMemory', enable=False)
    SwapUsage = data('SwapUsage', filter=filter('namespace', 'AWS/RDS') and filter('stat', 'upper')).publish(label='SwapUsage', enable=False)
    detect((when(FreeableMemory < 209715200, lasting='1h') and when(SwapUsage > 52428800, lasting='1h'))).publish('AWS/RDS free memory is below 200MB and swap space above 50MB for 1h')
  EOF
  rule {
    detect_label       = "AWS/RDS free memory is below 200MB and swap space above 50MB for 1h"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}
