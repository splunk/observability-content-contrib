# Jumpstart Detectors
The SignalFX Jumpstart repository contained detectors for various technologies. Those detectors are now available here under the Splunk Github organization for completeness

[Original Repository here](https://github.com/signalfx/signalfx-jumpstart)

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
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.aws
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.dashboards
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.gcp
```


## Destroy everything!

If you created a workspace you will first need to ensure you are in the correct workspace e.g.

```
$ terraform workspace select my_prospect
```
Where `my_prospect` is the company name of the prospect

```
$ terraform destroy -var="access_token=abc123" -var="realm=eu0"
```