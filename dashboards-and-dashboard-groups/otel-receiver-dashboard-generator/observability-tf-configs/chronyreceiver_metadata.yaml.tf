
resource "signalfx_dashboard" "chronydashboard" {
  name            = "chrony"
  dashboard_group = signalfx_dashboard_group.chronydashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.ntp_frequency_offset.id, signalfx_time_chart.ntp_skew.id, signalfx_time_chart.ntp_stratum.id, signalfx_time_chart.ntp_time_correction.id, signalfx_time_chart.ntp_time_last_offset.id, signalfx_time_chart.ntp_time_rms_offset.id, signalfx_time_chart.ntp_time_root_delay.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "chronydashboardgroup0" {
  name        = "chrony generated OTel dashboard group"
  description = "chrony generated OTel dashboard group"
}

resource "signalfx_time_chart" "ntp_frequency_offset" {
  name = "The frequency is the rate by which the system s clock would be wrong if chronyd was not correcting it."

  program_text = <<-EOF
    data("ntp.frequency.offset").publish(label="The frequency is the rate by which the system s clock would be wrong if chronyd was not correcting it.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_skew" {
  name = "This is the estimated error bound on the frequency."

  program_text = <<-EOF
    data("ntp.skew").publish(label="This is the estimated error bound on the frequency.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_stratum" {
  name = "The number of hops away from the reference system keeping the reference time"

  program_text = <<-EOF
    data("ntp.stratum").publish(label="The number of hops away from the reference system keeping the reference time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_time_correction" {
  name = "The number of seconds difference between the system's clock and the reference clock"

  program_text = <<-EOF
    data("ntp.time.correction").publish(label="The number of seconds difference between the system's clock and the reference clock")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_time_last_offset" {
  name = "The estimated local offset on the last clock update"

  program_text = <<-EOF
    data("ntp.time.last_offset").publish(label="The estimated local offset on the last clock update")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_time_rms_offset" {
  name = "the long term average of the offset value"

  program_text = <<-EOF
    data("ntp.time.rms_offset").publish(label="the long term average of the offset value")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "ntp_time_root_delay" {
  name = "This is the total of the network path delays to the stratum-1 system from which the system is ultimately synchronised."

  program_text = <<-EOF
    data("ntp.time.root_delay").publish(label="This is the total of the network path delays to the stratum-1 system from which the system is ultimately synchronised.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
