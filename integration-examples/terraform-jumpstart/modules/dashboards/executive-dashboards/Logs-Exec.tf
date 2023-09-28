
# signalfx_dashboard.Logs-Exec:
resource "signalfx_dashboard" "Logs-Exec" {
    depends_on = [signalfx_dashboard.APM_IMM-Exec]
    charts_resolution = "default"
    dashboard_group   = signalfx_dashboard_group.exec_dashboard_group.id
    description       = "Log Observer Executive Dashboard"
    name              = "Logs - Exec"
    time_range        = "-31d"

    chart {
        chart_id = signalfx_list_chart.Logs-Exec_6.id
        column   = 9
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.Logs-Exec_5.id
        column   = 6
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.Logs-Exec_0.id
        column   = 0
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.Logs-Exec_1.id
        column   = 3
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.Logs-Exec_3.id
        column   = 9
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.Logs-Exec_2.id
        column   = 6
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_time_chart.Logs-Exec_7.id
        column   = 0
        height   = 2
        row      = 3
        width    = 6
    }

}

# signalfx_list_chart.Logs-Exec_0:
resource "signalfx_list_chart" "Logs-Exec_0" {
    color_by                = "Dimension"
    description             = "Logs Received per Day by Token Top 5 (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Logs Received per Day by Token"
    program_text            = "C = data('sf.org.numLogsReceivedByToken', rollup='sum').sum(by=['tokenName']).mean(over='7d').sum(over='1d').top(count=5).publish(label='C')"
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "orgId"
    }
    legend_options_fields {
        enabled  = false
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "severity"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ruleId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_derived_from"
    }
    legend_options_fields {
        enabled  = false
        property = "deployment.environment"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenName"
    }

    viz_options {
        display_name = "Events Received"
        label        = "C"
    }
}
# signalfx_list_chart.Logs-Exec_1:
resource "signalfx_list_chart" "Logs-Exec_1" {
    color_by                = "Metric"
    description             = "Logs Received per Day by Token Top & Bottom 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Logs Received per Day by Token 12 week comparison"
    program_text            = <<-EOF
        A = data('sf.org.numLogsReceivedByToken').sum(by=['tokenName']).mean(over='7d').sum(over='1d').publish(label='A', enable=False)
        B = data('sf.org.numLogsReceivedByToken').sum(by=['tokenName']).timeshift('12w').mean(over='7d').sum(over='1d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['tokenName']).mean(over='7d').fill(0).top(5).publish(label='C')
        D = (((A-B)/B)*100).mean(by=['tokenName']).mean(over='7d').fill(0).bottom(5).publish(label='D')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "check"
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
        property = "world_region"
    }
    legend_options_fields {
        enabled  = false
        property = "country"
    }
    legend_options_fields {
        enabled  = false
        property = "location"
    }
    legend_options_fields {
        enabled  = false
        property = "position"
    }
    legend_options_fields {
        enabled  = true
        property = "status"
    }
    legend_options_fields {
        enabled  = false
        property = "severity"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenName"
    }

    viz_options {
        display_name = "Log Events by Token (Top)"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Log Events by Token (Bottom)"
        label        = "D"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "A"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "B"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.Logs-Exec_2:
resource "signalfx_list_chart" "Logs-Exec_2" {
    color_by                = "Dimension"
    description             = "Profiling Logs Received per Day by Token Top 5 (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Profiling Logs Received per Day by Token"
    program_text            = "C = data('sf.org.profiling.numLogsReceivedByToken', rollup='sum').sum(by=['tokenName']).mean(over='7d').sum(over='1d').top(count=5).publish(label='C')"
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "orgId"
    }
    legend_options_fields {
        enabled  = false
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "severity"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ruleId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_derived_from"
    }
    legend_options_fields {
        enabled  = false
        property = "deployment.environment"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenName"
    }

    viz_options {
        display_name = "Events Received"
        label        = "C"
    }
}
# signalfx_list_chart.Logs-Exec_3:
resource "signalfx_list_chart" "Logs-Exec_3" {
    color_by                = "Metric"
    description             = "Logs Profiling Logs Received per Day by Token Top & Bottom 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Profiling Logs Received per Day by Token 12 week comparison"
    program_text            = <<-EOF
        A = data('sf.org.profiling.numLogsReceivedByToken').sum(by=['tokenName']).mean(over='7d').sum(over='1d').publish(label='A', enable=False)
        B = data('sf.org.profiling.numLogsReceivedByToken').sum(by=['tokenName']).timeshift('12w').mean(over='7d').sum(over='1d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['tokenName']).mean(over='7d').fill(0).top(5).publish(label='C')
        D = (((A-B)/B)*100).mean(by=['tokenName']).mean(over='7d').fill(0).bottom(5).publish(label='D')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "check"
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
        property = "world_region"
    }
    legend_options_fields {
        enabled  = false
        property = "country"
    }
    legend_options_fields {
        enabled  = false
        property = "location"
    }
    legend_options_fields {
        enabled  = false
        property = "position"
    }
    legend_options_fields {
        enabled  = true
        property = "status"
    }
    legend_options_fields {
        enabled  = false
        property = "severity"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenName"
    }

    viz_options {
        display_name = "Log Events by Token Bottom"
        label        = "D"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Log Events by Token Top"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "A"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "B"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.Logs-Exec_5:
resource "signalfx_list_chart" "Logs-Exec_5" {
    color_by                = "Dimension"
    description             = "Events per Day by Log Level (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Events per Day by Log Level"
    program_text            = <<-EOF
        C = data('logs.events.count', rollup='sum').sum(by=['severity'], allow_missing=['severity']).mean(over='7d').sum(over='1d').publish(label='C')
        D = data('log_entry_count', rollup='sum').sum(by=['severity'], allow_missing=['severity']).mean(over='7d').sum(over='1d').publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "orgId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "severity"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ruleId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_derived_from"
    }
    legend_options_fields {
        enabled  = false
        property = "deployment.environment"
    }

    }
# signalfx_list_chart.Logs-Exec_6:
resource "signalfx_list_chart" "Logs-Exec_6" {
    color_by                = "Dimension"
    description             = "Logs Events per Day by Log Level (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Events per Day by Log Level 12 week comparison"
    program_text            = <<-EOF
        A = data('logs.events.count').sum(by=['severity'], allow_missing=['severity']).mean(over='7d').sum(over='1d').publish(label='A', enable=False)
        B = data('logs.events.count').sum(by=['severity'], allow_missing=['severity']).timeshift('12w').mean(over='7d').sum(over='1d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['severity'], allow_missing=['severity']).mean(over='7d').publish(label='C')

        D = data('log_entry_count').sum(by=['severity'], allow_missing=['severity']).mean(over='7d').sum(over='1d').publish(label='D', enable=False)
        E = data('log_entry_count').sum(by=['severity'], allow_missing=['severity']).timeshift('12w').mean(over='7d').sum(over='1d').publish(label='E', enable=False)
        F = (((D-E)/E)*100).mean(by=['severity'], allow_missing=['severity']).mean(over='7d').publish(label='F')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "check"
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
        enabled  = true
        property = "world_region"
    }
    legend_options_fields {
        enabled  = true
        property = "country"
    }
    legend_options_fields {
        enabled  = true
        property = "location"
    }
    legend_options_fields {
        enabled  = true
        property = "position"
    }
    legend_options_fields {
        enabled  = true
        property = "status"
    }
    legend_options_fields {
        enabled  = true
        property = "severity"
    }

    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "F"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "A"
    }
    viz_options {
        display_name = "rum.webvitals_fid.time.ns.p75 - Sum by sf_ua_browsername"
        label        = "B"
    }
}
# signalfx_time_chart.Logs-Exec_7:
resource "signalfx_time_chart" "Logs-Exec_7" {
    axes_include_zero  = false
    axes_precision     = 0
    color_by           = "Dimension"
    description        = "Events Received per Day by Log Level (7 day avg)"
    disable_sampling   = false
    max_delay          = 0
    minimum_resolution = 0
    name               = "Events Received per Day by Log Level"
    plot_type          = "AreaChart"
    program_text       = <<-EOF
        C = data('logs.events.count', rollup='sum').sum(by=['severity'], allow_missing=['severity']).sum(over='1d').mean(over='7d').publish(label='Event Count')
        B = data('log_entry_count', rollup='sum').sum(by=['severity'], allow_missing=['severity']).sum(over='1d').mean(over='7d').publish(label='Entry Count')
    EOF
    show_data_markers  = false
    show_event_lines   = false
    stacked            = true
    time_range         = 900
    unit_prefix        = "Metric"

    histogram_options {
        color_theme = "red"
    }

    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "orgId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "severity"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ruleId"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_derived_from"
    }
    legend_options_fields {
        enabled  = false
        property = "deployment.environment"
    }

    viz_options {
        axis         = "left"
        display_name = "Event Count"
        label        = "Event Count"
    }
}