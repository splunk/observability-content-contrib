resource "signalfx_detector" "aws_ecs_smartagent_cpu" {
  name         = "${var.o11y_prefix} ECS Cluster High CPU 5m (SFX) - SmartAgent"
  description  = "Alert when an ECS Cluster has sustained high CPU levels for 5 minutes"
  program_text = <<-EOF
    A = data('cpu.usage.total', filter=filter('ecs_task_group', '*'), rollup='rate').publish(label='A', enable=False)
    B = data('cpu.usage.system', filter=filter('ecs_task_group', '*'), rollup='rate').publish(label='B', enable=False)
    C = ((A/B)*100).publish(label='C', enable=False)
    E = (C).min().publish(label='E', enable=False)
    G = (C).percentile(pct=10).publish(label='G', enable=False)
    F = (C).percentile(pct=50).publish(label='F', enable=False)
    H = (C).percentile(pct=95).publish(label='H', enable=False)
    D = (C).max().publish(label='D', enable=False)
    detect(when(D > 90, lasting='5m')).publish('AWS/ECS Cluster High CPU 5m')
  EOF
  rule {
    detect_label       = "AWS/ECS Cluster High CPU 5m"
    severity           = "Major"
    parameterized_body = var.message_body
  }
}