output "grafana_instance_id" {
  description = "ID of the Grafana EC2 instance"
  value       = aws_instance.grafana.id
}

output "grafana_public_ip" {
  description = "Elastic IP attached to Grafana"
  value       = aws_eip.grafana_eip.public_ip
}
