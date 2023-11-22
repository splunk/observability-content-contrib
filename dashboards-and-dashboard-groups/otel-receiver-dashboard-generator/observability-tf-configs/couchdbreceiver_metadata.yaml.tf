
resource "signalfx_dashboard" "couchdbdashboard" {
  name            = "couchdb"
  dashboard_group = signalfx_dashboard_group.couchdbdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.couchdb_average_request_time.id, signalfx_time_chart.couchdb_httpd_bulk_requests.id, signalfx_time_chart.couchdb_httpd_requests.id, signalfx_time_chart.couchdb_httpd_responses.id, signalfx_time_chart.couchdb_httpd_views.id, signalfx_time_chart.couchdb_database_open.id, signalfx_time_chart.couchdb_file_descriptor_open.id, signalfx_time_chart.couchdb_database_operations.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "couchdbdashboardgroup0" {
  name        = "couchdb generated OTel dashboard group"
  description = "couchdb generated OTel dashboard group"
}

resource "signalfx_time_chart" "couchdb_average_request_time" {
  name = "The average duration of a served request."

  program_text = <<-EOF
    data("couchdb.average_request_time").publish(label="The average duration of a served request.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_httpd_bulk_requests" {
  name = "The number of bulk requests."

  program_text = <<-EOF
    data("couchdb.httpd.bulk_requests").publish(label="The number of bulk requests.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_httpd_requests" {
  name = "The number of HTTP requests by method."

  program_text = <<-EOF
    data("couchdb.httpd.requests").publish(label="The number of HTTP requests by method.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_httpd_responses" {
  name = "The number of each HTTP status code."

  program_text = <<-EOF
    data("couchdb.httpd.responses").publish(label="The number of each HTTP status code.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_httpd_views" {
  name = "The number of views read."

  program_text = <<-EOF
    data("couchdb.httpd.views").publish(label="The number of views read.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_database_open" {
  name = "The number of open databases."

  program_text = <<-EOF
    data("couchdb.database.open").publish(label="The number of open databases.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_file_descriptor_open" {
  name = "The number of open file descriptors."

  program_text = <<-EOF
    data("couchdb.file_descriptor.open").publish(label="The number of open file descriptors.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "couchdb_database_operations" {
  name = "The number of database operations."

  program_text = <<-EOF
    data("couchdb.database.operations").publish(label="The number of database operations.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
