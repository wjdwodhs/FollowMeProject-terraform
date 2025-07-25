resource "aws_launch_template" "followme_lt" {
  name_prefix   = "followme-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/userdata.sh")
  vpc_security_group_ids = [var.ec2_sg_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "followme-instance"
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "followme_asg" {
  name                      = "followme-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [var.target_group_arn]

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
