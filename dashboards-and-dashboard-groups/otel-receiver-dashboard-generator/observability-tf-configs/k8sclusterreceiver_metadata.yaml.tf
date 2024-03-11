
resource "signalfx_dashboard" "k8s_clusterdashboard" {
  name            = "k8s_cluster"
  dashboard_group = signalfx_dashboard_group.k8s_clusterdashboardgroup0.id
  time_range      = "-1h"

  grid {
    chart_ids = [
      signalfx_time_chart.k8s_container_cpu_request.id, signalfx_time_chart.k8s_container_cpu_limit.id, signalfx_time_chart.k8s_container_memory_request.id, signalfx_time_chart.k8s_container_memory_limit.id, signalfx_time_chart.k8s_container_storage_request.id, signalfx_time_chart.k8s_container_storage_limit.id, signalfx_time_chart.k8s_container_ephemeralstorage_request.id, signalfx_time_chart.k8s_container_ephemeralstorage_limit.id, signalfx_time_chart.k8s_container_restarts.id, signalfx_time_chart.k8s_container_ready.id, signalfx_time_chart.k8s_pod_phase.id, signalfx_time_chart.k8s_pod_status_reason.id, signalfx_time_chart.k8s_deployment_desired.id, signalfx_time_chart.k8s_deployment_available.id, signalfx_time_chart.k8s_cronjob_active_jobs.id, signalfx_time_chart.k8s_daemonset_current_scheduled_nodes.id, signalfx_time_chart.k8s_daemonset_desired_scheduled_nodes.id, signalfx_time_chart.k8s_daemonset_misscheduled_nodes.id, signalfx_time_chart.k8s_daemonset_ready_nodes.id, signalfx_time_chart.k8s_hpa_max_replicas.id, signalfx_time_chart.k8s_hpa_min_replicas.id, signalfx_time_chart.k8s_hpa_current_replicas.id, signalfx_time_chart.k8s_hpa_desired_replicas.id, signalfx_time_chart.k8s_job_active_pods.id, signalfx_time_chart.k8s_job_desired_successful_pods.id, signalfx_time_chart.k8s_job_failed_pods.id, signalfx_time_chart.k8s_job_max_parallel_pods.id, signalfx_time_chart.k8s_job_successful_pods.id, signalfx_time_chart.k8s_namespace_phase.id, signalfx_time_chart.k8s_replicaset_desired.id, signalfx_time_chart.k8s_replicaset_available.id, signalfx_time_chart.k8s_replication_controller_desired.id, signalfx_time_chart.k8s_replication_controller_available.id, signalfx_time_chart.k8s_resource_quota_hard_limit.id, signalfx_time_chart.k8s_resource_quota_used.id, signalfx_time_chart.k8s_statefulset_desired_pods.id, signalfx_time_chart.k8s_statefulset_ready_pods.id, signalfx_time_chart.k8s_statefulset_current_pods.id, signalfx_time_chart.k8s_statefulset_updated_pods.id, signalfx_time_chart.openshift_clusterquota_limit.id, signalfx_time_chart.openshift_clusterquota_used.id, signalfx_time_chart.openshift_appliedclusterquota_limit.id, signalfx_time_chart.openshift_appliedclusterquota_used.id, signalfx_time_chart.k8s_node_condition.id
    ]
    width  = 4
    height = 1
  }
}

resource "signalfx_dashboard_group" "k8s_clusterdashboardgroup0" {
  name        = "k8s_cluster generated OTel dashboard group"
  description = "k8s_cluster generated OTel dashboard group"
}

resource "signalfx_time_chart" "k8s_container_cpu_request" {
  name = "Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.cpu_request").publish(label="Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_cpu_limit" {
  name = "Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.cpu_limit").publish(label="Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_memory_request" {
  name = "Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.memory_request").publish(label="Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_memory_limit" {
  name = "Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.memory_limit").publish(label="Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_storage_request" {
  name = "Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.storage_request").publish(label="Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_storage_limit" {
  name = "Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.storage_limit").publish(label="Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_ephemeralstorage_request" {
  name = "Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.ephemeralstorage_request").publish(label="Resource requested for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_ephemeralstorage_limit" {
  name = "Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details"

  program_text = <<-EOF
    data("k8s.container.ephemeralstorage_limit").publish(label="Maximum resource limit set for the container. See https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core for details")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_restarts" {
  name = "How many times the container has restarted in the recent past. This value is pulled directly from the K8s API and the value can go indefinitely high and be reset to 0 at any time depending on how your kubelet is configured to prune dead containers. It is best to not depend too much on the exact value but rather look at it as either == 0, in which case you can conclude there were no restarts in the recent past, or > 0, in which case you can conclude there were restarts in the recent past, and not try and analyze the value beyond that."

  program_text = <<-EOF
    data("k8s.container.restarts").publish(label="How many times the container has restarted in the recent past. This value is pulled directly from the K8s API and the value can go indefinitely high and be reset to 0 at any time depending on how your kubelet is configured to prune dead containers. It is best to not depend too much on the exact value but rather look at it as either == 0, in which case you can conclude there were no restarts in the recent past, or > 0, in which case you can conclude there were restarts in the recent past, and not try and analyze the value beyond that.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_container_ready" {
  name = "Whether a container has passed its readiness probe (0 for no, 1 for yes)"

  program_text = <<-EOF
    data("k8s.container.ready").publish(label="Whether a container has passed its readiness probe (0 for no, 1 for yes)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_phase" {
  name = "Current phase of the pod (1 - Pending, 2 - Running, 3 - Succeeded, 4 - Failed, 5 - Unknown)"

  program_text = <<-EOF
    data("k8s.pod.phase").publish(label="Current phase of the pod (1 - Pending, 2 - Running, 3 - Succeeded, 4 - Failed, 5 - Unknown)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_pod_status_reason" {
  name = "Current status reason of the pod (1 - Evicted, 2 - NodeAffinity, 3 - NodeLost, 4 - Shutdown, 5 - UnexpectedAdmissionError, 6 - Unknown)"

  program_text = <<-EOF
    data("k8s.pod.status_reason").publish(label="Current status reason of the pod (1 - Evicted, 2 - NodeAffinity, 3 - NodeLost, 4 - Shutdown, 5 - UnexpectedAdmissionError, 6 - Unknown)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_deployment_desired" {
  name = "Number of desired pods in this deployment"

  program_text = <<-EOF
    data("k8s.deployment.desired").publish(label="Number of desired pods in this deployment")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_deployment_available" {
  name = "Total number of available pods (ready for at least minReadySeconds) targeted by this deployment"

  program_text = <<-EOF
    data("k8s.deployment.available").publish(label="Total number of available pods (ready for at least minReadySeconds) targeted by this deployment")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_cronjob_active_jobs" {
  name = "The number of actively running jobs for a cronjob"

  program_text = <<-EOF
    data("k8s.cronjob.active_jobs").publish(label="The number of actively running jobs for a cronjob")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_daemonset_current_scheduled_nodes" {
  name = "Number of nodes that are running at least 1 daemon pod and are supposed to run the daemon pod"

  program_text = <<-EOF
    data("k8s.daemonset.current_scheduled_nodes").publish(label="Number of nodes that are running at least 1 daemon pod and are supposed to run the daemon pod")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_daemonset_desired_scheduled_nodes" {
  name = "Number of nodes that should be running the daemon pod (including nodes currently running the daemon pod)"

  program_text = <<-EOF
    data("k8s.daemonset.desired_scheduled_nodes").publish(label="Number of nodes that should be running the daemon pod (including nodes currently running the daemon pod)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_daemonset_misscheduled_nodes" {
  name = "Number of nodes that are running the daemon pod, but are not supposed to run the daemon pod"

  program_text = <<-EOF
    data("k8s.daemonset.misscheduled_nodes").publish(label="Number of nodes that are running the daemon pod, but are not supposed to run the daemon pod")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_daemonset_ready_nodes" {
  name = "Number of nodes that should be running the daemon pod and have one or more of the daemon pod running and ready"

  program_text = <<-EOF
    data("k8s.daemonset.ready_nodes").publish(label="Number of nodes that should be running the daemon pod and have one or more of the daemon pod running and ready")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_hpa_max_replicas" {
  name = "Maximum number of replicas to which the autoscaler can scale up."

  program_text = <<-EOF
    data("k8s.hpa.max_replicas").publish(label="Maximum number of replicas to which the autoscaler can scale up.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_hpa_min_replicas" {
  name = "Minimum number of replicas to which the autoscaler can scale up."

  program_text = <<-EOF
    data("k8s.hpa.min_replicas").publish(label="Minimum number of replicas to which the autoscaler can scale up.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_hpa_current_replicas" {
  name = "Current number of pod replicas managed by this autoscaler."

  program_text = <<-EOF
    data("k8s.hpa.current_replicas").publish(label="Current number of pod replicas managed by this autoscaler.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_hpa_desired_replicas" {
  name = "Desired number of pod replicas managed by this autoscaler."

  program_text = <<-EOF
    data("k8s.hpa.desired_replicas").publish(label="Desired number of pod replicas managed by this autoscaler.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_job_active_pods" {
  name = "The number of actively running pods for a job"

  program_text = <<-EOF
    data("k8s.job.active_pods").publish(label="The number of actively running pods for a job")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_job_desired_successful_pods" {
  name = "The desired number of successfully finished pods the job should be run with"

  program_text = <<-EOF
    data("k8s.job.desired_successful_pods").publish(label="The desired number of successfully finished pods the job should be run with")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_job_failed_pods" {
  name = "The number of pods which reached phase Failed for a job"

  program_text = <<-EOF
    data("k8s.job.failed_pods").publish(label="The number of pods which reached phase Failed for a job")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_job_max_parallel_pods" {
  name = "The max desired number of pods the job should run at any given time"

  program_text = <<-EOF
    data("k8s.job.max_parallel_pods").publish(label="The max desired number of pods the job should run at any given time")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_job_successful_pods" {
  name = "The number of pods which reached phase Succeeded for a job"

  program_text = <<-EOF
    data("k8s.job.successful_pods").publish(label="The number of pods which reached phase Succeeded for a job")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_namespace_phase" {
  name = "The current phase of namespaces (1 for active and 0 for terminating)"

  program_text = <<-EOF
    data("k8s.namespace.phase").publish(label="The current phase of namespaces (1 for active and 0 for terminating)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_replicaset_desired" {
  name = "Number of desired pods in this replicaset"

  program_text = <<-EOF
    data("k8s.replicaset.desired").publish(label="Number of desired pods in this replicaset")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_replicaset_available" {
  name = "Total number of available pods (ready for at least minReadySeconds) targeted by this replicaset"

  program_text = <<-EOF
    data("k8s.replicaset.available").publish(label="Total number of available pods (ready for at least minReadySeconds) targeted by this replicaset")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_replication_controller_desired" {
  name = "Number of desired pods in this replication_controller"

  program_text = <<-EOF
    data("k8s.replication_controller.desired").publish(label="Number of desired pods in this replication_controller")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_replication_controller_available" {
  name = "Total number of available pods (ready for at least minReadySeconds) targeted by this replication_controller"

  program_text = <<-EOF
    data("k8s.replication_controller.available").publish(label="Total number of available pods (ready for at least minReadySeconds) targeted by this replication_controller")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_resource_quota_hard_limit" {
  name = "The upper limit for a particular resource in a specific namespace. Will only be sent if a quota is specified. CPU requests/limits will be sent as millicores"

  program_text = <<-EOF
    data("k8s.resource_quota.hard_limit").publish(label="The upper limit for a particular resource in a specific namespace. Will only be sent if a quota is specified. CPU requests/limits will be sent as millicores")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_resource_quota_used" {
  name = "The usage for a particular resource in a specific namespace. Will only be sent if a quota is specified. CPU requests/limits will be sent as millicores"

  program_text = <<-EOF
    data("k8s.resource_quota.used").publish(label="The usage for a particular resource in a specific namespace. Will only be sent if a quota is specified. CPU requests/limits will be sent as millicores")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_statefulset_desired_pods" {
  name = "Number of desired pods in the stateful set (the `spec.replicas` field)"

  program_text = <<-EOF
    data("k8s.statefulset.desired_pods").publish(label="Number of desired pods in the stateful set (the `spec.replicas` field)")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_statefulset_ready_pods" {
  name = "Number of pods created by the stateful set that have the `Ready` condition"

  program_text = <<-EOF
    data("k8s.statefulset.ready_pods").publish(label="Number of pods created by the stateful set that have the `Ready` condition")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_statefulset_current_pods" {
  name = "The number of pods created by the StatefulSet controller from the StatefulSet version"

  program_text = <<-EOF
    data("k8s.statefulset.current_pods").publish(label="The number of pods created by the StatefulSet controller from the StatefulSet version")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_statefulset_updated_pods" {
  name = "Number of pods created by the StatefulSet controller from the StatefulSet version"

  program_text = <<-EOF
    data("k8s.statefulset.updated_pods").publish(label="Number of pods created by the StatefulSet controller from the StatefulSet version")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "openshift_clusterquota_limit" {
  name = "The configured upper limit for a particular resource."

  program_text = <<-EOF
    data("openshift.clusterquota.limit").publish(label="The configured upper limit for a particular resource.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "openshift_clusterquota_used" {
  name = "The usage for a particular resource with a configured limit."

  program_text = <<-EOF
    data("openshift.clusterquota.used").publish(label="The usage for a particular resource with a configured limit.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "openshift_appliedclusterquota_limit" {
  name = "The upper limit for a particular resource in a specific namespace."

  program_text = <<-EOF
    data("openshift.appliedclusterquota.limit").publish(label="The upper limit for a particular resource in a specific namespace.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "openshift_appliedclusterquota_used" {
  name = "The usage for a particular resource in a specific namespace."

  program_text = <<-EOF
    data("openshift.appliedclusterquota.used").publish(label="The usage for a particular resource in a specific namespace.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}


resource "signalfx_time_chart" "k8s_node_condition" {
  name = "The condition of a particular Node."

  program_text = <<-EOF
    data("k8s.node.condition").publish(label="The condition of a particular Node.")
  EOF

  time_range = 14400

  plot_type         = "LineChart"
  show_data_markers = true
}
