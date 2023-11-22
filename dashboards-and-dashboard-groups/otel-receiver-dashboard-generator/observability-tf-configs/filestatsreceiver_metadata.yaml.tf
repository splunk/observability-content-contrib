
resource "signalfx_dashboard" "filestatsdashboard" {
  name            = "filestats"
  dashboard_group = signalfx_dashboard_group.filestatsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.file_mtime.id, signalfx_time_chart.file_ctime.id, signalfx_time_chart.file_atime.id, signalfx_time_chart.file_size.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "filestatsdashboardgroup0" {
  name        = "filestats generated OTel dashboard group"
  description = "filestats generated OTel dashboard group"
}

resource "signalfx_time_chart" "file_mtime" {
  name = "Elapsed time since the last modification of the file or folder, in seconds since Epoch."

  program_text = <<-EOF
    data("file.mtime").publish(label="Elapsed time since the last modification of the file or folder, in seconds since Epoch.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "file_ctime" {
  name = "Elapsed time since the last change of the file or folder, in seconds since Epoch. In addition to `file.mtime`, this metric tracks metadata changes such as permissions or renaming the file."

  program_text = <<-EOF
    data("file.ctime").publish(label="Elapsed time since the last change of the file or folder, in seconds since Epoch. In addition to `file.mtime`, this metric tracks metadata changes such as permissions or renaming the file.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "file_atime" {
  name = "Elapsed time since last access of the file or folder, in seconds since Epoch."

  program_text = <<-EOF
    data("file.atime").publish(label="Elapsed time since last access of the file or folder, in seconds since Epoch.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "file_size" {
  name = "The size of the file or folder, in bytes."

  program_text = <<-EOF
    data("file.size").publish(label="The size of the file or folder, in bytes.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
