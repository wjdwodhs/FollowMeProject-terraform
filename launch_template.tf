resource "aws_launch_template" "followme_lt" {
  name_prefix   = "followme-lt-"
  image_id      = "ami-0daee08993156ca1a"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.followme_key.key_name
  user_data     = filebase64("${path.module}/userdata.sh")
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "followme-instance"
    }
  }

  iam_instance_profile {
  name = aws_iam_instance_profile.ec2_profile.name
}

  lifecycle {
    create_before_destroy = true
  }
}
