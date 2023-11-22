
resource "signalfx_dashboard" "gitproviderdashboard" {
  name            = "gitprovider"
  dashboard_group = signalfx_dashboard_group.gitproviderdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.git_repository_count.id, signalfx_time_chart.git_repository_branch_count.id, signalfx_time_chart.git_repository_contributor_count.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "gitproviderdashboardgroup0" {
  name        = "gitprovider generated OTel dashboard group"
  description = "gitprovider generated OTel dashboard group"
}

resource "signalfx_time_chart" "git_repository_count" {
  name = "Number of repositories in an organization"

  program_text = <<-EOF
    data("git.repository.count").publish(label="Number of repositories in an organization")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "git_repository_branch_count" {
  name = "Number of branches in the repository"

  program_text = <<-EOF
    data("git.repository.branch.count").publish(label="Number of branches in the repository")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "git_repository_contributor_count" {
  name = "Total number of unique contributors to this repository"

  program_text = <<-EOF
    data("git.repository.contributor.count").publish(label="Total number of unique contributors to this repository")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
