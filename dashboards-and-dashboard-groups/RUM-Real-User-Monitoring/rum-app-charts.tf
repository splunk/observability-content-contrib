resource "signalfx_time_chart" "app_frontend_requests" {
  name = "App Metrics - Frontend Requests"

  program_text = <<-EOF
        frontend = data('rum.page_view.count', filter=filter('app.version', '*')).sum(by=['app']).publish(label='frontend')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_load_latency" {
  name = "App Metrics - Document Load Latency in ms (P75)"

  program_text = <<-EOF
        app_load_latency = data('rum.page_view.time.ns.p75', filter=filter('app.version', '*')).scale(0.000001).mean(by=['app']).publish(label='app_load_latency')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_endpoint_latency" {
  name = "App Metrics - Endpoint Latency in ms (P75)"

  program_text = <<-EOF
        app_endpoint_latency = data('rum.resource_request.time.ns.p75', filter=filter('app.version', '*')).scale(0.000001).mean(by=['sf_operation']).publish(label='app_endpoint_latency')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true


  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_endpoint_requests" {
  name = "App Metrics - Endpoint Requests / Errors"

  program_text = <<-EOF
        requests = data('rum.resource_request.count', filter=filter('app.version', '*') and filter('sf_error', 'false')).sum(by=['sf_operation']).publish(label='requests')
        error_requests = data('rum.resource_request.count', filter=filter('app.version', '*') and filter('sf_error', 'true')).sum(by=['sf_operation']).publish(label='error_requests')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true
  stacked = true


  viz_options {
    label = "requests"
    axis  = "left"
    plot_type = "AreaChart"
  }

  viz_options {
    label = "error_requests"
    axis  = "left"
    plot_type = "ColumnChart"
  }

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_coldstart_count" {
  name = "App Metrics - Coldstart Count"

  program_text = <<-EOF
        app_coldstart_count = data('rum.cold_start.count', filter=filter('app.version', '*')).sum(by=['app']).publish(label='app_coldstart_count')
        EOF

  time_range = 3600

  plot_type         = "ColumnChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_error_count" {
  name = "App Metrics - App Error Count"

  program_text = <<-EOF
        app_error_count = data('rum.app_error.count', filter=filter('app.version', '*')).sum(by=['app']).publish(label='app_error_count')
        EOF

  time_range = 3600

  plot_type         = "AreaChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_crash_count" {
  name = "App Metrics - Crash Count"

  program_text = <<-EOF
        app_crash_count = data('rum.crash.count', filter=filter('app.version', '*')).sum(by=['app']).publish(label='app_crash_count')
        EOF

  time_range = 3600

  plot_type         = "ColumnChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}

resource "signalfx_time_chart" "app_coldstart_time" {
  name = "App Metrics - Coldstart time ms (P75)"

  program_text = <<-EOF
        app_coldstart_time = data('rum.cold_start.time.ns.p75', filter=filter('app.version', '*')).scale(0.000001).mean(by=['app']).publish(label='app_coldstart_time')
        EOF

  time_range = 3600

  plot_type         = "LineChart"
  show_data_markers = true

  legend_options_fields {
    property = "app.version"
    enabled  = true
  }

  legend_options_fields {
    property = "app"
    enabled  = true
  }  

}