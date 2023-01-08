output "metrics_collector_security_group_id" {
  value       = aws_security_group.metrics_collector.id
  description = "Security ID used for adding rules in other modules."
}

output "metrics_collector_instance_ip" {
  value       = aws_instance.metrics_collector.private_ip
  description = "The metrics collector instance private ip used for ssh access."
}








