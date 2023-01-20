resource "signalfx_detector" "k8s_pods_active" {
  name         = "${var.o11y_prefix} K8S Pods active"
  description  = "Alerts when number of active pods changed significantly"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('container_cpu_utilization', filter=filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*') and filter('k8s.deployment.name', '*', match_missing=True)).sum(by=['k8s.cluster.name', 'k8s.namespace.name', 'k8s.pod.uid']).count().publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='1h', fire_num_stddev=3.5, clear_num_stddev=3, orientation='out_of_band', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods active changed significantly')
  EOF
  rule {
    detect_label       = "K8S Pods active changed significantly"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "k8s_pods_failed_pending_ratio" {
  name         = "${var.o11y_prefix} K8S Pod Phase Failed/Pending"
  description  = "Alerts when more Pods are in failed and pending phase than normal"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('k8s.pod.phase', filter=filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*') and filter('metric_source', 'kubernetes')).below(1, inclusive=True).count(by=['k8s.cluster.name', 'k8s.namespace.name']).publish(label='A')
    B = data('k8s.pod.phase', filter=filter('metric_source', 'kubernetes') and filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*')).above(4, inclusive=True).count(by=['k8s.cluster.name', 'k8s.namespace.name']).publish(label='B')
    D = data('k8s.pod.phase', filter=filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*') and filter('metric_source', 'kubernetes')).count(by=['k8s.cluster.name', 'k8s.namespace.name']).publish(label='D')
    E = (((A+B)/D)*100).publish(label='E')
    against_recent.detector_mean_std(stream=E, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods failed and pending ratio')
  EOF
  rule {
    detect_label       = "K8S Pods failed and pending ratio"
    severity           = "Minor"
    parameterized_body = var.message_body
  }
}
