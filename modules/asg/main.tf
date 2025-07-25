# Auto Scaling Group
resource "aws_autoscaling_group" "followme_asg" {
  name                      = var.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids

  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  tag {
    key                 = "Name"
    value               = var.instance_name_tag
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Auto Scaling Policy - Scale Out
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.followme_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

# Auto Scaling Policy - Scale In
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.followme_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# CloudWatch Alarm - High CPU (Scale Out)
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "Trigger scale-out when CPU > 60%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.followme_asg.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]
}

# CloudWatch Alarm - Low CPU (Scale In)
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "LowCPUUtilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Trigger scale-in when CPU < 20%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.followme_asg.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]
}
