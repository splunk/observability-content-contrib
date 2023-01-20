### Create a Dashboard Group for our Dashboards
resource "signalfx_dashboard_group" "exec_dashboard_group" {
  name        = "${var.o11y_prefix} Exec Level Dashboards"
  description = "Executive Level Dashboards"

  ### Note that if you use these features, you must use a user's
  ### admin key to authenticate the provider, lest Terraform not be able
  ### to modify the dashboard group in the future!
  #authorized_writer_teams = [signalfx_team.mycoolteam.id]
  #authorized_writer_users = ["abc123"]
}
