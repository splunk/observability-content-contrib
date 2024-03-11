
resource "signalfx_dashboard" "httpcheckdashboard" {
  name            = "httpcheck"
  dashboard_group = signalfx_dashboard_group.httpcheckdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.httpcheck_status.id, signalfx_time_chart.httpcheck_duration.id, signalfx_time_chart.httpcheck_error.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "httpcheckdashboardgroup0" {
  name        = "httpcheck generated OTel dashboard group"
  description = "httpcheck generated OTel dashboard group"
}

resource "signalfx_time_chart" "httpcheck_status" {
  name = "1 if the check resulted in status_code matching the status_class, otherwise 0."

  program_text = <<-EOF
    data("httpcheck.status").publish(label="1 if the check resulted in status_code matching the status_class, otherwise 0.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "httpcheck_duration" {
  name = "Measures the duration of the HTTP check."

  program_text = <<-EOF
    data("httpcheck.duration").publish(label="Measures the duration of the HTTP check.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "httpcheck_error" {
  name = "Records errors occurring during HTTP check."

  program_text = <<-EOF
    data("httpcheck.error").publish(label="Records errors occurring during HTTP check.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
