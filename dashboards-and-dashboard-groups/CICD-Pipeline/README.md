# CI/CD Pipeline

Included in this contribution are Terraform files to create a dashboard to monitor a CI/CD pipeline deployment. Many variables like chart names and signal names are there for demonstration purposes and can be adjusted to fit your specific use case.

## Terraform Files

To use these Terraform files, you will need to have the following required variables, either as environmental variables, CLI arguments, or in a `terraform.tfvars` file:

- `access_token` - Your Splunk Observability Cloud token (with API permissions).
- `realm` - Your Splunk Observability Cloud realm (e.g. `us0`).
- `username` - Your Splunk Observability Cloud username. This is merely a filter option and can be changed anytime within the dashboard.
- `dashboard_group` - The ID of the dashboard group under which to create the dashboard (ex: `FcoHwOFAwAM`)
- `log_observer_connect_connection` - The Splunk Enterprise/Cloud endpoint to federate logs from. Ex: "o11y-suite-us1.stg.splunkcloud.com"
- `log_observer_connect_index` - The Splunk Enterprise/Cloud index. Can be more than one. Ex: "o11y-demo-us"

## Charts

The dashboard includes the following default charts for demonstration purposes. These can be changed via Terraform's `variables.tf` and `tfvars` files.

- **Event Feed**: Displaying code pushes and notable events (like a triggered alert).
- **Response Time SLA**: A radial chart that uses the `requests.latency` metric to display the 99th percentile response time by user.
- **Requests per Second**: A line chart that uses the `requests.processed` metric to display the sum.
- **Requests Processed per Container**: An area chart that uses the `requests.processed` metric to display the sum of requests by `containerId`.
- **Overall Requests Processed**: A line chart that uses the `requests.processed` metric to display the sum of all requests processed.
- **Requests Latency by Merchant**: A list chart that uses the `requests.latency` metric to display the top 6 "merchants" by latency/duration.
- **Requests Latency by Merchant**: Same as the above, but an area chart visualization.
- **Authorization - Requests Processed per Container**: A heatmap chart that uses the `requests.processed` metric. Ordered by `host.name`. Drops any values below 0.
- **Peak Request Latency (last 10s)**: A single value chart that uses the `requests.latency` metric to display the max value over the last 10 seconds.
- **CI/CD Logs**: A logs table view, filtered by user.
