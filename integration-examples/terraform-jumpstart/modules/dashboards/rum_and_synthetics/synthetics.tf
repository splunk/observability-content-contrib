# signalfx_text_chart.synthetics_0:
resource "signalfx_text_chart" "synthetics_0" {
    markdown = <<-EOF
        <table width="100%" rules="none">
        <tbody><tr>
        <td align="left" bgcolor="#ed0080" height="80px">
        <font size="5" color="#ffffff">Splunk Real Browser Metrics</font>
        </td>
        </tr>
        <tr>
        <td align="left" bgcolor="#d53a70" height="40px">
        <font size="3" color="#ffffff">Metrics from Transactional and Single URL Real Browser Tests (DNS, Connect, SSL, TTFB, Total Time etc.)</font>
        </td>
        </tr>
        </tbody></table>
    EOF
    name     = " "
}
# signalfx_time_chart.synthetics_1:
resource "signalfx_time_chart" "synthetics_1" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "DNS average (blue), % week-on-week growth (brown)"
    disable_sampling  = false
    name              = "DNS - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.first_request_dns_time_ms').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = false
    show_event_lines  = false
    stacked           = false
    time_range        = 604800
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        label          = "Time"
    }

    axis_right {
        label          = "WoW Growth (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "DNS"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Week on Week Growth (%)"
        label        = "C"
        value_suffix = "%"
    }
}
# signalfx_time_chart.synthetics_2:
resource "signalfx_time_chart" "synthetics_2" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "Connect Time (blue), % week-on-week growth (brown)"
    disable_sampling  = false
    name              = "Connect - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.first_request_connect_time_ms', extrapolation='last_value').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = false
    show_event_lines  = false
    stacked           = false
    time_range        = 604800
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        label          = "Time"
    }

    axis_right {
        label          = "WoW Growth (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "Connect"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Week on Week Growth (%)"
        label        = "C"
        value_unit   = "Millisecond"
    }
}
# signalfx_time_chart.synthetics_3:
resource "signalfx_time_chart" "synthetics_3" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "Average SSL (blue), % week-on-week growth (brown)"
    disable_sampling  = false
    name              = "SSL - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.first_request_ssl_time_ms').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = false
    show_event_lines  = false
    stacked           = false
    time_range        = 604800
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        label          = "Time"
    }

    axis_right {
        label          = "WoW Growth (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "SSL"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Week on Week Growth (%)"
        label        = "C"
        value_unit   = "Millisecond"
    }
}
# signalfx_text_chart.synthetics_4:
resource "signalfx_text_chart" "synthetics_4" {
    markdown = <<-EOF
        The chart above shows DNS time.
        
        Metric(s):
        <code>synthetics.real_browser.first_request_dns_time_ms</code>
        
        Time required to resolve the domain name into an IP address.
    EOF
    name     = "DNS - Info"
}
# signalfx_text_chart.synthetics_5:
resource "signalfx_text_chart" "synthetics_5" {
    markdown = <<-EOF
        The chart above shows TCP Connect Time.
        
        Metric(s):
        <code>synthetics.real_browser.first_request_connect_time_ms</code>
        
        The time required to establish the TCP connection with the IP address of the resolved domain name.
    EOF
    name     = "TCP Connect Time - Info"
}
# signalfx_text_chart.synthetics_6:
resource "signalfx_text_chart" "synthetics_6" {
    markdown = <<-EOF
        The chart above shows average SSL time.
        
        Metric(s):
        <code>synthetics.real_browser.first_request_ssl_time_ms</code>
        
        The time it took to establish the SSL handshake with the primary URL.
    EOF
    name     = "SSL - Info"
}
# signalfx_time_chart.synthetics_7:
resource "signalfx_time_chart" "synthetics_7" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "TTFB Time (blue), % week-on-week growth (brown)"
    disable_sampling  = false
    name              = "TTFB - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.first_byte_time_ms').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = false
    show_event_lines  = false
    stacked           = false
    time_range        = 604800
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        label          = "Time"
    }

    axis_right {
        label          = "WoW Growth (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "TTFB"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Week on Week Growth (%)"
        label        = "C"
        value_unit   = "Millisecond"
    }
}
# signalfx_time_chart.synthetics_8:
resource "signalfx_time_chart" "synthetics_8" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "Average Total Time (blue), % week-on-week growth (brown)"
    disable_sampling  = false
    name              = "Fully Loaded Time - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.fully_loaded_time_ms').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = true
    show_event_lines  = false
    stacked           = false
    time_range        = 86400
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        high_watermark       = 2000
        high_watermark_label = "Recommended Fully Loaded Time"
        label                = "Time"
    }

    axis_right {
        label          = "WoW Growth (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "Total Time"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Week on Week Growth (%)"
        label        = "C"
        value_unit   = "Millisecond"
    }
}
# signalfx_time_chart.synthetics_9:
resource "signalfx_time_chart" "synthetics_9" {
    axes_include_zero = false
    axes_precision    = 3
    color_by          = "Dimension"
    description       = "Bytes Downloaded (blue), % Change Over Previous Day (%) (brown)"
    disable_sampling  = false
    name              = "Total Content Size - Trend"
    plot_type         = "LineChart"
    program_text      = <<-EOF
        A = data('synthetics.real_browser.content_bytes').mean().publish(label='A')
        B = (A).mean().timeshift('1d').publish(label='B', enable=False)
        C = ((A-B)/B).scale(100).publish(label='C')
    EOF
    show_data_markers = false
    show_event_lines  = false
    stacked           = false
    time_range        = 604800
    timezone          = "UTC"
    unit_prefix       = "Metric"

    axis_left {
        label          = "Bytes"
    }

    axis_right {
        label          = "Change Over Previous Day (%)"
    }

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        display_name = "B"
        label        = "B"
    }
    viz_options {
        axis         = "left"
        color        = "green"
        display_name = "Bytes Downloaded"
        label        = "A"
        value_unit   = "Byte"
    }
    viz_options {
        axis         = "right"
        color        = "purple"
        display_name = "Change Over Previous Day (%)"
        label        = "C"
        value_unit   = "Byte"
    }
}
# signalfx_text_chart.synthetics_10:
resource "signalfx_text_chart" "synthetics_10" {
    markdown = <<-EOF
        The chart above shows TTFB.
        
        Metric(s):
        <code>synthetics.real_browser.first_byte_time_ms</code>
        
        The time it took from the request being issued to receiving the first byte of data from the primary URL for the test(s). This is calculated as DNS + Connect + SSL + Send + Wait. For tests where the primary URL has a redirect chain, TTFB is calculated as the sum of the TTFB for each domain in the redirect chain.
    EOF
    name     = "TTFB - Info"
}
# signalfx_text_chart.synthetics_11:
resource "signalfx_text_chart" "synthetics_11" {
    markdown = <<-EOF
        The chart above shows Total Time.
        
        Metric(s):
        <code>synthetics.real_browser.fully_loaded_time_ms</code>
        
        The total time it took for the test to complete.
    EOF
    name     = "Total Time - Info"
}
# signalfx_text_chart.synthetics_12:
resource "signalfx_text_chart" "synthetics_12" {
    markdown = <<-EOF
        The chart above shows Bytes downloaded.
        
        Metric(s):
        <code>synthetics.real_browser.content_bytes</code>
        
        The file size in bytes of the response received for the primary URL of the test(s).
    EOF
    name     = "Bytes Downloaded - Info"
}
# signalfx_dashboard.synthetics:
resource "signalfx_dashboard" "synthetics" {
    charts_resolution = "default"
    dashboard_group = signalfx_dashboard_group.rumandsynthetics.id
    name              = "Synthetics"
    time_range        = "-1w"

    chart {
        chart_id = signalfx_time_chart.synthetics_9.id
        column   = 8
        height   = 1
        row      = 3
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_4.id
        column   = 0
        height   = 1
        row      = 2
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_11.id
        column   = 4
        height   = 1
        row      = 4
        width    = 4
    }
    chart {
        chart_id = signalfx_time_chart.synthetics_2.id
        column   = 4
        height   = 1
        row      = 1
        width    = 4
    }
    chart {
        chart_id = signalfx_time_chart.synthetics_7.id
        column   = 0
        height   = 1
        row      = 3
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_6.id
        column   = 8
        height   = 1
        row      = 2
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_5.id
        column   = 4
        height   = 1
        row      = 2
        width    = 4
    }
    chart {
        chart_id = signalfx_time_chart.synthetics_8.id
        column   = 4
        height   = 1
        row      = 3
        width    = 4
    }
    chart {
        chart_id = signalfx_time_chart.synthetics_3.id
        column   = 8
        height   = 1
        row      = 1
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_12.id
        column   = 8
        height   = 1
        row      = 4
        width    = 4
    }
    chart {
        chart_id = signalfx_time_chart.synthetics_1.id
        column   = 0
        height   = 1
        row      = 1
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_10.id
        column   = 0
        height   = 1
        row      = 4
        width    = 4
    }
    chart {
        chart_id = signalfx_text_chart.synthetics_0.id
        column   = 0
        height   = 1
        row      = 0
        width    = 12
    }

    variable {
        alias                  = "Check"
        apply_if_exist         = false
        property               = "check"
        replace_only           = false
        restricted_suggestions = false
        value_required         = false
        values                 = [
            "Colonial-Life-Homepage-Desktop",
            "Colonial-Life-Homepage-Mobile",
            "MyUNUM-Portal-Desktop",
        ]
        values_suggested       = []
    }
    variable {
        alias                  = "Country"
        apply_if_exist         = false
        property               = "country"
        replace_only           = false
        restricted_suggestions = false
        value_required         = false
        values                 = []
        values_suggested       = []
    }
}