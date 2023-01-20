resource "signalfx_detector" "k8s_container_restarts" {
  name         = "${var.o11y_prefix} K8S Container restart count is > 0"
  description  = "Container restart count in the last 5m is > 0"
  program_text = <<-EOF
    A = data('k8s.container.restarts').sum(by=['k8s.cluster.name', 'k8s.namespace.name', 'k8s.pod.name']).delta().sum(over='5m').above(0, inclusive=True, clamp=True).publish(label='A')
    detect(when(A > threshold(0), lasting='5m')).publish('K8S Container restart count is > 0')
  EOF
  rule {
    detect_label       = "K8S Container restart count is > 0"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "k8s_container_cpu" {
  name         = "${var.o11y_prefix} K8S Container CPU utilization is higher than normal, and increasing"
  description  = "Alerts when container CPU utilization (%) in the last 5m is more than 2.5 standard deviations above the mean of its preceding 30m"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('container_cpu_percent', filter=filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*') and filter('k8s.deployment.name', '*', match_missing=True), rollup='rate').publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Container CPU Usage higher than normal, and increasing')
  EOF
  rule {
    detect_label       = "K8S Container CPU Usage higher than normal, and increasing"
    severity           = "Warning"
    disabled           = true
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "k8s_container_memory" {
  name         = "${var.o11y_prefix} K8S Container top 5 memory utilization is higher than normal, and increasing"
  description  = "Alerts when container memory utilization of top 5 in the last 15m is more than 3.5 standard deviations above the median of similar signals for 100% of 15m"
  program_text = <<-EOF
from signalfx.detectors.population_comparison import population
A = data('container.memory.usage', filter=filter('k8s.cluster.name', '*') and filter('k8s.namespace.name', '*') and filter('k8s.deployment.name', '*')).sum(by=['container.name']).top(by=['k8s.cluster.name'], count=5).publish(label='A', enable=False)
D = (A).mean(over='5m').publish(label='D', enable=False)
population.detector(population_stream=A, group_by_property=None, fire_num_dev=3.5, fire_lasting=lasting('15m', 1), clear_num_dev=3, clear_lasting=lasting('15m', 1), strategy='median_MAD', orientation='above').publish('K8S Container Memory Usage higher than normal, and increasing')
  EOF
  rule {
    detect_label       = "K8S Container Memory Usage higher than normal, and increasing"
    severity           = "Warning"
    parameterized_body = var.message_body
  }
}
