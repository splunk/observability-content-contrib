resource "signalfx_text_chart" "title0" {
  name     = " "
  markdown = <<-EOF
    <table width="100%" rules="none">
    <tbody><tr>
    <td align="left" bgcolor="#7200ca" height="80px">
    <font size="5" color="#ffffff">Parent/Child Usage</font>
    </td>
    </tr>
    <tr>
    <td align="left" bgcolor="#aa00ff" height="40px">
    <font size="3" color="#ffffff">Metrics about the volume and nature of data that SignalFx is processing and storing for you, such as the number of hosts, containers, custom metrics and detectors in the last 10 minutes.</font>
    </td>
    </tr>
    </tbody></table>
  EOF
}
resource "signalfx_single_value_chart" "hostcount0" {
  name         = "Host Count"
  description  = "Number of Hosts SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    A = data('sf.org.child.numResourcesMonitored', filter=filter('resourceType', 'host')).sum().publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Hosts"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "hosttrend0" {
  name         = "Hosts Count - Trend"
  description  = "Host count (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.child.numResourcesMonitored', filter=filter('resourceType', 'host')).sum().publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "Hosts"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Hosts"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}

resource "signalfx_text_chart" "hostinfo0" {
  name     = "Host - Info"
  markdown = <<-EOF
    The chart above shows Host count.

    Metric(s):
    <code>sf.org.child.numResourcesMonitored</code>

    Filter(s):
    <code>resourceType:host</code>

    Number of Hosts being monitored in your organization(s).
  EOF
}
resource "signalfx_single_value_chart" "containercount0" {
  name         = "Container Count"
  description  = "Number of Containers SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    A = data('sf.org.child.numResourcesMonitored', filter=filter('resourceType', 'container')).sum().publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Containers"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "containertrend0" {
  name         = "Containers Count - Trend"
  description  = "Container count (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.child.numResourcesMonitored', filter=filter('resourceType', 'container')).mean(over='10m').sum().publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "Containers"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Containers"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "containerinfo0" {
  name     = "Container - Info"
  markdown = <<-EOF
    The chart above shows Container count.

    Metric(s):
    <code>sf.org.child.numResourcesMonitored</code>

    Filter(s):
    <code>resourceType:container</code>

    Number of Containers being monitored in your organization(s).
  EOF
}

resource "signalfx_single_value_chart" "custommetrics0" {
  name         = "Custom Metrics"
  description  = "Number of Custom Metrics SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    A = data('sf.org.child.numCustomMetrics').sum().publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Custom Metrics"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "custommetrictrend0" {
  name         = "Custom Metrics - Trend"
  description  = "Custom Metrics (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.child.numCustomMetrics').mean(over='10m').sum().publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "Custom Metrics"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Custom Metrics"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "custommetricinfo0" {
  name     = "Custom Metric - Info"
  markdown = <<-EOF
    The chart above shows Custom Metric count.

    Metric(s):
    <code>sf.org.child.numCustomMetrics</code>

    Number of Custom Metrics being monitored in your organization(s).
  EOF
}
resource "signalfx_single_value_chart" "detectors0" {
  name         = "Detector Count"
  description  = "Number of Detectors SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    A = data('sf.org.child.num.detector').sum().publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Detectors"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "detectortrend0" {
  name         = "Detector Count - Trend"
  description  = "Detector Count (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.child.num.detector').mean(over='10m').sum().publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "Detector Count"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Detectors"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "detectorinfo0" {
  name     = "Detector Count - Info"
  markdown = <<-EOF
    The chart above shows Detector count.

    Metric(s):
    <code>sf.org.child.num.detector</code>

    Number of Detectors created in your organization(s).
  EOF
}

resource "signalfx_dashboard" "childrenusage" {
  name            = "Parent/Child Usage"
  dashboard_group = signalfx_dashboard_group.parentchildoverview.id
  time_range      = "-1w"
  variable {
    alias                  = "Child Org"
    apply_if_exist         = false
    description            = "Child Org"
    property               = "childOrgName"
    replace_only           = false
    restricted_suggestions = false
    value_required         = false
    values = [
      "Choose Child Org",
    ]
    values_suggested = []
  }

  chart {
    chart_id = signalfx_text_chart.title0.id
    width    = 12
    height   = 1
    row      = 1
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.hostcount0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.containercount0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 3
  }
  chart {
    chart_id = signalfx_single_value_chart.custommetrics0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 6
  }
  chart {
    chart_id = signalfx_single_value_chart.detectors0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 9
  }
  chart {
    chart_id = signalfx_time_chart.hosttrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 0
  }
  chart {
    chart_id = signalfx_time_chart.containertrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 3
  }
  chart {
    chart_id = signalfx_time_chart.custommetrictrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 6
  }
  chart {
    chart_id = signalfx_time_chart.detectortrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 9
  }

  chart {
    chart_id = signalfx_text_chart.hostinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 0
  }
  chart {
    chart_id = signalfx_text_chart.containerinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 3
  }
  chart {
    chart_id = signalfx_text_chart.custommetricinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 6
  }
  chart {
    chart_id = signalfx_text_chart.detectorinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 9
  }
}