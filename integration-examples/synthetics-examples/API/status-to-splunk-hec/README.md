# Third-party Status Page API Check to Metric
This example API test calls the OpenAI status endpoint and collects data on ongoing incidents and updates.
This test creates and sends a log event containing that incident data to a Splunk HEC endpoint. 
The test and it's configuration are included in this directory:
- [`synthetics_status_to_splunk_hec_api_check.tf`](./synthetics_status_to_splunk_hec_api_check.tf) 
    - Uses the [Splunk Synthetics Terraform provider](https://registry.terraform.io/providers/splunk/synthetics/latest/docs)

## Synthetic API Test
The synthetic API test will call the OpenAI status page and report any current and ongoing incidents to a Splunk HEC endpoint of your choice. This example is mostly to illustrate ingest arbitrary ingest into Splunk. The test serves a double function of providing external monitoring of the HEC endpoint in question in addition to providing ingest of useful incident data.


### Required Splunk Synthetic Global Variables
The following [global variables](https://docs.splunk.com/observability/en/synthetics/test-config/global-variables.html) are **REQUIRED** to run the included API test.
- `splunk_hec_url`: The url to your hec raw ingest (E.G. `https://hec-inputs-for-my-service.mysplunkinstance.com:443/services/collector/raw`)
- `hec_token`: A provisioned hec token for basic auth (E.G. `Splunk 123412-3123-1234-abcd-1234123412abc`)

