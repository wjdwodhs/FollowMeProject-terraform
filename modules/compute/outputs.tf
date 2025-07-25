output "launch_template_id" {
  value = aws_launch_template.followme_lt.id
}

output "asg_name" {
  value = aws_autoscaling_group.followme_asg.name
}

output "launch_template_version" {
  value = aws_launch_template.followme_lt.latest_version
}
