# Export Dashboards Script

The `export_dashboards.py` script aims to reduce the effort of export an existing dashboard or dashboard group.

## Support

This script is provided "as-is" and is not offically supported by Splunk.

## Requirements

This script requires Python 3. You can optionally create a virtual environment:

```
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

## Usage

```
A utility to export Splunk Observability Cloud assets as Terraform configuration.

Example usage:
    python export.py --key API_KEY --api_url API_URL --name RESOURCE_NAME --exclude EXCLUDES... --output OUTPUT_DIR (--group GROUP_ID | --dashboard DASHBOARD_ID | --detector DETECTOR_ID | --globaldatalink PROPERTY_NAME:PROPERTY_VALUE)

Arguments:
    --key API_KEY: An API key for accessing Splunk Observability Cloud
    --api_url API_URL: The API URL, used for non-us1 realms (default: 'https://api.us1.signalfx.com')
    --name RESOURCE_NAME: The name of the resource after export, e.g. mychart0 (required)
    --exclude EXCLUDES: A field to exclude from the emitted HCL (default: ['id', 'url', 'tags'])
    --output OUTPUT_DIR: The name of the directory to which output will be written (default: current directory)
    --group GROUP_ID: The ID of the dashboard group in Splunk Observability Cloud
    --dashboard DASHBOARD_ID: The ID of the dashboard in Splunk Observability Cloud
    --detector DETECTOR_ID: The ID of the detector in Splunk Observability Cloud
    --globaldatalink PROPERTY_NAME:PROPERTY_VALUE: The colon-separated property name and value for a global data link - if value is wildcarded just provide the name

Note: Only one of --group, --dashboard, --detector, or --globaldatalink should be specified.
```

Here's an example for a dashboard:

```
python3 export.py --key XXXXXXX --dashboard DjJ6MCMAgAA --name sfx_aws_sqs_queue --output ./
```

This command will recursively export each individual chart in a dashboard group and emit a dashboard definition where these charts are referred to by their Terraform resource name. The output will reside in a file called `sfx_aws_sqs_queue.tf`.

For dashboard groups use `--group`. The output directory will contain one file per dashboard group.

## Important Notes

* This does **not** export a dashboard's data links. The issue being that the "target" dashboard would be a static ID (so not transferable across different Splunk Observability Cloud orgs).
* If your key begins with a hyphen you will need to use an equal sign like so: `--key=-someKeyHere`.
* The exporter does some regex surgery out of the emitted HCL. By default it excludes computed fields `id` and `url` as well as the problematic `tags` field, which is deprecated. It also removes the "bounds" values for axes that are just fixed values and bare `viz_options` fields that only specify a label and no other information. The latter can cause weird problems on creation.
