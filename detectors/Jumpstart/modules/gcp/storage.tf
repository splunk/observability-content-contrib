resource "signalfx_detector" "gcp_cloud_storage_errors" {
  name         = "${var.alert_prefix} GCP Cloud Storage Requests High Error Rate"
  description  = "Alerts when there is a high 4xx or 5xx error rate"
  program_text = <<-EOF
    A = data('api/request_count', filter=filter('response_code', '4*'), rollup='latest').sum(by=['bucket_name']).publish(label='4xx error', enable=False)
    B = data('api/request_count', rollup='latest').sum(by=['bucket_name']).publish(label='total', enable=False)
    detect(when(((A/B)*100) >= 10, lasting='5m')).publish('GCP Cloud Storage 10% of requests were 4xx for 5m')
    C = data('api/request_count', filter=filter('response_code', '5*'), rollup='latest').sum(by=['bucket_name']).publish(label='5xx error', enable=False)
    D = data('api/request_count', rollup='latest').sum(by=['bucket_name']).publish(label='total', enable=False)
    detect(when(((C/D)*100) >= 10, lasting='5m')).publish('GCP Cloud Storage 10% of requests were 5xx for 5m')
  EOF
  rule {
    detect_label       = "GCP Cloud Storage 10% of requests were 4xx for 5m"
    severity           = "Major"
    parameterized_body = var.message_body
  }
  rule {
    detect_label       = "GCP Cloud Storage 10% of requests were 5xx for 5m"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}