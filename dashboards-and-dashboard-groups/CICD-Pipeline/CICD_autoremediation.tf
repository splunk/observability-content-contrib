provider "signalfx" {
  api_url    = "https://api.${var.realm}.signalfx.com"
  auth_token = var.access_token
}

# signalfx_event_feed_chart.CICD_autoremediation_0:
resource "signalfx_event_feed_chart" "CICD_autoremediation_0" {
  name         = "Event Feed"
  program_text = <<-EOF
        C = events(eventType='Automated Rollback initiated').publish(label='C')
        B = events(eventType='canary push event').publish(label='B')
        A = alerts(detector_name='CI/CD Service Outlier').publish(label='A')
    EOF
  time_range   = 900
}
# signalfx_single_value_chart.CICD_autoremediation_1:
resource "signalfx_single_value_chart" "CICD_autoremediation_1" {
  color_by                = "Scale"
  is_timestamp_hidden     = true
  max_delay               = 0
  max_precision           = 0
  name                    = "Platinum Response Time SLA"
  program_text            = "A = data('requests.latency', filter=filter('user', '*')).percentile(pct=99, by=['user']).max(by=['user']).publish(label='A')"
  refresh_interval        = 1
  secondary_visualization = "Radial"
  show_spark_line         = false
  unit_prefix             = "Metric"

  color_scale {
    color = "light_green"
    gt    = 100
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 200
  }
  color_scale {
    color = "lime_green"
    gt    = 340282346638528860000000000000000000000
    gte   = 0
    lt    = 340282346638528860000000000000000000000
    lte   = 100
  }
  color_scale {
    color = "red"
    gt    = 700
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 1000
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 200
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 300
  }
  color_scale {
    color = "yellow"
    gt    = 300
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 700
  }

  viz_options {
    display_name = "requests.latency - P99 by user - Maximum by user"
    label        = "A"
    value_unit   = "Millisecond"
  }
}
# signalfx_time_chart.CICD_autoremediation_2:
resource "signalfx_time_chart" "CICD_autoremediation_2" {
  axes_include_zero         = false
  axes_precision            = 0
  color_by                  = "Dimension"
  disable_sampling          = false
  minimum_resolution        = 0
  name                      = "Requests processed per container"
  on_chart_legend_dimension = "containerId"
  plot_type                 = "AreaChart"
  program_text              = "A = data('requests.processed', filter=filter('user', '*'), rollup='latest', extrapolation='last_value', maxExtrapolations=1).sum(by=['containerId']).publish(label='A')"
  show_data_markers         = false
  show_event_lines          = true
  stacked                   = true
  time_range                = 300
  unit_prefix               = "Metric"

  histogram_options {
    color_theme = "red"
  }

  viz_options {
    axis         = "left"
    display_name = "requests.processed - Sum by containerId"
    label        = "A"
  }
}
# signalfx_list_chart.CICD_autoremediation_3:
resource "signalfx_list_chart" "CICD_autoremediation_3" {
  color_by                = "Dimension"
  disable_sampling        = false
  hide_missing_values     = false
  max_precision           = 0
  name                    = "Requests Latency per Merchant"
  program_text            = "A = data('requests.latency', filter=filter('user', '*'), rollup='latest').top(count=6).publish(label='A')"
  refresh_interval        = 1
  secondary_visualization = "Sparkline"
  sort_by                 = "-value"
  time_range              = 300
  unit_prefix             = "Metric"

  legend_options_fields {
    enabled  = true
    property = "containerId"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = false
    property = "user"
  }
  legend_options_fields {
    enabled  = true
    property = "customer"
  }

  viz_options {
    display_name = "requests.latency - Top 6"
    label        = "A"
    value_unit   = "Millisecond"
  }
}
# signalfx_heatmap_chart.CICD_autoremediation_4:
resource "signalfx_heatmap_chart" "CICD_autoremediation_4" {
  disable_sampling   = true
  group_by           = []
  hide_timestamp     = false
  max_delay          = 10
  minimum_resolution = 0
  name               = "Authorization - Requests processed per container"
  program_text       = "A = data('requests.processed', filter=filter('user', '*'), rollup='latest').above(0).publish(label='A')"
  refresh_interval   = 5
  sort_by            = "+host.name"
  unit_prefix        = "Metric"

  color_scale {
    color = "light_green"
    gt    = 800
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 900
  }
  color_scale {
    color = "lime_green"
    gt    = 900
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "red"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 600
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 700
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 800
  }
  color_scale {
    color = "yellow"
    gt    = 600
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 700
  }
}
# signalfx_single_value_chart.CICD_autoremediation_5:
resource "signalfx_single_value_chart" "CICD_autoremediation_5" {
  color_by                = "Scale"
  is_timestamp_hidden     = false
  max_delay               = 0
  max_precision           = 0
  name                    = "Requests per second"
  program_text            = "A = data('requests.processed', filter=filter('user', '*')).sum().publish(label='A')"
  refresh_interval        = 1
  secondary_visualization = "Sparkline"
  show_spark_line         = false
  unit_prefix             = "Metric"

  color_scale {
    color = "lime_green"
    gt    = 2700
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "red"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 2600
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 2600
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 2700
  }

  viz_options {
    display_name = "requests.processed - Sum"
    label        = "A"
  }
}
# signalfx_time_chart.CICD_autoremediation_6:
resource "signalfx_time_chart" "CICD_autoremediation_6" {
  axes_include_zero  = false
  axes_precision     = 0
  color_by           = "Dimension"
  disable_sampling   = false
  max_delay          = 5
  minimum_resolution = 0
  name               = "Overall requests processed"
  plot_type          = "LineChart"
  program_text       = "A = data('requests.processed', filter=filter('user', '*'), rollup='latest', extrapolation='last_value', maxExtrapolations=2).sum().publish(label='A')"
  show_data_markers  = false
  show_event_lines   = true
  stacked            = false
  time_range         = 300
  unit_prefix        = "Metric"

  axis_left {
    high_watermark       = 3400
    high_watermark_label = "high"
    low_watermark        = 2000
    low_watermark_label  = "low"
  }

  histogram_options {
    color_theme = "red"
  }

  viz_options {
    axis         = "left"
    display_name = "requests.processed - Sum"
    label        = "A"
  }
}
# signalfx_time_chart.CICD_autoremediation_7:
resource "signalfx_time_chart" "CICD_autoremediation_7" {
  axes_include_zero  = false
  axes_precision     = 0
  color_by           = "Dimension"
  disable_sampling   = false
  max_delay          = 5
  minimum_resolution = 0
  name               = "Requests Latency per Merchant"
  plot_type          = "AreaChart"
  program_text       = "A = data('requests.latency', filter=filter('user', '*'), rollup='latest', extrapolation='last_value', maxExtrapolations=1).top(count=6).publish(label='A')"
  show_data_markers  = false
  show_event_lines   = true
  stacked            = true
  time_range         = 300
  unit_prefix        = "Metric"

  histogram_options {
    color_theme = "red"
  }

  legend_options_fields {
    enabled  = true
    property = "containerId"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = false
    property = "user"
  }
  legend_options_fields {
    enabled  = true
    property = "customer"
  }
  legend_options_fields {
    enabled  = true
    property = "canary"
  }

  viz_options {
    axis         = "left"
    display_name = "requests.latency - Top 6"
    label        = "A"
    value_unit   = "Millisecond"
  }
}
# signalfx_single_value_chart.CICD_autoremediation_8:
resource "signalfx_single_value_chart" "CICD_autoremediation_8" {
  color_by                = "Scale"
  is_timestamp_hidden     = false
  max_delay               = 5
  max_precision           = 3
  name                    = "Peak Request Latency (last 10s)"
  program_text            = "A = data('requests.latency', filter=filter('user', '*'), rollup='latest', extrapolation='last_value', maxExtrapolations=1).max(over='10s').max().publish(label='A')"
  refresh_interval        = 1
  secondary_visualization = "None"
  show_spark_line         = false
  unit_prefix             = "Metric"

  color_scale {
    color = "lime_green"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 200
  }
  color_scale {
    color = "red"
    gt    = 700
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 200
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 700
  }

  viz_options {
    display_name = "requests.latency - Maximum(10s) - Maximum"
    label        = "A"
    value_unit   = "Millisecond"
  }
}
# signalfx_log_view.CICD_autoremediation_9:
resource "signalfx_log_view" "CICD_autoremediation_9" {
  default_connection = "o11y-suite-us1.stg.splunkcloud.com"
  name               = "CI/CD Logs"
  program_text       = "logs(index='o11y-demo-us', filter=field('user') == '${var.username}').publish()"
  time_range         = 900

  columns {
    name = "severity"
  }
  columns {
    name = "time"
  }
  columns {
    name = "_raw"
  }
}
# signalfx_dashboard.CICD_autoremediation:
resource "signalfx_dashboard" "CICD_autoremediation" {
  charts_resolution = "default"
  dashboard_group   = var.dashboard_group
  name              = "CI/CD - Autoremediation"
  time_range        = "-3m"

  chart {
    chart_id = signalfx_single_value_chart.CICD_autoremediation_5.id
    column   = 2
    height   = 1
    row      = 1
    width    = 2
  }
  chart {
    chart_id = signalfx_time_chart.CICD_autoremediation_7.id
    column   = 7
    height   = 1
    row      = 1
    width    = 3
  }
  chart {
    chart_id = signalfx_single_value_chart.CICD_autoremediation_1.id
    column   = 2
    height   = 1
    row      = 0
    width    = 2
  }
  chart {
    chart_id = signalfx_event_feed_chart.CICD_autoremediation_0.id
    column   = 0
    height   = 2
    row      = 0
    width    = 2
  }
  chart {
    chart_id = signalfx_single_value_chart.CICD_autoremediation_8.id
    column   = 10
    height   = 1
    row      = 1
    width    = 2
  }
  chart {
    chart_id = signalfx_time_chart.CICD_autoremediation_2.id
    column   = 4
    height   = 1
    row      = 0
    width    = 3
  }
  chart {
    chart_id = signalfx_heatmap_chart.CICD_autoremediation_4.id
    column   = 10
    height   = 1
    row      = 0
    width    = 2
  }
  chart {
    chart_id = signalfx_list_chart.CICD_autoremediation_3.id
    column   = 7
    height   = 1
    row      = 0
    width    = 3
  }
  chart {
    chart_id = signalfx_time_chart.CICD_autoremediation_6.id
    column   = 4
    height   = 1
    row      = 1
    width    = 3
  }
  chart {
    chart_id = signalfx_log_view.CICD_autoremediation_9.id
    column   = 0
    height   = 3
    row      = 2
    width    = 12
  }

  # permissions {
  #     parent = "Fw0O4zIA4AE"
  # }j

  selected_event_overlay {
    signal = "canary push event"
    type   = "eventTimeSeries"
  }
  selected_event_overlay {
    signal = "Automated Rollback initiated"
    type   = "eventTimeSeries"
  }
  selected_event_overlay {
    signal = "CI/CD Service Outlier US"
    type   = "detectorEvents"
  }

  variable {
    alias                  = "Username"
    apply_if_exist         = false
    property               = "user"
    replace_only           = false
    restricted_suggestions = false
    value_required         = true
    values = [
      "${var.username}",
    ]
    values_suggested = []
  }
}