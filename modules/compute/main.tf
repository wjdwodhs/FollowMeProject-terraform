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
