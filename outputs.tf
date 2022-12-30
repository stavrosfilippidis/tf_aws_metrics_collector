output "metrics_collector_security_group_id" {
  value       = aws_security_group.metrics_collector.id
  description = "Security ID used for the security groups in other modules."
}

output "metrics_collector_instance_ip" {
  value       = aws_instance.metrics_collector.private_ip
  description = "The metrics collector instance private ip used for ssh access."
}

# output "metrics_collector_instance_dns_record" {
#   value       = "https://${aws_route53_record.metrics_collector.name}.${data.aws_route53_zone.hosted_zone.name}:${var.reverse_proxy_metrics_collector_port}"
#   description = "Metrics collector dns record used for easy access."
# }







