resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.followme_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Trigger scaling out when CPU > 70%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.followme_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.followme_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "LowCPUUtilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Trigger scaling in when CPU < 30%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.followme_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
