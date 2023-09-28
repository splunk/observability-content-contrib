# Observability Cloud Jumpstart

**Note:** Requires Terraform (minimum) v1.3.x

## Introduction

This repository provides detectors, dashboard groups, and dashboards that can easily be deployed in a Splunk Observability Cloud org using Terraform.

This can be useful for the assets themselves, but also as a construct for how you can easily share assets across multiple parent/child orgs. Also included is an [export script](./export_script) which can be used to easily export dashboards, dashboard groups, and detectors.

These are complimentary to the out of the box content provided by Splunk. This repository and its assets are provided "as-is" and are not supported by Splunk.

## Clone the repository

`git clone https://github.com/splunk/observability-content-contrib.git`

## Change into JumpStart directory

`cd observability-content-contrib/integration-examples/terraform-jumpstart`

## Initialise Terraform

``` text
terraform init --upgrade
```

## Create a workspace (optional)

``` text
terraform workspace new my_workspace
```

Where `my_workspace` is the name of the workspace you want to create.

## 5. Terraform variables description

- `api_token`: Observability API Token
- `splunk_realm`: Observability Realm (`eu0`, `us0`, `us1`, `us2`, `jp0`, `au0`)
- `o11y_prefix`: Text that will prefix all the detectors, dashboard groups, and dashboards

## Create a `terraform.tfvars` file

Copy the template file `terraform.tfvars.template` to `terraform.tfvars` and fill in the values e.g.

``` text
api_token="1234xxx5678yyyy"
realm="eu0"
o11y_prefix="[Splunk]"
```

## Review the execution plan

``` text
terraform plan
```

## Apply the changes

``` text
terraform apply
```

## Destroy everything

If you created a workspace you will first need to ensure you are in the correct workspace e.g.

``` text
terraform workspace select my_workspace
```

Where `my_workspace` is the name of the workspace you want to be in. Then run the destroy command:

``` text
terraform destroy
```

## Deploying a module

``` text
terraform apply -target=module.aws
terraform apply -target=module.dashboards
terraform apply -target=module.gcp
```
