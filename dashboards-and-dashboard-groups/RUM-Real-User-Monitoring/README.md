# Real User Monitoring Detailed Dashboards 

This directory contains detail oriented dashboards and required chart definitions in Terraform for:
- RUM Apps
- RUM Browsers
- RUM Synthetics

Each of these dashboards is meant as a place to look at details of the specific metrics RUM provides split by Browser, App, or Rigor Synthetics.

As usual with Terraform these scripts expect an environment variable named `signalfx_auth_token`
  - Example: `export TF_VAR_signalfx_auth_token='this_is_my_api_token'`