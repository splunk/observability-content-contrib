
resource "signalfx_dashboard" "active_directory_dsdashboard" {
  name            = "active_directory_ds"
  dashboard_group = signalfx_dashboard_group.active_directory_dsdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.active_directory_ds_replication_network_io.id, signalfx_time_chart.active_directory_ds_replication_sync_object_pending.id, signalfx_time_chart.active_directory_ds_replication_sync_request_count.id, signalfx_time_chart.active_directory_ds_replication_object_rate.id, signalfx_time_chart.active_directory_ds_replication_property_rate.id, signalfx_time_chart.active_directory_ds_replication_value_rate.id, signalfx_time_chart.active_directory_ds_replication_operation_pending.id, signalfx_time_chart.active_directory_ds_operation_rate.id, signalfx_time_chart.active_directory_ds_name_cache_hit_rate.id, signalfx_time_chart.active_directory_ds_notification_queued.id, signalfx_time_chart.active_directory_ds_security_descriptor_propagations_event_queued.id, signalfx_time_chart.active_directory_ds_suboperation_rate.id, signalfx_time_chart.active_directory_ds_bind_rate.id, signalfx_time_chart.active_directory_ds_thread_count.id, signalfx_time_chart.active_directory_ds_ldap_client_session_count.id, signalfx_time_chart.active_directory_ds_ldap_bind_last_successful_time.id, signalfx_time_chart.active_directory_ds_ldap_bind_rate.id, signalfx_time_chart.active_directory_ds_ldap_search_rate.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "active_directory_dsdashboardgroup0" {
  name        = "active_directory_ds generated OTel dashboard group"
  description = "active_directory_ds generated OTel dashboard group"
}

resource "signalfx_time_chart" "active_directory_ds_replication_network_io" {
  name = "The amount of network data transmitted by the Directory Replication Agent."

  program_text = <<-EOF
    data("active_directory.ds.replication.network.io").publish(label="The amount of network data transmitted by the Directory Replication Agent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_sync_object_pending" {
  name = "The number of objects remaining until the full sync completes for the Directory Replication Agent."

  program_text = <<-EOF
    data("active_directory.ds.replication.sync.object.pending").publish(label="The number of objects remaining until the full sync completes for the Directory Replication Agent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_sync_request_count" {
  name = "The number of sync requests made by the Directory Replication Agent."

  program_text = <<-EOF
    data("active_directory.ds.replication.sync.request.count").publish(label="The number of sync requests made by the Directory Replication Agent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_object_rate" {
  name = "The number of objects transmitted by the Directory Replication Agent per second."

  program_text = <<-EOF
    data("active_directory.ds.replication.object.rate").publish(label="The number of objects transmitted by the Directory Replication Agent per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_property_rate" {
  name = "The number of properties transmitted by the Directory Replication Agent per second."

  program_text = <<-EOF
    data("active_directory.ds.replication.property.rate").publish(label="The number of properties transmitted by the Directory Replication Agent per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_value_rate" {
  name = "The number of values transmitted by the Directory Replication Agent per second."

  program_text = <<-EOF
    data("active_directory.ds.replication.value.rate").publish(label="The number of values transmitted by the Directory Replication Agent per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_replication_operation_pending" {
  name = "The number of pending replication operations for the Directory Replication Agent."

  program_text = <<-EOF
    data("active_directory.ds.replication.operation.pending").publish(label="The number of pending replication operations for the Directory Replication Agent.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_operation_rate" {
  name = "The number of operations performed per second."

  program_text = <<-EOF
    data("active_directory.ds.operation.rate").publish(label="The number of operations performed per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_name_cache_hit_rate" {
  name = "The percentage of directory object name component lookups that are satisfied by the Directory System Agent's name cache."

  program_text = <<-EOF
    data("active_directory.ds.name_cache.hit_rate").publish(label="The percentage of directory object name component lookups that are satisfied by the Directory System Agent's name cache.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_notification_queued" {
  name = "The number of pending update notifications that have been queued to push to clients."

  program_text = <<-EOF
    data("active_directory.ds.notification.queued").publish(label="The number of pending update notifications that have been queued to push to clients.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_security_descriptor_propagations_event_queued" {
  name = "The number of security descriptor propagation events that are queued for processing."

  program_text = <<-EOF
    data("active_directory.ds.security_descriptor_propagations_event.queued").publish(label="The number of security descriptor propagation events that are queued for processing.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_suboperation_rate" {
  name = "The rate of sub-operations performed."

  program_text = <<-EOF
    data("active_directory.ds.suboperation.rate").publish(label="The rate of sub-operations performed.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_bind_rate" {
  name = "The number of binds per second serviced by this domain controller."

  program_text = <<-EOF
    data("active_directory.ds.bind.rate").publish(label="The number of binds per second serviced by this domain controller.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_thread_count" {
  name = "The number of threads in use by the directory service."

  program_text = <<-EOF
    data("active_directory.ds.thread.count").publish(label="The number of threads in use by the directory service.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_ldap_client_session_count" {
  name = "The number of connected LDAP client sessions."

  program_text = <<-EOF
    data("active_directory.ds.ldap.client.session.count").publish(label="The number of connected LDAP client sessions.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_ldap_bind_last_successful_time" {
  name = "The amount of time taken for the last successful LDAP bind."

  program_text = <<-EOF
    data("active_directory.ds.ldap.bind.last_successful.time").publish(label="The amount of time taken for the last successful LDAP bind.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_ldap_bind_rate" {
  name = "The number of successful LDAP binds per second."

  program_text = <<-EOF
    data("active_directory.ds.ldap.bind.rate").publish(label="The number of successful LDAP binds per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "active_directory_ds_ldap_search_rate" {
  name = "The number of LDAP searches per second."

  program_text = <<-EOF
    data("active_directory.ds.ldap.search.rate").publish(label="The number of LDAP searches per second.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
