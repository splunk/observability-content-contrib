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
usage: export.py [-h] --key KEY [--api_url API_URL] --name NAME
                            [--exclude [EXCLUDES [EXCLUDES ...]]] --output
                            OUTPUT
                            (--group GROUP | --dashboard DASH | --detector DETECTOR)

Export a Splunk Observability Cloud asset as Terraform

optional arguments:
  -h, --help            show this help message and exit
  --key KEY             An API key for accessing Splunk Observability Cloud
  --api_url API_URL     The API URL, used for non-us1 realms
  --name NAME           The name of the resource after export, e.g. mychart0
  --exclude [EXCLUDES [EXCLUDES ...]]
                        A field to exclude from the emitted HCL
  --output OUTPUT       The name of the directory to which output will be
                        written
  --group GROUP         The ID of the dashboard group in Splunk Observability Cloud
  --dashboard DASH      The ID of the dashboard in Splunk Observability Cloud
  --detector DETECTOR   The ID of the detector in Splunk Observability Cloud
```

Here's an example for a dashboard:

```
python3 export.py --key XXX --dashboard DjJ6MCMAgAA --name sfx_aws_sqs_queue --output ./
```

This command will recursively export each individual chart in a dashboard group and emit a dashboard definition where these charts are referred to by their Terraform resource name. The output will reside in a file called `sfx_aws_sqs_queue.tf`.

For dashboard groups uses `--group`. The output directory will contain one file per dashboard group.

## Important Notes

* This does **not** export a dashboard's data links. The issue being that the "target" dashboard would be a static ID (so not transferable across different Splunk Observability Cloud orgs).
* If your key begins with a hyphen you will need to use an equal sign like so: `--key=-someKeyHere`.
* The exporter does some regex surgery out of the emitted HCL. By default it excludes computed fields `id` and `url` as well as the problematic `tags` field, which is deprecated. It also removes the "bounds" values for axes that are just fixed values and bare `viz_options` fields that only specify a label and no other information. The latter can cause weird problems on creation.
