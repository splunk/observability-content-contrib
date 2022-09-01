# Real User Monitoring Detailed Dashboards 

This directory contains detail oriented dashboards and required chart definitions in Terraform for:
- RUM Apps
- RUM Browsers
- RUM Synthetics

Each of these dashboards is meant as a place to look at details of the specific metrics RUM provides split by Browser, App, or Rigor Synthetics.

To use:

```
terraform init --upgrade
terraform plan -var="access_token=<token>" -var="realm=<realm>"
terraform apply -auto-approve -var="access_token=<token>" -var="realm=<realm>"
```

And to remove

```
erraform destroy -auto-approve -var="access_token=<token>" -var="realm=<realm>"
```

