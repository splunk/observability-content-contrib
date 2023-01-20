resource "signalfx_detector" "pivotal_cloudfoundry_DCM_errors" {
  name         = "${var.o11y_prefix} Pivotal CloudFoundry Diego Cell Metrics errors"
  description  = "Alerts for various Pivotal CloudFoundry Diego Cell Metrics related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    from signalfx.detectors.not_reporting import not_reporting
    from signalfx.detectors.countdown import countdown
    A = data('rep.CapacityRemainingDisk', filter=filter('metric_source', 'cloudfoundry'), rollup='min').mean().publish(label='CapacityRemainingDisk', enable=True)
    CapacityRemainingDisk = (A/1000).mean(over='5m').publish(label='B', enable=True)
    CPM = data('rep.CapacityRemainingMemory', filter=filter('metric_source', 'cloudfoundry'), rollup='min').mean().publish(label='CPM', enable=True)
    CapacityRemainingMemory = (CPM/1024).publish(label='B', enable=True)
    B = data('rep.RepBulkSyncDuration', filter=filter('metric_source', 'cloudfoundry'), rollup='max').mean().publish(label='B', enable=True)
    RepBulkSyncDuration = (B/1000000000).mean(over='5m').publish(label='RepBulkSyncDuration', enable=True)
    GardenHealthCheckFailed = data('rep.GardenHealthCheckFailed', filter=filter('metric_source', 'cloudfoundry'), rollup='max').max(over='5m').publish(label='GardenHealthCheckFailed', enable=True)
    not_reporting.detector(stream=CPM, resource_identifier=None, duration='15m').publish('Pivotal Cloudfoundry - CapacityRemainingMemory not being reported.')
    detect(when((CapacityRemainingMemory > 32) and (CapacityRemainingMemory <= 64))).publish('Pivotal Cloudfoundry - CapacityRemainingMemory 5 Minute Minumum is within 32GB  and 64GB.')
    detect(when(CapacityRemainingMemory <= 32)).publish('Pivotal Cloudfoundry - CapacityRemainingMemory 5 Minute Minumum is less or Equal to 32GB.') 
    countdown.hours_left_stream_detector(stream=CapacityRemainingDisk, minimum_value=6, lower_threshold=48, fire_lasting=lasting('12m', 0.95), clear_threshold=60, clear_lasting=lasting('12m', 0.95), use_double_ewma=False).publish('Pivotal Cloudfoundry - CapacityRemainingDisk - (assumed to be decreasing) is projected to decrease to 6 in 48 hour(s).')
    detect(when((RepBulkSyncDuration >= 5) and (RepBulkSyncDuration < 10))).publish('Pivotal Cloudfoundry - RepBulkSyncDuration - Average Response is within 5 and 10 seconds.')
    detect(when(RepBulkSyncDuration >=10)).publish('Pivotal Cloudfoundry - RepBulkSyncDuration - Average Response is over 10 seconds.')
    detect(when(GardenHealthCheckFailed == 1)).publish('Pivotal Cloudfoundry - The value of rep.GardenHealthCheckFailed is 1.')
    detect(when(GardenHealthCheckFailed > 1)).publish('Pivotal Cloudfoundry - The value of rep.GardenHealthCheckFailed is above 1.')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - CapacityRemainingMemory not being reported."
    severity           = "Minor"
    tip                = " Validate Diego service"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - CapacityRemainingMemory 5 Minute Minumum is within 32GB  and 64GB."
    severity           = "Minor"
    tip                = "Assign more resources to the cells or assign more cells./nScale additional Diego cells using Ops Manager"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - CapacityRemainingMemory 5 Minute Minumum is less or Equal to 32GB."
    severity           = "Critical"
    tip                = "Assign more resources to the cells or assign more cells./nScale additional Diego cells using Ops Manager"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - CapacityRemainingDisk - (assumed to be decreasing) is projected to decrease to 6 in 48 hour(s)."
    severity           = "Minor"
    tip                = "Assign more resources to the cells or assign more cells./nScale additional Diego cells using Ops Manager"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - RepBulkSyncDuration - Average Response is within 5 and 10 seconds."
    severity           = "Minor"
    tip                = "Investigate BBS logs for faults and errors./nIf a particular cell or cells appear problematic, pull logs for the cells and the BBS logs before contacting Pivotal Support."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - RepBulkSyncDuration - Average Response is over 10 seconds."
    severity           = "Critical"
    tip                = "Investigate BBS logs for faults and errors./nIf a particular cell or cells appear problematic, pull logs for the cells and the BBS logs before contacting Pivotal Support."
    parameterized_body = var.message_body
  }

  rule {
    detect_label       = "Pivotal Cloudfoundry - The value of rep.GardenHealthCheckFailed is 1."
    severity           = "Minor"
    tip                = "Investigate Diego cell servers for faults and errors./n Contact Pivotal support"
    parameterized_body = var.message_body
  }

  rule {
    detect_label       = "Pivotal Cloudfoundry - The value of rep.GardenHealthCheckFailed is above 1."
    severity           = "Critical"
    tip                = "Investigate Diego cell servers for faults and errors./n Contact Pivotal support"
    parameterized_body = var.message_body
  }

}