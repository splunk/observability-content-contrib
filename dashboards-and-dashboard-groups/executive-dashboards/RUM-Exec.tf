# signalfx_dashboard.RUM-Exec:
resource "signalfx_dashboard" "RUM-Exec" {
    depends_on = [signalfx_dashboard.Logs-Exec]
    charts_resolution = "default"
    dashboard_group   = signalfx_dashboard_group.exec_dashboard_group.id
    name              = "RUM - Exec"
    time_range        = "-140d"

    chart {
        chart_id = signalfx_list_chart.RUM-Exec_7.id
        column   = 9
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_3.id
        column   = 9
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_8.id
        column   = 0
        height   = 2
        row      = 4
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_10.id
        column   = 6
        height   = 2
        row      = 4
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_2.id
        column   = 6
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_4.id
        column   = 0
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_5.id
        column   = 3
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_9.id
        column   = 3
        height   = 2
        row      = 4
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_6.id
        column   = 6
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_0.id
        column   = 0
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.RUM-Exec_1.id
        column   = 3
        height   = 2
        row      = 0
        width    = 3
    }

}

# signalfx_list_chart.RUM-Exec_0:
resource "signalfx_list_chart" "RUM-Exec_0" {
    color_by                = "Dimension"
    description             = "Browser Request count change (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Browser Request 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.page_view.count', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.page_view.count', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').timeshift('12w').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['sf_ua_browsername']).mean(over='7d').publish(label='C')
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
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.page_view.count - Mean by sf_ua_browsername - Mean(7d)"
        label        = "A"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.RUM-Exec_1:
resource "signalfx_list_chart" "RUM-Exec_1" {
    color_by                = "Dimension"
    description             = "Browser Errors count change (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Errors Request 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.client_error.count', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.client_error.count', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').timeshift('12w').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['sf_ua_browsername']).mean(over='7d').publish(label='C')
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
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.client_error.count - Mean by sf_ua_browsername - Mean(7d)"
        label        = "A"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.RUM-Exec_2:
resource "signalfx_list_chart" "RUM-Exec_2" {
    color_by                = "Dimension"
    description             = "Browser Latency change (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Browser Latency 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.page_view.time.ns.p75', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').scale(0.000001).publish(label='A', enable=False)
        B = data('rum.page_view.time.ns.p75', filter=filter('sf_ua_browsername', '*')).mean(by=['sf_ua_browsername']).mean(over='7d').timeshift('12w').scale(0.000001).publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['sf_ua_browsername']).mean(over='7d').publish(label='C')
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
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.page_view.time.ns.p75 - Mean by sf_ua_browsername - Mean(7d) - Scale:0.000001"
        label        = "A"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.RUM-Exec_3:
resource "signalfx_list_chart" "RUM-Exec_3" {
    color_by                = "Metric"
    description             = "Web Vitals Monthly Averages"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Web Vitals"
    program_text            = <<-EOF
        A = data('rum.webvitals_fid.time.ns.p75').scale(0.000001).mean(cycle='month', cycle_start='1d', partial_values=True).mean().publish(label='A')
        B = data('rum.webvitals_lcp.time.ns.p75').scale(0.000001).mean(cycle='month', cycle_start='1d', partial_values=True).mean().publish(label='B')
        C = data('rum.webvitals_cls.score.p75').mean(cycle='month', cycle_start='1d', partial_values=True).mean().publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-sf_metric"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_metric"
    }

    viz_options {
        display_name = "Cumulative Layout Shift (1mo)"
        label        = "C"
        value_suffix = "pixels"
    }
    viz_options {
        display_name = "First Input Delay P75 (1mo)"
        label        = "A"
        value_unit   = "Millisecond"
    }
    viz_options {
        display_name = "Largest Contentful Paint P75 (1mo)"
        label        = "B"
        value_unit   = "Millisecond"
    }
}
# signalfx_list_chart.RUM-Exec_4:
resource "signalfx_list_chart" "RUM-Exec_4" {
    color_by                = "Dimension"
    description             = "Request rate by App and Version Top 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM App Request rate 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.workflow.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.workflow.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').top(count=5).publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "app"
    }
    legend_options_fields {
        enabled  = true
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = false
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_5:
resource "signalfx_list_chart" "RUM-Exec_5" {
    color_by                = "Dimension"
    description             = "Request Errors by App and Version Top 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM App Errors 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.app_error.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.app_error.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').top(count=5).publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "app"
    }
    legend_options_fields {
        enabled  = true
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = false
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_6:
resource "signalfx_list_chart" "RUM-Exec_6" {
    color_by                = "Dimension"
    description             = "Latency change by App and Version Top 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM App Latency 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.workflow.time.ns.p75', filter=filter('sf_environment', '*')).mean(by=['app']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.workflow.time.ns.p75', filter=filter('sf_environment', '*')).mean().timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['app', 'app.version']).mean(over='7d').top(count=5).publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "+value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "app"
    }
    legend_options_fields {
        enabled  = true
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = false
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_7:
resource "signalfx_list_chart" "RUM-Exec_7" {
    color_by                = "Dimension"
    description             = "Crash Count by App and Version Top 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "App Crash Count 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.crash.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.crash.count', rollup='rate').sum(by=['app', 'app.version'], allow_missing=['app', 'app.version']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['app', 'app.version'], allow_missing=['app', 'app.version']).mean(over='7d').top(count=5).publish(label='C')
    EOF
    secondary_visualization = "None"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "app"
    }
    legend_options_fields {
        enabled  = true
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = false
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_8:
resource "signalfx_list_chart" "RUM-Exec_8" {
    color_by                = "Metric"
    description             = "Workflow rate Top and Bottom 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Workflow rate 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.workflow.count', filter=filter('sf_environment', '*') and filter('workflow.name', '*'), rollup='rate').sum(by=['workflow.name']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.workflow.count', filter=filter('sf_environment', '*') and filter('workflow.name', '*'), rollup='rate').sum(by=['workflow.name']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['workflow.name']).mean(over='7d').top(count=5).publish(label='C')
        D = (((A-B)/B)*100).mean(by=['workflow.name']).mean(over='7d').bottom(count=5).publish(label='D')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "app"
    }
    legend_options_fields {
        enabled  = false
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = true
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "D"
        label        = "D"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_9:
resource "signalfx_list_chart" "RUM-Exec_9" {
    color_by                = "Dimension"
    description             = "Workflow Errors Top and Bottom 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Workflow Errors 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.workflow.count', filter=filter('sf_environment', '*') and filter('workflow.name', '*') and filter('sf_error', 'true'), rollup='rate').sum(by=['workflow.name']).mean(over='7d').publish(label='A', enable=False)
        
        
        B = data('rum.workflow.count', filter=filter('sf_environment', '*') and filter('workflow.name', '*') and filter('sf_error', 'true'), rollup='rate').sum(by=['workflow.name']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        
        
        C = (((B-A)/A)*100).mean(by=['workflow.name']).mean(over='7d').top(count=5).publish(label='C')
    EOF
    secondary_visualization = "None"
    sort_by                 = "-value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "app"
    }
    legend_options_fields {
        enabled  = false
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = true
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = true
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
# signalfx_list_chart.RUM-Exec_10:
resource "signalfx_list_chart" "RUM-Exec_10" {
    color_by                = "Metric"
    description             = "Workflow latency change Top and Bottom 5 (12 week comparison)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM Workflow Latency 12 week comparison"
    program_text            = <<-EOF
        A = data('rum.workflow.time.ns.p75', filter=filter('sf_environment', '*') and filter('workflow.name', '*')).mean(by=['workflow.name']).mean(over='7d').publish(label='A', enable=False)
        B = data('rum.workflow.time.ns.p75', filter=filter('sf_environment', '*') and filter('workflow.name', '*')).mean(by=['workflow.name']).timeshift('12w').mean(over='7d').publish(label='B', enable=False)
        C = (((A-B)/B)*100).mean(by=['workflow.name']).mean(over='7d').top(count=5).publish(label='C')
        D = (((A-B)/B)*100).mean(by=['workflow.name']).mean(over='7d').bottom(count=5).publish(label='D')
    EOF
    secondary_visualization = "None"
    sort_by                 = "+value"
    time_range              = 3600
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = false
        property = "app"
    }
    legend_options_fields {
        enabled  = false
        property = "app.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "net.host.connection.type"
    }
    legend_options_fields {
        enabled  = false
        property = "os.name"
    }
    legend_options_fields {
        enabled  = false
        property = "os.version"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_environment"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_error"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_node_type"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_operation"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_product"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_browsername"
    }
    legend_options_fields {
        enabled  = true
        property = "sf_ua_osname"
    }
    legend_options_fields {
        enabled  = true
        property = "workflow.name"
    }

    viz_options {
        display_name = "B"
        label        = "B"
    }
    viz_options {
        display_name = "C"
        label        = "C"
        value_suffix = "%"
    }
    viz_options {
        display_name = "D"
        label        = "D"
        value_suffix = "%"
    }
    viz_options {
        display_name = "rum.workflow.count - Sum by workflow.name"
        label        = "A"
    }
}
