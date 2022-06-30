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


### Create a Dashboard Group for our Dashboards
resource "signalfx_dashboard_group" "exec_dashboard_group" {
  name        = "Exec Level Dashboards"
  description = "Executive Level Dashboards"

  ### Note that if you use these features, you must use a user's
  ### admin key to authenticate the provider, lest Terraform not be able
  ### to modify the dashboard group in the future!
  #authorized_writer_teams = [signalfx_team.mycoolteam.id]
  #authorized_writer_users = ["abc123"]
}
