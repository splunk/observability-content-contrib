resource "synthetics_create_api_check_v2" "synthetics_thirdparty_status_api_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 34
    frequency           = 60
    location_ids        = ["aws-us-east-1", "aws-us-west-1"]
    name                = "Cloudflare Status API"
    scheduling_strategy = "round_robin"
    requests {
      configuration {
        body           = null
        headers        = {}
        name           = "curl https://www.cloudflarestatus.com/api/v2/status.json"
        request_method = "GET"
        url            = "https://www.cloudflarestatus.com/api/v2/status.json"
      }
      validations {
        actual     = null
        code       = null
        comparator = null
        expected   = null
        extractor  = "*"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "response"
      }
      validations {
        actual     = null
        code       = "var apiResponse = JSON.parse(custom[\"response\"]);\n\nfunction createGaugeEntry(apiResponse) {\n    var value = (apiResponse.status.indicator === \"none\") ? \"0\" : \"1\";\n    \n    var gaugeEntry = {\n        \"gauge\": [\n            {\n                \"metric\": \"cloudflare.status\",\n                \"dimensions\": {\n                    \"description\": apiResponse.status.description,\n                    \"indicator\": apiResponse.status.indicator\n                },\n                \"value\": value\n            }\n        ]\n    };\n\n    return gaugeEntry;\n}\n\nvar gaugeEntry = createGaugeEntry(apiResponse);\n\ncustom.payload_cloudflare = gaugeEntry;"
        comparator = null
        expected   = null
        extractor  = null
        name       = "JavaScript run"
        source     = null
        type       = "javascript"
        value      = null
        variable   = "payload_cloudflare"
      }
      validations {
        actual     = "{{custom.payload_cloudflare}}"
        code       = null
        comparator = "is_not_empty"
        expected   = null
        extractor  = null
        name       = "Assert custom variable payload_cloudflare is not empty"
        source     = null
        type       = "assert_string"
        value      = null
        variable   = null
      }
    }
    requests {
      configuration {
        body           = null
        headers        = {}
        name           = "curl https://www.githubstatus.com/api/v2/status.json"
        request_method = "GET"
        url            = "https://www.githubstatus.com/api/v2/status.json"
      }
      validations {
        actual     = null
        code       = null
        comparator = null
        expected   = null
        extractor  = "*"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "response"
      }
      validations {
        actual     = null
        code       = "var apiResponse = JSON.parse(custom[\"response\"]);\n\nfunction createGaugeEntry(apiResponse) {\n    var value = (apiResponse.status.indicator === \"none\") ? \"0\" : \"1\";\n\n    var gaugeEntry = {\n        \"gauge\": [\n            {\n                \"metric\": \"github.status\",\n                \"dimensions\": {\n                    \"description\": apiResponse.status.description,\n                    \"indicator\": apiResponse.status.indicator\n                },\n                \"value\": value\n            }\n        ]\n    };\n\n    return gaugeEntry;\n}\n\nvar gaugeEntry = createGaugeEntry(apiResponse);\n\ncustom.payload_github = gaugeEntry;"
        comparator = null
        expected   = null
        extractor  = null
        name       = "JavaScript run"
        source     = null
        type       = "javascript"
        value      = null
        variable   = "payload_github"
      }
      validations {
        actual     = "{{custom.payload_github}}"
        code       = null
        comparator = "is_not_empty"
        expected   = null
        extractor  = null
        name       = "Assert custom variable payload_github is not empty"
        source     = null
        type       = "assert_string"
        value      = null
        variable   = null
      }
    }
    requests {
      configuration {
        body = "{{custom.payload}}"
        headers = {
          Content-Type = "application/json"
          X-SF-Token   = "{{env.org_ingest_token}}"
        }
        name           = "https://ingest.us1.signalfx.com/v2/datapoint"
        request_method = "POST"
        url            = "https://ingest.us1.signalfx.com/v2/datapoint"
      }
      setup {
        code      = "var gaugePayloads = [\n    JSON.parse(custom[\"payload_github\"]),\n    JSON.parse(custom[\"payload_cloudflare\"])\n];\n\nfunction combineMultipleGaugeEntries(payloads) {\n    var combinedGaugeArray = [];\n    \n    for (var i = 0; i < payloads.length; i++) {\n        combinedGaugeArray = combinedGaugeArray.concat(payloads[i].gauge);\n    }\n\n    return { \"gauge\": combinedGaugeArray };\n}\n\nvar combinedGaugeEntry = combineMultipleGaugeEntries(gaugePayloads);\n\ncustom.payload = combinedGaugeEntry;"
        extractor = null
        name      = "JavaScript run"
        source    = null
        type      = "javascript"
        value     = null
        variable  = "payload"
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
