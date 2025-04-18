resource "synthetics_create_api_check_v2" "synthetics_example_graphql_api_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 34
    frequency           = 1440
    location_ids        = ["aws-ca-central-1", "aws-us-east-1", "aws-us-west-1", "aws-us-west-2"]
    name                = "Canada - Languages - Number of States"
    scheduling_strategy = "round_robin"
    requests {
      configuration {
        body = jsonencode({
          operationName = "Query"
          query         = "query Query {\n  country(code: \"CA\") {\n    name\n    native\n    capital\n    emoji\n    currency\n    languages {\n      code\n      name\n    }\n    states {\n      code\n    }\n  }\n}\n"
          variables     = {}
        })
        headers = {
          Content-Type = "application/json"
        }
        name           = "https://countries.trevorblades.com/graphql"
        request_method = "POST"
        url            = "https://countries.trevorblades.com/graphql"
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
        actual     = "{{response.body}}"
        code       = null
        comparator = "contains"
        expected   = "\"languages\":[{\"code\":\"en\",\"name\":\"English\"},{\"code\":\"fr\",\"name\":\"French\"}]"
        extractor  = null
        name       = "Assert response body value"
        source     = null
        type       = "assert_string"
        value      = null
        variable   = null
      }
      validations {
        actual     = null
        code       = null
        comparator = null
        expected   = null
        extractor  = "$.data.country.states"
        name       = "Extract from response body"
        source     = "{{response.body}}"
        type       = "extract_json"
        value      = null
        variable   = "statearray"
      }
      validations {
        actual     = null
        code       = "const apiResponse = custom[\"statearray\"] ? JSON.parse(custom[\"statearray\"]) || [] : [];\n\nfunction countStates(jsonData) {  \n  const stateCount = jsonData.length;\n  \n  custom.statcount = stateCount;\n  return stateCount;\n}\n\n\ncountStates(apiResponse);"
        comparator = null
        expected   = null
        extractor  = null
        name       = "JavaScript run"
        source     = null
        type       = "javascript"
        value      = null
        variable   = "statecount"
      }
      validations {
        actual     = "{{custom.statecount}}"
        code       = null
        comparator = "equals"
        expected   = "13"
        extractor  = null
        name       = "Assert custom variable statecount equals 13"
        source     = null
        type       = "assert_numeric"
        value      = null
        variable   = null
      }
    }
  }
}
