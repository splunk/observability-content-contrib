resource "signalfx_detector" "pivotal_cloudfoundry_auctioneer_errors" {
  name         = "${var.o11y_prefix} Pivotal CloudFoundry Auctioneer errors"
  description  = "Alerts for various Pivotal CloudFoundry Auctioneer related error scenarios"
  program_text = <<-EOF
    from signalfx.detectors.against_periods import against_periods
    from signalfx.detectors.against_recent import against_recent
    AuctioneerLRPAuctionsFailed = data('auctioneer.AuctioneerLRPAuctionsFailed', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='AuctioneerLRPAuctionsFailed')
    B = data('auctioneer.AuctioneerFetchStatesDuration', filter=filter('metric_source', 'cloudfoundry')).max(over='5m').publish(label='B')
    AuctioneerFetchStatesDuration = (B/1000000000).publish(label='AuctioneerFetchStatesDuration')
    AuctioneerLRPAuctionsStarted = data('auctioneer.AuctioneerLRPAuctionsStarted', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='AuctioneerLRPAuctionsStarted')
    AuctioneerTaskAuctionsFailed = data('auctioneer.AuctioneerTaskAuctionsFailed', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='AuctioneerTaskAuctionsFailed')
    detect((when((AuctioneerLRPAuctionsFailed >= 0.5) and (AuctioneerLRPAuctionsFailed < 1)))).publish('Pivotal Cloudfoundry - AuctionsFailed - Minor.')
    detect(when(AuctioneerLRPAuctionsFailed >= 1 )).publish('Pivotal Cloudfoundry - AuctionsFailed - Critical.')
    detect((when((AuctioneerFetchStatesDuration >= 2) and (AuctioneerFetchStatesDuration < 5)))).publish('Pivotal Cloudfoundry - FetchStatesDuration > 2 sec.')
    detect(when(AuctioneerFetchStatesDuration >= 5)).publish('Pivotal Cloudfoundry - FetchStatesDuration > 5 sec.')
    against_periods.detector_mean_std(stream=AuctioneerLRPAuctionsStarted, window_to_compare='10m', space_between_windows='1d', num_windows=4, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('Pivotal Cloudfoundry - LRPAuctionsStarted Historical norm deviation.')
    detect((when((AuctioneerTaskAuctionsFailed >= 0.5) and (AuctioneerTaskAuctionsFailed < 1)))).publish('Pivotal Cloudfoundry - TaskAuctionsFailed - Minor.')
    detect(when(AuctioneerTaskAuctionsFailed >= 1 )).publish('Pivotal Cloudfoundry - TaskAuctionsFailed - Critical.')
  EOF
  rule {
    detect_label       = "Pivotal Cloudfoundry - AuctionsFailed - Minor."
    severity           = "Minor"
    tip                = "To best determine the root cause, examine the Auctioneer logs. Depending on the specific error and resource constraint, you may also find a failure reason in the Cloud Controller (CC) API./nInvestigate the health of your Diego cells to determine if they are the resource type causing the problem./nConsider scaling additional cells using Ops Manager./nIf scaling cells does not solve the problem, pull Diego brain logs and BBS node logs and contact Pivotal Support telling them that LRP auctions are failing."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - AuctionsFailed - Critical."
    severity           = "Critical"
    tip                = "To best determine the root cause, examine the Auctioneer logs. Depending on the specific error and resource constraint, you may also find a failure reason in the Cloud Controller (CC) API./nInvestigate the health of your Diego cells to determine if they are the resource type causing the problem./nConsider scaling additional cells using Ops Manager./nIf scaling cells does not solve the problem, pull Diego brain logs and BBS node logs and contact Pivotal Support telling them that LRP auctions are failing."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - FetchStatesDuration > 2 sec."
    severity           = "Minor"
    tip                = "Check the health of the cells by reviewing the logs and looking for errors./nReview IaaS console metrics./nInspect the Auctioneer logs to determine if one or more cells is taking significantly longer to fetch state than other cells. Relevant log lines will have wording like `fetched cell state`./nPull Diego brain logs, cell logs, and auctioneer logs and contact Pivotal Support telling them that fetching cell states is taking too long."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - FetchStatesDuration > 5 sec."
    severity           = "Critical"
    tip                = "Check the health of the cells by reviewing the logs and looking for errors./nReview IaaS console metrics./nInspect the Auctioneer logs to determine if one or more cells is taking significantly longer to fetch state than other cells. Relevant log lines will have wording like `fetched cell state`./nPull Diego brain logs, cell logs, and auctioneer logs and contact Pivotal Support telling them that fetching cell states is taking too long."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - LRPAuctionsStarted Historical norm deviation."
    severity           = "Warning"
    tip                = "When observing a significant amount of container churn, do the following:/nLook to eliminate explainable causes of temporary churn, such as a deployment or increased developer activity./nIf container churn appears to continue over an extended period, pull logs from the Diego Brain and BBS node before contacting Pivotal support./nWhen observing extended periods of high or low activity trends, scale up or down CF components as needed."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - TaskAuctionsFailed - Minor."
    severity           = "Minor"
    tip                = "In order to best determine the root cause, examine the Auctioneer logs. Depending on the specific error or resource constraint, you may also find a failure reason in the CC API./nInvestigate the health of Diego cells./nConsider scaling additional cells using Ops Manager./nIf scaling cells does not solve the problem, pull Diego brain logs and BBS logs for troubleshooting and contact Pivotal Support for additional troubleshooting. Inform Pivotal Support that Task auctions are failing."
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "Pivotal Cloudfoundry - TaskAuctionsFailed - Critical."
    severity           = "Critical"
    tip                = "In order to best determine the root cause, examine the Auctioneer logs. Depending on the specific error or resource constraint, you may also find a failure reason in the CC API./nInvestigate the health of Diego cells./nConsider scaling additional cells using Ops Manager./nIf scaling cells does not solve the problem, pull Diego brain logs and BBS logs for troubleshooting and contact Pivotal Support for additional troubleshooting. Inform Pivotal Support that Task auctions are failing."
    parameterized_body = var.message_body
  }
}