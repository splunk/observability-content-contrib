resource "signalfx_text_chart" "title1" {
  name     = " "
  markdown = <<-EOF
    <table width="100%" rules="none">
    <tbody><tr>
    <td align="left" bgcolor="#0064b7" height="80px">
    <font size="5" color="#ffffff">MTS & Events Creation and Trend</font>
    </td>
    </tr>
    <tr>
    <td align="left" bgcolor="#0091ea" height="40px">
    <font size="3" color="#ffffff">Metrics about the Metric Time Series (MTS) and Event creation and trend.</font>
    </td>
    </tr>
    </tbody></table>
  EOF
}
resource "signalfx_single_value_chart" "mtscreationrate0" {
  name         = "Real-Time MTS Creation Rate"
  description  = "Number of metric time series created in last minute"
  program_text = <<-EOF
    A = data('sf.org.numMetricTimeSeriesCreated').sum().mean(over='1m').scale(60).publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " MTS/min"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "mtstrend0" {
  name         = "MTS Creation - Trend"
  description  = "MTS creation rate (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numMetricTimeSeriesCreated', extrapolation='zero').sum().scale(60).publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "MTS"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " MTS"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}

resource "signalfx_text_chart" "mtsinfo0" {
  name     = "MTS Creation Rate - Info"
  markdown = <<-EOF
    Metric(s):
    <code>sf.org.numMetricTimeSeriesCreated</code>

    Number of new [metric time series](https://docs.signalfx.com/en/latest/concepts/data-model.html#time-series) (MTS) per minute in your organization.
  EOF
}
resource "signalfx_single_value_chart" "epm0" {
  name         = "Real-Time EPM"
  description  = "Number of events SignalFx received in last minute"
  program_text = <<-EOF
    A = data('sf.org.numEventsIngested').sum().mean(over='1m').scale(60).publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " EPM"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "epmtrend0" {
  name         = "EPM - Trend"
  description  = "EPM received (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numEventsIngested').mean(over='1m').scale(60).sum().publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "EPM"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " EPM"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "epminfo0" {
  name     = "EPM - Info"
  markdown = <<-EOF
    Metric(s):
    <code>sf.org.numEventsIngested</code>

    Total number of [events](https://docs.signalfx.com/en/latest/concepts/data-model.html#events-and-event-time-series) sent to SignalFx for your organization, minus any events that were not processed and stored due to limits exceeded.
  EOF
}

resource "signalfx_single_value_chart" "etscreationrate0" {
  name         = "Real-Time ETS Creation Rate"
  description  = "Number of event time series created in last minute"
  program_text = <<-EOF
    A = data('sf.org.numEventTimeSeriesCreated').sum().mean(over='1m').scale(60).publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " ETS/min"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "etstrend0" {
  name         = "ETS Creation - Trend"
  description  = "ETS creation rate (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numEventTimeSeriesCreated', extrapolation='zero').sum().scale(60).publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range   = 604800
  plot_type    = "LineChart"
  axis_left {
    label = "ETS"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " ETS"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "etsinfo0" {
  name     = "ETS Creation Rate - Info"
  markdown = <<-EOF
    Metric(s):
    <code>sf.org.numEventTimeSeriesCreated</code>

    Number of new [event time series](https://docs.signalfx.com/en/latest/concepts/data-model.html#events-and-event-time-series) (ETS) per minute in your organization.
  EOF
}

resource "signalfx_dashboard" "mtsevents" {
  name            = "MTS & Event Usage"
  dashboard_group = signalfx_dashboard_group.usageoverview.id

  time_range = "-1h"

  chart {
    chart_id = signalfx_text_chart.title1.id
    width    = 12
    height   = 1
    row      = 1
    column   = 0
  }

  chart {
    chart_id = signalfx_single_value_chart.mtscreationrate0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.epm0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 4
  }
  chart {
    chart_id = signalfx_single_value_chart.etscreationrate0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 8
  }

  chart {
    chart_id = signalfx_time_chart.mtstrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 0
  }
  chart {
    chart_id = signalfx_time_chart.epmtrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 4
  }
  chart {
    chart_id = signalfx_time_chart.etstrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 8
  }

  chart {
    chart_id = signalfx_text_chart.mtsinfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 0
  }
  chart {
    chart_id = signalfx_text_chart.epminfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 4
  }
  chart {
    chart_id = signalfx_text_chart.etsinfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 8
  }
}