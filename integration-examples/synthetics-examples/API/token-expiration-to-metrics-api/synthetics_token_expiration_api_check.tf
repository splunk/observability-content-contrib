resource "synthetics_create_api_check_v2" "synthetics_token_expiration_api_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 1
    frequency           = 60
    location_ids        = ["aws-us-east-1", "aws-us-west-1"]
    name                = "org-token-expiration-to-count-metrics"
    scheduling_strategy = "round_robin"
    requests {
      configuration {
        body = null
        headers = {
          Content-Type = "application/json"
          X-SF-Token   = "{{env.org_api_token}}"
        }
        name           = "https://api.us1.signalfx.com/v2/organization"
        request_method = "GET"
        url            = "https://api.us1.signalfx.com/v2/organization"
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
        extractor  = "$.tokensExpiringInThirtyDays"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "30daytokenarray"
      }
      validations {
        actual     = null
        code       = null
        comparator = null
        expected   = null
        extractor  = "$.tokensExpiringInSevenDays"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "7daytokenarray"
      }
      validations {
        actual     = null
        code       = "const sevenDayTokens = {\n    metric: \"tokens.expiring.7days\",\n    tokens: custom[\"7daytokenarray\"] ? JSON.parse(custom[\"7daytokenarray\"]) || [] : []\n};\n\nconst thirtyDayTokens = {\n    metric: \"tokens.expiring.30days\",\n    tokens: custom[\"30daytokenarray\"] ? JSON.parse(custom[\"30daytokenarray\"]) || [] : []\n};\n\nfunction generateGaugeJSON(...tokenObjects) {\n    const result = { gauge: [] };\n    \n    tokenObjects.forEach(tokenObject => {\n        const { metric, tokens } = tokenObject;\n        tokens.forEach(token => {\n            result.gauge.push({\n                metric: metric,\n                dimensions: { token_names: token },\n                value: \"1\"\n            });\n        });\n    });\n\n    custom.body_json = result;\n    return result;\n}\n\ngenerateGaugeJSON(sevenDayTokens, thirtyDayTokens);"
        comparator = null
        expected   = null
        extractor  = null
        name       = "JavaScript run"
        source     = null
        type       = "javascript"
        value      = null
        variable   = "body_json"
      }
    }
    requests {
      configuration {
        body = "{{custom.body_json}}"
        headers = {
          Content-Type = "application/json"
          X-SF-Token   = "{{env.org_ingest_token}}"
        }
        name           = "https://ingest.us1.signalfx.com/v2/datapoint"
        request_method = "POST"
        url            = "https://ingest.us1.signalfx.com/v2/datapoint"
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
