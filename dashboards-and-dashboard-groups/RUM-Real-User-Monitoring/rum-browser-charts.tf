resource "signalfx_time_chart" "browser_lcp" {
  name = "Web Vitals - Longest Contentful Paint in ms (P75)"

  program_text = <<-EOF
        LCP = data('rum.webvitals_lcp.time.ns.p75', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).scale(0.000001).publish(label='LCP')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_fid" {
  name = "Web Vitals - First Input Delay in ms (P75)"

  program_text = <<-EOF
        FID = data('rum.webvitals_fid.time.ns.p75', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).scale(0.000001).publish(label='FID')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_cls" {
  name = "Web Vitals - Cumulative Layout shift (P75)"

  program_text = <<-EOF
        CLS = data('rum.webvitals_cls.score.p75', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).publish(label='CLS')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_frontend_requests" {
  name = "Browser Metrics - Frontend Requests"

  program_text = <<-EOF
        frontend = data('rum.page_view.count', filter=filter('sf_ua_browsername', '*')).sum(by=['sf_ua_browsername']).publish(label='frontend')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_load_latency" {
  name = "Browser Metrics - Document Load Latency in ms (P75)"

  program_text = <<-EOF
        load_latency = data('rum.page_view.time.ns.p75', filter=filter('sf_ua_browsername', '*')).scale(0.000001).mean(by=['sf_ua_browsername']).publish(label='load_latency')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_frontend_errors" {
  name = "Browser Metrics - Frontend Errors"

  program_text = <<-EOF
        frontend_errors = data('rum.client_error.count', filter=filter('sf_ua_browsername', '*')).sum(by=['sf_ua_browsername']).publish(label='frontend_errors')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_endpoint_latency" {
  name = "Browser Metrics - Endpoint Latency in ms (P75)"

  program_text = <<-EOF
        endpoint_latency = data('rum.resource_request.time.ns.p75', filter=filter('sf_ua_browsername', '*')).scale(0.000001).mean(by=['sf_operation']).publish(label='endpoint_latency')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }

}

resource "signalfx_time_chart" "browser_endpoint_requests" {
  name = "Browser Metrics - Endpoint Requests / Errors"

  program_text = <<-EOF
        requests = data('rum.resource_request.count', filter=filter('sf_ua_browsername', '*') and filter('sf_error', 'false')).sum(by=['sf_operation']).publish(label='requests')
        error_requests = data('rum.resource_request.count', filter=filter('sf_ua_browsername', '*') and filter('sf_error', 'true')).sum(by=['sf_operation']).publish(label='error_requests')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true
  stacked = true

  legend_options_fields {
    property = "sf_operation"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_ua_browsername"
    enabled  = true
  }
 

}