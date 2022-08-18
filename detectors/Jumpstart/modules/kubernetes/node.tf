/*
resource "signalfx_detector" "k8s_node_cpu_imbalance" {
  name         = "${var.sfx_prefix} K8S Cluster CPU balance"
  description  = "Alerts when cluster CPU usage is imbalanced"
  program_text = <<-EOF
    A = data('container_cpu_utilization', filter=filter('k8s.cluster.name', '*') and filter('k8s.node.name', '*'), rollup='rate').sum(by=['k8s.node.name', 'k8s.cluster.name']).publish(label='A', enable=False)
    B = data('container_cpu_utilization', filter=filter('k8s.cluster.name', '*') and filter('k8s.node.name', '*')).sum(by=['k8s.node.name']).mean(by=['k8s.cluster.name']).publish(label='B', enable=False)
    C = ((A-B)/B).stddev(by=['k8s.cluster.name']).publish(label='C', enable=False)
    D = data('kube_node_info', filter=filter('k8s.cluster.name', '*'), rollup='count').count(by=['k8s.cluster.name']).publish(label='D', enable=False)
    E = (C*D).publish(label='K8S Cluster CPU usage is imbalanced')
  EOF
  rule {
    detect_label = "K8S Cluster CPU usage is imbalanced"
    severity     = "Critical"
    disabled     = true
    parameterized_body  = var.message_body
  }
}
*/

resource "signalfx_detector" "k8s_node_not_ready" {
  name         = "${var.sfx_prefix} K8S Nodes are not ready"
  description  = "Alerts when K8s Node is not a ready state"
  program_text = <<-EOF
    A = data('k8s.node.condition_ready').sum(by=['k8s.cluster.name', 'k8s.node.name']).publish(label='A')
    detect(when(A < threshold(1), lasting='30s')).publish('K8s Node is not in a ready state')
  EOF
  rule {
    detect_label = "K8s Node is not in a ready state"
    severity     = "Critical"
    parameterized_body  = var.message_body
  }
}


resource "signalfx_detector" "k8s_node_high_memory" {
  name         = "${var.sfx_prefix} K8S Node Memory > 90%"
  description  = "Alerts when K8s Node is using memory > 90% for 5m"
  program_text = <<-EOF
    A = data('memory.utilization', filter=filter('k8s.cluster.name', '*')).sum(by=['host', 'k8s.cluster.name']).publish(label='A')
    detect(when(A > threshold(90), lasting='5m')).publish('K8s Node Memory is higher than 90% for 5m')
  EOF
  rule {
    detect_label = "K8s Node Memory is higher than 90% for 5m"
    severity     = "Major"
    parameterized_body  = var.message_body
  }
}
