resource "signalfx_dashboard_group" "rumandsynthetics" {
  name        = "${var.o11y_prefix} RUM and Synthetics (Terraform)"
  description = "RUM and SYnthetics Dashboard"
}
