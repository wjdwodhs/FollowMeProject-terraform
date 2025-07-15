resource "aws_autoscaling_group" "followme_asg" {
  name                      = "followme-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  health_check_type         = "ELB"
  health_check_grace_period = 300


  target_group_arns = [
    aws_lb_target_group.followme_tg.arn
  ]


  launch_template {
    id      = aws_launch_template.followme_lt.id
    version = aws_launch_template.followme_lt.latest_version
  }


  tag {
    key                 = "Name"
    value               = "followme-instance"
    propagate_at_launch = true
  }


  lifecycle {
    create_before_destroy = true
  }

}
