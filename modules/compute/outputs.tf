output "launch_template_id" {
  value = aws_launch_template.followme_lt.id
}

output "launch_template_version" {
  value = aws_launch_template.followme_lt.latest_version
}
