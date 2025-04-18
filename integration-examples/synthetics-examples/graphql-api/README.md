# GraphQL API Check Example
This example API test shows how to query a GraphQL endpoint and validate the returned data using built in matching and JavaScript parsing. 
The test and it's configuration are included in this directory:
- [`synthetics_example_graphql_api_check.tf`](./synthetics_example_graphql_api_check.tf) 
    - Uses the [Splunk Synthetics Terraform provider](https://registry.terraform.io/providers/splunk/synthetics/latest/docs)

## Synthetic API Test
The API test will call [https://countries.trevorblades.com/graphql](https://countries.trevorblades.com/graphql) which provides data on various countries. We use this data for ease of accessibility purposes. But this approach applies just as well to internal GraphQL endpoints where you want to validate the responses being provided or specific values of data within those responses.

Our test will query the info on Canada and check that:
- The endpoint returns the expected national languages in the expected JSON format.
- The endpoint returns an array of states within the country. We will use JavaScript and custom variables to validate that there are still exactly 13 "states" (provences) in Canada.

The expected body we will receive from our request and that we will be validating against looks like so:
```JSON
{
    "data":
    {
        "country":
        {
            "name": "Canada",
            "native": "Canada",
            "capital": "Ottawa",
            "emoji": "🇨🇦",
            "currency": "CAD",
            "languages":
            [
                {
                    "code": "en",
                    "name": "English"
                },
                {
                    "code": "fr",
                    "name": "French"
                }
            ],
            "states":
            [
                {
                    "code": "AB"
                },
                {
                    "code": "BC"
                },
                {
                    "code": "MB"
                },
                {
                    "code": "NB"
                },
                {
                    "code": "NL"
                },
                {
                    "code": "NS"
                },
                {
                    "code": "NU"
                },
                {
                    "code": "NT"
                },
                {
                    "code": "ON"
                },
                {
                    "code": "PE"
                },
                {
                    "code": "QC"
                },
                {
                    "code": "SK"
                },
                {
                    "code": "YT"
                }
            ]
        }
    }
}
```
