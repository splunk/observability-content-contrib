resource "synthetics_create_api_check_v2" "synthetics_status_to_splunk_hec_api_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 34
    frequency           = 60
    location_ids        = ["aws-us-east-1", "aws-us-west-1"]
    name                = "OpenAI Status - To Splunk HEC"
    scheduling_strategy = "round_robin"
    requests {
      configuration {
        body           = null
        headers        = {}
        name           = "Get OpenAI status"
        request_method = "GET"
        url            = "https://status.openai.com/proxy/status.openai.com"
      }
      validations {
        actual     = "{{response.code}}"
        code       = null
        comparator = "is_less_than"
        expected   = "300"
        extractor  = null
        name       = "Assert response code is less than 300"
        source     = null
        type       = "assert_numeric"
        value      = null
        variable   = null
      }
      validations {
        actual     = null
        code       = null
        comparator = null
        expected   = null
        extractor  = "$.summary.ongoing_incidents[*].updates"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "openai_ongoing_incidents"
      }
    }
    requests {
      configuration {
        body = "{{custom.openai_ongoing_incidents}}"
        headers = {
          Authorization = "{{env.hec_token}}"
        }
        name           = "Send to Splunk HEC Ingest"
        request_method = "POST"
        url            = "{{env.splunk_hec_url}}"
      }
      validations {
        actual     = "{{response.code}}"
        code       = null
        comparator = "is_less_than"
        expected   = "300"
        extractor  = null
        name       = "Assert response code is less than 300"
        source     = null
        type       = "assert_numeric"
        value      = null
        variable   = null
      }
    }
  }
}
