# Terraform Import SignalFx Dashboards

This folder contains helper scripts for importing SignalFx dashboard groups. along with their linked dashboards and charts, into Terraform code. This tool enables users to create dashboards in the SignalFx UI and then convert them into infrastructure-as-code for better version control and automation.

## Usage

This script, given dashboard group ids, will generate mostly usable terraform code for dashboard groups, and any associated dashboards/charts.

### Building the Docker Image

To build docker image with the script binary and terraform installed, run the following command:

```sh
make build
```

It is recommeded to pull the latest version of the repo and run build cmd before running the script.

### Cleaning up the Docker Image

To clean up the docker image, run the following command:

```sh
make clean
```

### Viewing Options

To look at the options for the script, run the following command:

```sh
docker run import-tf-script --help
```

Currently supported options -

```
❯ docker run import-tf-script --help
Usage: /app/main [options]
  -add-var-file
        Add variables.tf file to the directory. This file only defines variabled the generated terraform code uses.
  -add-versions-file
        Add versions.tf file to the directory. This file will have terraform block with version requirements.
  -allow-chart-name-conflict
        Allow charts with the same name in a dashboard. This will add an index at the end of the chart's name attribute and resource name to resolve conflict in naming. It is recommended to rename charts when you export the dashboards to TF for the first time.
  -api-token string
        API token for authentication
  -api-url string
        The API URL for Splunk Observability (default "https://app.us0.signalfx.com")
  -dir string
        Working directory where TF files will be written.
  -groups string
        Comma-separated list  dashboard group IDs in Splunk Observability to import. Required.
  -tf-path string
        The path to the Terraform binary (default "terraform")
```

### Quick Start

For a quick start cmd to generate terraform code for dashboard group, run the following make command:

```sh
SIGNALFX_AUTH_TOKEN=<SIGNALFX API TOKEN> SIGNALFX_API_URL=<API_URL> GROUP_IDS=<ID1,ID2> RELATIVE_DIR_PATH=resources/Dashboards make import-dashboard-group
```

This will generate a bunch of `.tf` files. There will be a file for each dashboard group, and a different file for dashboards in the groups. The dashboard file will have the dashboard and chart resources.

### Environment Variables

The following environment variables can be used with the `make import-dashboard-group` command:

- `SIGNALFX_AUTH_TOKEN` (required): Your Splunk Observability API token
- `SIGNALFX_API_URL` (optional): The API URL for your realm. Defaults to `https://app.us0.signalfx.com`. Common values:
  - US0: `https://app.us0.signalfx.com` (default)
  - US1: `https://app.us1.signalfx.com`  
  - EU0: `https://app.eu0.signalfx.com`
- `GROUP_IDS` (required): Comma-separated list of dashboard group IDs (e.g., `ID1,ID2,ID3`)
- `RELATIVE_DIR_PATH` (optional): Directory path where generated files will be written. Defaults to `"generated-dashboards"`

### Example to run with custom options

```sh
cd ${REPO_ROOT}
docker run -v $(pwd):/app import-tf-script \
--api-token <TOKEN> \
--api-url <API URL> \
--groups <ID1,ID2,ID3> \
--dir /app/resources/APM \
--allow-chart-name-conflict
```

### Supported Chart Types

The following chart types are supported by the import script:
- **Heatmap** - `signalfx_heatmap_chart`
- **List** - `signalfx_list_chart` 
- **SingleValue** - `signalfx_single_value_chart`
- **Text** - `signalfx_text_chart`
- **TimeSeriesChart** - `signalfx_time_chart`
- **TableChart** - `signalfx_table_chart`
- **Line** - `signalfx_line_chart`
- **Event** - `signalfx_event_feed_chart`

The following chart types are **NOT** currently supported and will cause the script to fail with an "unsupported chart type" error:
- **Log query charts** - Any charts that query log data for e.g. the `signalfx_log_timeline` chart

### Additional Notes

- The resource type and name must be unique within a TF module. Changing the resource name will be treated as a recreate by TF, which means dashboard/chart urls will be updated if their corresponding resource name is changed. We derive the TF resource name from the SignalFx object names. It is recommended to clean-up sfx names before the first import to avoid recreates when rerunning the script to import updates to dashboards. The resource names generated for the different resource types are explained below. The names will have non-alphanumeric characters replaced with `_`:
  - `signalfx_dashboard_group`: `<dashboard group name>`
  - `signalfx_dashboard`: `<dashboard group resource name>_<dashboard name>`
  - `signalfx_*_chart`: `<dashboard resource name>_<chart name>`
    - In case of duplicate chart type and name combos in a dashboards, the script will append a number to the chart's name attribute and the chart resource name to make it unique if the option `--allow-chart-name-conflict` is provided. The additional index in the conflicting chart name on the first run of the script, will ensure the re-runs of the script does not cause TF to recreate chart resource, keeping the url same. If the option is not provided, the script will exit with an error on encountering conflicts. It is recommended to rename charts to make them unique before running the script.
    - For `text` charts, the script will fallback to the chart description to generate chart resource name if the chart name is empty. This is useful for Text charts which usually are untitled. Users are recommended to update their text charts to add some small unique description. We recommend using descriptions for text chart since titles for text charts might not be desirable in the UI.
- The `dashboard_group` will only have READ permissions for the org, and the dashboard resource will inherit the group's permission. You can edit the `signalfx_dashboard_group` resource to add more permission blocks. Make sure you update the permissions when you create these for the first time since a session token of an administrator is needed to update write permissions of existing groups.
- The script will overwrite any existing files in the directory with same names. If you want to keep the existing files, move them to a different directory before running the script.
- Charts with detector links will have their `program_text` updated to replace the detector_id with terraform resource reference to the detector. The reference is in the format `signalfx_detector.<detector resource name>.id`. The detector resource name is generated by replacing non-alphanumeric characters with `_` in the detector name. If this resource is not found, plan will fail with an error. You can  update the detector resource reference in the chart resource to fix the error.
- The script orders the resources alphabetically by their resource type and name in the final terraform file. This is to ensure the order of resources is kind of deterministic and does not change between reruns of import script generating unnecessary diffs in the PRs.
