resource "signalfx_dashboard_group" "parentchildoverview" {
  name        = "${var.o11y_prefix} Parent/Child Overview (Terraform)"
  description = "Parent/Child Overview/Usage Dashboards"
}
