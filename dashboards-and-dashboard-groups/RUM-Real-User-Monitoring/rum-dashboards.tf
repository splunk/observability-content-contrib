terraform {
  required_providers {
    signalfx = {
      source  = "splunk-terraform/signalfx"
      version = "~> 6.10"
    }
  }

}

variable "access_token" {
  type = string
  description = "Splunk Access Token"

}

variable "realm" {
  type = string
  description = "Splunk Realm"
}

# Configure the SignalFx provider
provider "signalfx" {
  auth_token = var.access_token
  api_url = "https://api.${var.realm}.signalfx.com"
  # If your organization uses a custom URL modify this to use:
  # custom_app_url = "https://myorg.signalfx.com"
}

resource "signalfx_dashboard_group" "rum_dashboard_group" {
  name        = "Real User Monitoring Dashboards"
  description = "RUM dashboard group"

}

resource "signalfx_dashboard" "rum_browser_metrics" {
  name            = "RUM Browser Metrics"
  dashboard_group = signalfx_dashboard_group.rum_dashboard_group.id

  time_range = "-30m"

  filter {
    property = "sf_ua_osname"
    values   = ["Mac OS X","Linux","Windows"]
  }
  variable {
    property = "sf_ua_browsername"
    alias    = "browser"
    values   = ["*"]
  }

  chart {
    chart_id = signalfx_time_chart.browser_frontend_requests.id
    column = 0
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.browser_load_latency.id
    column = 4
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.browser_frontend_errors.id
    column = 8
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.browser_endpoint_latency.id
    column = 0
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.browser_endpoint_requests.id
    column = 6
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.browser_lcp.id
    column = 0
    height = 1
    row = 2
    width = 4
  }

  chart {
    chart_id = signalfx_time_chart.browser_fid.id
    column = 4
    height = 1
    row = 2
    width = 4
  }

  chart {
    chart_id = signalfx_time_chart.browser_cls.id
    column = 8
    height = 1
    row = 2
    width = 4
  }
}

resource "signalfx_dashboard" "rum_app_metrics" {
  name            = "RUM App Metrics"
  dashboard_group = signalfx_dashboard_group.rum_dashboard_group.id

  time_range = "-30m"

  filter {
    property = "os.name"
    values   = ["Android","iOS"]
  }

  chart {
    chart_id = signalfx_time_chart.app_frontend_requests.id
    column = 0
    height = 1
    row = 0
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.app_load_latency.id
    column = 6
    height = 1
    row = 0
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.app_endpoint_latency.id
    column = 0
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.app_endpoint_requests.id
    column = 6
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.app_crash_count.id
    column = 0
    height = 1
    row = 2
    width = 6
  }

  chart {
    chart_id = signalfx_time_chart.app_error_count.id
    column = 6
    height = 1
    row = 2
    width = 6
  }

  chart {
    chart_id = signalfx_time_chart.app_coldstart_count.id
    column = 0
    height = 1
    row = 3
    width = 6
  }


  chart {
    chart_id = signalfx_time_chart.app_coldstart_time.id
    column = 6
    height = 1
    row = 3
    width = 6
  }  
}

resource "signalfx_dashboard" "rum_synthetic_metrics" {
  name            = "RUM Synthetics Metrics"
  dashboard_group = signalfx_dashboard_group.rum_dashboard_group.id

  time_range = "-30m"

  filter {
    property = "sf_ua_osname"
    values   = ["Rigor"]
  }
  variable {
    property = "sf_ua_browsername"
    alias    = "browser"
    values   = ["*"]
  }

  chart {
    chart_id = signalfx_time_chart.synthetic_frontend_requests.id
    column = 0
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.synthetic_load_latency.id
    column = 4
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.synthetic_frontend_errors.id
    column = 8
    height = 1
    row = 0
    width = 4
  }  

  chart {
    chart_id = signalfx_time_chart.synthetic_endpoint_latency.id
    column = 0
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.synthetic_endpoint_requests.id
    column = 6
    height = 1
    row = 1
    width = 6
  }  

  chart {
    chart_id = signalfx_time_chart.synthetic_lcp.id
    column = 0
    height = 1
    row = 2
    width = 4
  }

  chart {
    chart_id = signalfx_time_chart.synthetic_fid.id
    column = 4
    height = 1
    row = 2
    width = 4
  }

  chart {
    chart_id = signalfx_time_chart.synthetic_cls.id
    column = 8
    height = 1
    row = 2
    width = 4
  }
}
