# Jumpstart Detectors
The SignalFX Jumpstart repository contained detectors for various technologies. Those detectors are now available here under the Splunk Github organization for completeness.

These detectors are not meant to be exhaustive and should be thought of as a resource for getting started on your own detectors in [Terraform](https://registry.terraform.io/providers/splunk-terraform/signalfx/latest/docs)!

Please feel free to contribute your own detectors back to this repository!

*Special thanks to Robert Castley for maintaining these over at the original [SignalFX Repository](https://github.com/signalfx/signalfx-jumpstart)*

# Using Terraform to spin up detectors
**Requires Terraform (minimum) v0.14**

## Initialise Terraform
Initialize your terraform workspace in this directory of the repository.

```
$ terraform init --upgrade
```

## Create a workspace for the prospect (Optional)

```
$ terraform workspace new my_project
```
Where `my_project` is the workspace name you would like to use.

## Review the execution plan

```
$ terraform plan -var="access_token=abc123" -var="realm=eu0"
```

Where `access_token` is a Splunk Observability Access Token or Splunk Observability User API Token and `realm` is either `eu0`, `us0`, `us1` or `us2` (check your user profile for your realm)

## Create ALL detectors
To spin up all of the included detectors in this repo using terraform.

```
$ terraform apply -var="access_token=abc123" -var="realm=eu0"
```
# Deploying detectors from an individual module directory

```
terraform apply -var="access_token=abc123" -var="realm=eu0" -var="alert_prefix=my-aws-account" -target=module.aws
terraform apply -var="access_token=abc123" -var="realm=eu0" -var="alert_prefix=my-team-or-service-name" -target=module.gcp
```

**Note:** To prefix your detectors with an identifier use the `alert_prefix` variable like so: `-var="alert_prefix=FightingMongooses"`
  - By default detectors will be prefixed with `[Splunk]`


## Destroy everything!

If you created a workspace you will first need to ensure you are in the correct workspace e.g.

```
$ terraform workspace select my_project
```
Where `my_project` is the name of the project

```
$ terraform destroy -var="access_token=abc123" -var="realm=eu0"
```

Special thanks to Robert Castley for maintaining these over at the [SignalFX Repository](https://github.com/signalfx/signalfx-jumpstart)