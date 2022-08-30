terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = ">=6.13.1"
    }
  }
}

variable "signalfx_auth_token" {
   type=string
}

provider "signalfx" {
  auth_token = "${var.signalfx_auth_token}"
  # If your organization uses a different realm
  # api_url = "https://api.us2.signalfx.com"
  # If your organization uses a custom URL
  # custom_app_url = "https://myorg.signalfx.com"
}
