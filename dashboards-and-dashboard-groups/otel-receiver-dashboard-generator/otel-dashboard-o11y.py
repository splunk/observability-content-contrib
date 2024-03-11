import yaml
import argparse
import os

parser = argparse.ArgumentParser(description="Generates Terraform configs for Splunk Observability dashboards from OpenTelemetry receiver metadata YAML files that contain the receiver's metrics")
parser.add_argument('--file_path', metavar='file_path', type=str, default="", help='Path to an OpenTelemetry receiver YAML file containing metrics. Generated config printed to STDOUT')

args = parser.parse_args()

def create_shart_resources(metrics):
    """Creat chart resources from provided dict of metrics from the provided yaml

    Returns:
    terraform_chart_configs -- contains chart resource configurations
    """

    terraform_chart_configs = []
    for index, (metric_name, metric_details) in enumerate(metrics.items()):
        program_text = f'data("{metric_name}").publish(label="{metric_details["description"]}")\n'
        chart_name = metric_name.replace(".", "_").replace("-", "_")
        chart_config = f'''
resource "signalfx_time_chart" "{chart_name}" {{
  name = "{metric_details["description"]}"

  program_text = <<-EOF
    {program_text}  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}}
'''
        terraform_chart_configs.append(chart_config)
        
        chart_block = f'''chart {{
  chart_id = signalfx_time_chart.{chart_name}.id
}}'''    

    return terraform_chart_configs

def create_dashboard_resources(metrics, type):
    """Creates the dashboard and dashboard group resources from provided 
    dicts of metrics and type pulled from yaml.

    Returns:
    dashboard_config -- contains the dashboard and dashboard group TF configs
    """

    dashboard_config = f'''
resource "signalfx_dashboard" "{type}dashboard" {{
  name            = "{type}"
  dashboard_group = signalfx_dashboard_group.{type}dashboardgroup0.id
  time_range      = "-1h"

  grid {{
    chart_ids = [
      {", ".join([f'signalfx_time_chart.{metric_name.replace(".", "_").replace("-", "_")}.id' for metric_name in metrics.keys()])}
    ]
    width  = 4
    height = 1
  }}
}}

resource "signalfx_dashboard_group" "{type}dashboardgroup0" {{
  name        = "{type} generated OTel dashboard group"
  description = "{type} generated OTel dashboard group"
}}
'''
    return dashboard_config
                
def process_yaml_file(file_path):
    """Opens a metadata.yaml file from an OpenTelemetry Receiver that defines
    receiver metrics as input. Generates an appropriate signalfx Terraform 
    configuration from the provided input and prints it to stdout.
    """
    try:
        with open(file_path, 'r') as file:
            yaml_content = file.read()
            data = yaml.safe_load(yaml_content)

            # Get dicts from the loaded yaml
            metrics = data.get("metrics", {})
            type = data.get("type", str)

            # Generate chart resources for each metric
            terraform_chart_configs = create_shart_resources(metrics)

            # Join Terraform configurations into a single string
            terraform_chart_str = "\n".join(terraform_chart_configs)

        dashboard_config = create_dashboard_resources(metrics, type)
        return terraform_chart_str, dashboard_config
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found at the provided path. Please provide the path to an OTEL Receiver metadata.yaml file which contains that receivers metrics and attributes")
    except Exception as e:
        print(f"Error: {e}. Please use `--file_path` provide the path to an OTEL Receiver metadata.yaml file which contains that receivers metrics and attributes")


# Run the thing
if args.file_path == "":
  directory = "./otel-receiver-yaml"
  for filename in os.listdir(directory):
      f = os.path.join(directory, filename)
      # checking if it is a file
      if os.path.isfile(f):
          print(f)
          terraform_chart_str, dashboard_config = process_yaml_file(f)
          configname = f"./observability-tf-configs/{filename}.tf"
          with open(configname, "w", encoding="utf-8") as file:
              file.write(dashboard_config)
              file.write(terraform_chart_str)
          print(f"Created Observability Terraform config for {filename}")
else:
    terraform_chart_str, dashboard_config = process_yaml_file(args.file_path)
    print(terraform_chart_str)
    print(dashboard_config)

