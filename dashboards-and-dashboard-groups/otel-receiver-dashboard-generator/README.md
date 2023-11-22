# Generate Splunk Observability Dashboards from OpenTelemetry Receivers
These scripts help users of OpenTelemetry Receivers from the [OpenTelemetry Collector Contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib/) generate Terraform configurations of Splunk Observability dashboards from OpenTelemetry Receiver `metadata.yaml` files that contain the receiver's available metrics.

## Generate dashboard for a single receiver
Install the requirements and run `otel-dashboard-o11y.py` with the `--file_path` option pointing the `metadata.yaml` file for the receiver you'd like to generate from. 

Note: The Terraform configuration will print to STDOUT which can be piped to a `.tf` file. 
```
pip3 install -r requirements.txt
python3 otel-dashboard-o11y.py --file_path ./metadata.yaml
```

## Generate dashboards for many receivers
If the `--file_path` argument is not used the script will look in the local directory [`./otel-receiver-yaml/`](./otel-receiver-yaml/) for available receiver `metadata.yaml` files with metrics sections. Generated Terraform configurations will be placed in the local directory [`./observability-tf-configs`](./observability-tf-configs/).

`pull-otel-yaml.py` can be used to pull down all [receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver) configs with a `metrics` section and place them in the `./otel-receiver-yaml` directory. To avoid api rate limiting during this process a Github PAT token can be provided with the environment variable `$GITHUB_PAT_TOKEN`.
```
pip3 install -r requirements.txt
python3 pull-otel-yaml.py                          

Metadata.yaml with 'metrics' section extracted from activedirectorydsreceiver
Metadata.yaml with 'metrics' section extracted from aerospikereceiver
...
```

## Terraform Configuration Considerations
**NOTE:** These generated dashboards are not a replacement for any of the Out Of The Box dashboards available in Splunk Observability. [A list of those dashboards is available here](https://docs.splunk.com/observability/en/data-visualization/dashboards/dashboards-list.html). Using the out of the box dashboards will most likely provide the best monitoring experience for a given technology.

Generated Terraform configurations are just that... Generated. They include a line chart per metric named for that metric in a dashboard named for the receiver.

When generating a large number of configs there may be duplicate resource names in `terraform plan` based on metrics that use the same name. In this case edit the duplicate resource name and re-run `terraform plan`

### Terraform `signalfx` Provider
All generated configs work with the [`signalfx`]() Terraform provider. You'll need to define the provider in a `.tf` file in the same directory as your generated configurations.

**Example Provider configuration:** edit to incude your `api_url` and `$SFX_AUTH_TOKEN` for your specific Observability api url and api token.
```
terraform {
  required_providers {
    signalfx = {
      version = "~> 9.0.0"
      source  = "splunk-terraform/signalfx"
    }
  }
}

# Configure the SignalFx provider
provider "signalfx" {
  auth_token = "${var.SFX_AUTH_TOKEN}"
  # If your organization uses a different realm
  api_url = "https://api.us1.signalfx.com"
  # If your organization uses a custom URL
  # custom_app_url = "https://myorg.signalfx.com"
}
```