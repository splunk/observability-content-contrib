
resource "signalfx_dashboard" "sshcheckdashboard" {
  name            = "sshcheck"
  dashboard_group = signalfx_dashboard_group.sshcheckdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.sshcheck_status.id, signalfx_time_chart.sshcheck_duration.id, signalfx_time_chart.sshcheck_error.id, signalfx_time_chart.sshcheck_sftp_status.id, signalfx_time_chart.sshcheck_sftp_duration.id, signalfx_time_chart.sshcheck_sftp_error.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "sshcheckdashboardgroup0" {
  name        = "sshcheck generated OTel dashboard group"
  description = "sshcheck generated OTel dashboard group"
}

resource "signalfx_time_chart" "sshcheck_status" {
  name = "1 if the SSH client successfully connected, otherwise 0."

  program_text = <<-EOF
    data("sshcheck.status").publish(label="1 if the SSH client successfully connected, otherwise 0.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sshcheck_duration" {
  name = "Measures the duration of SSH connection."

  program_text = <<-EOF
    data("sshcheck.duration").publish(label="Measures the duration of SSH connection.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sshcheck_error" {
  name = "Records errors occurring during SSH check."

  program_text = <<-EOF
    data("sshcheck.error").publish(label="Records errors occurring during SSH check.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sshcheck_sftp_status" {
  name = "1 if the SFTP server replied to request, otherwise 0."

  program_text = <<-EOF
    data("sshcheck.sftp_status").publish(label="1 if the SFTP server replied to request, otherwise 0.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sshcheck_sftp_duration" {
  name = "Measures SFTP request duration."

  program_text = <<-EOF
    data("sshcheck.sftp_duration").publish(label="Measures SFTP request duration.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "sshcheck_sftp_error" {
  name = "Records errors occurring during SFTP check."

  program_text = <<-EOF
    data("sshcheck.sftp_error").publish(label="Records errors occurring during SFTP check.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
