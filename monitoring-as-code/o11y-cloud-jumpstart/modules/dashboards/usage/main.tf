resource "signalfx_dashboard_group" "usageoverview" {
  name        = "${var.o11y_prefix} Usage Overview (Terraform)"
  description = "Host Based Model, MTS and Events Usage"
}
