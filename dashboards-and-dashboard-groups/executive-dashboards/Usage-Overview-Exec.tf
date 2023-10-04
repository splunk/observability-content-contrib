# signalfx_dashboard.License-Exec:
resource "signalfx_dashboard" "Usage-Overview-Exec" {
    depends_on = [signalfx_dashboard.RUM-Exec]
    charts_resolution = "default"
    dashboard_group   = signalfx_dashboard_group.exec_dashboard_group.id
    description       = "Executive Level Dashboard for Overall Usage Metrics"
    name              = "License Usage Overview - Exec"
    time_range        = "-12w"

    chart {
        chart_id = signalfx_list_chart.License-Exec_10.id
        column   = 9
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_8.id
        column   = 0
        height   = 2
        row      = 4
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_9.id
        column   = 3
        height   = 2
        row      = 4
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_2.id
        column   = 6
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_0.id
        column   = 0
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_4.id
        column   = 0
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_5.id
        column   = 3
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_7.id
        column   = 6
        height   = 2
        row      = 2
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_3.id
        column   = 9
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_1.id
        column   = 3
        height   = 2
        row      = 0
        width    = 3
    }
    chart {
        chart_id = signalfx_list_chart.License-Exec_11.id
        column   = 6
        height   = 2
        row      = 4
        width    = 3
    }

}

# signalfx_list_chart.License-Exec_0:
resource "signalfx_list_chart" "License-Exec_0" {
    color_by                = "Dimension"
    description             = "APM - Hosts License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "APM - Hosts"
    program_text            = <<-EOF
        C = data('sf.org.apm.numContainers').mean(over='7d').publish(label='C')
        H = data('sf.org.apm.numHosts').mean(over='7d').publish(label='H')
        I = (C+H).publish(label='I')
        J = (C+H).timeshift('4w').publish(label='J', enable=False)
        K = (C+H).timeshift('12w').publish(label='K', enable=False)
        G = (((I-K)/K)*100).publish(label='G')
        F = (((I-J)/J)*100).publish(label='F')
    EOF
    secondary_visualization = "None"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = false
        property = "sf_originatingMetric"
    }
    legend_options_fields {
        enabled  = false
        property = "orgId"
    }

    viz_options {
        display_name = "12 Week Combined Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "12w Combined Hosts"
        label        = "K"
    }
    viz_options {
        display_name = "4 Week Combined Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4w Combined Hosts"
        label        = "J"
    }
    viz_options {
        display_name = "Current Combined Hosts"
        label        = "I"
    }
    viz_options {
        display_name = "Current Containers"
        label        = "C"
    }
    viz_options {
        display_name = "Current Hosts"
        label        = "H"
    }
}
# signalfx_list_chart.License-Exec_1:
resource "signalfx_list_chart" "License-Exec_1" {
    color_by                = "Dimension"
    description             = "APM - TPM Span Bytes License metric"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "APM - Span Bytes Received"
    program_text            = <<-EOF
        C = data('sf.org.apm.numSpanBytesReceived', rollup='sum').mean(over='7d').publish(label='C')
        D = data('sf.org.apm.numSpanBytesReceived', rollup='sum').mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.apm.numSpanBytesReceived', rollup='sum').mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current Span Bytes"
        label        = "C"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}
# signalfx_list_chart.License-Exec_2:
resource "signalfx_list_chart" "License-Exec_2" {
    color_by                = "Dimension"
    description             = "APM - TPM Troubleshooting Metric Sets License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "APM - Troubleshooting Metric Sets"
    program_text            = <<-EOF
        C = data('sf.org.apm.numTroubleshootingMetricSets').mean(over='7d').publish(label='C')
        D = data('sf.org.apm.numTroubleshootingMetricSets').mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.apm.numTroubleshootingMetricSets').mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current Troubleshooting Metric Sets"
        label        = "C"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}
# signalfx_list_chart.License-Exec_3:
resource "signalfx_list_chart" "License-Exec_3" {
    color_by                = "Dimension"
    description             = "APM - TPM Traces License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "APM - Traces Per Minute"
    program_text            = <<-EOF
        C = data('sf.org.apm.numTracesReceived').mean(over='7d').publish(label='C')
        D = data('sf.org.apm.numTracesReceived').mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.apm.numTracesReceived').mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current TPM"
        label        = "C"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}
# signalfx_list_chart.License-Exec_4:
resource "signalfx_list_chart" "License-Exec_4" {
    color_by                = "Dimension"
    description             = "IMM - Hosts License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "IMM - Hosts"
    program_text            = <<-EOF
        C = data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'container')).mean(over='7d').publish(label='C')
        H = data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'host')).mean(over='7d').publish(label='H')
        I = (C+H).publish(label='I')
        J = (C+H).timeshift('4w').publish(label='J', enable=False)
        K = (C+H).timeshift('12w').publish(label='K', enable=False)
        G = (((I-K)/K)*100).publish(label='G')
        F = (((I-J)/J)*100).publish(label='F')
    EOF
    secondary_visualization = "None"
    time_range              = 900
    unit_prefix             = "Metric"

    legend_options_fields {
        enabled  = true
        property = "sf_metric"
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
        property = "resourceType"
    }

    viz_options {
        display_name = "12 Week Combined Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "12w Combined Hosts"
        label        = "K"
    }
    viz_options {
        display_name = "4 Week Combined Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4w Combined Hosts"
        label        = "J"
    }
    viz_options {
        display_name = "Current Combined Hosts"
        label        = "I"
    }
    viz_options {
        display_name = "Current Containers"
        label        = "C"
    }
    viz_options {
        display_name = "Current Hosts"
        label        = "H"
    }
}
# signalfx_list_chart.License-Exec_5:
resource "signalfx_list_chart" "License-Exec_5" {
    color_by                = "Dimension"
    description             = "IMM - Custom Metrics License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "IMM - Custom Metrics"
    program_text            = <<-EOF
        C = data('sf.org.numCustomMetrics').mean(over='7d').publish(label='C')
        D = data('sf.org.numCustomMetrics').mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.numCustomMetrics').mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current Custom Metrics"
        label        = "C"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}
# signalfx_list_chart.License-Exec_7:
resource "signalfx_list_chart" "License-Exec_7" {
    color_by                = "Dimension"
    description             = "IMM - Data Points Per Minute License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "IMM - Data Points Per Minute"
    program_text            = <<-EOF
        C = data('sf.org.numDatapointsReceivedByToken').sum().mean(over='7d').publish(label='C')
        D = data('sf.org.numDatapointsReceivedByToken').sum().mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.numDatapointsReceivedByToken').sum().mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = true
        property = "category"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current DPM"
        label        = "C"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}
# signalfx_list_chart.License-Exec_8:
resource "signalfx_list_chart" "License-Exec_8" {
    color_by                = "Dimension"
    description             = "Logs - Ingest Bytes License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Logs - Ingest Bytes"
    program_text            = <<-EOF
        C = data('sf.org.log.numContentBytesReceivedByToken').sum().mean(over='7d').publish(label='C')
        D = data('sf.org.log.numContentBytesReceivedByToken').sum().mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.log.numContentBytesReceivedByToken').sum().mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenId"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current Log Ingest"
        label        = "C"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "D"
        label        = "D"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "E"
        label        = "E"
        value_unit   = "Byte"
    }
}
# signalfx_list_chart.License-Exec_9:
resource "signalfx_list_chart" "License-Exec_9" {
    color_by                = "Dimension"
    description             = "Logs - Per Host Ingest Bytes License metric (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Logs - Per Host Ingest Bytes"
    program_text            = <<-EOF
        H = data('sf.org.numResourcesMonitored').sum().publish(label='H', enable=False)
        C = data('sf.org.log.numContentBytesReceivedByToken').sum().mean(over='7d').publish(label='C', enable=False)
        I = (C / H).publish(label='I')
        J = (C / H).timeshift('4w').publish(label='J', enable=False)
        K = (C / H).timeshift('12w').publish(label='K', enable=False)
        F = (((I-J)/J)*100).publish(label='F')
        G = (((I-K)/K)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = true
        property = "resourceType"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "12w Log Ingest per Host"
        label        = "K"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4w Log Ingest per Host"
        label        = "J"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "Current Log Ingest"
        label        = "C"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "Log Ingest per Host"
        label        = "I"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "Total Hosts"
        label        = "H"
    }
}
# signalfx_list_chart.License-Exec_10:
resource "signalfx_list_chart" "License-Exec_10" {
    color_by                = "Dimension"
    description             = "RUM/APM - RUM Span Bytes (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "RUM/APM - RUM Span Bytes"
    program_text            = <<-EOF
        C = data('sf.org.rum.numSpanBytesReceivedByToken').sum().mean(over='7d').publish(label='C')
        D = data('sf.org.rum.numSpanBytesReceivedByToken').sum().mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.rum.numSpanBytesReceivedByToken').sum().mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = true
        property = "category"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Current Rum Span Bytes"
        label        = "C"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "D"
        label        = "D"
        value_unit   = "Byte"
    }
    viz_options {
        display_name = "E"
        label        = "E"
        value_unit   = "Byte"
    }
}

# signalfx_list_chart.License-Exec_11:
resource "signalfx_list_chart" "License-Exec_11" {
    color_by                = "Dimension"
    description             = "Synthetics - Datapoints Received (7 day avg)"
    disable_sampling        = false
    hide_missing_values     = false
    max_delay               = 0
    max_precision           = 2
    name                    = "Synthetics - Datapoints Received"
    program_text            = <<-EOF
        F = (((C-D)/D)*100).publish(label='F')
        G = (((C-E)/E)*100).publish(label='G')
        D = data('sf.org.synthetics.numDatapointsReceived').sum().mean(over='7d').timeshift('4w').publish(label='D', enable=False)
        E = data('sf.org.synthetics.numDatapointsReceived').sum().mean(over='7d').timeshift('12w').publish(label='E', enable=False)
        C = data('sf.org.synthetics.numDatapointsReceived').sum().mean(over='7d').publish(label='C')
    EOF
    secondary_visualization = "None"
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
        enabled  = true
        property = "sf_metric"
    }
    legend_options_fields {
        enabled  = true
        property = "tokenId"
    }
    legend_options_fields {
        enabled  = true
        property = "category"
    }

    viz_options {
        display_name = "12 Week Comparison"
        label        = "G"
        value_suffix = "%"
    }
    viz_options {
        display_name = "4 Week Comparison"
        label        = "F"
        value_suffix = "%"
    }
    viz_options {
        display_name = "Synthetics Datapoints Received"
        label        = "C"
    }
    viz_options {
        display_name = "D"
        label        = "D"
    }
    viz_options {
        display_name = "E"
        label        = "E"
    }
}