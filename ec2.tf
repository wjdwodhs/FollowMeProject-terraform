resource "aws_instance" "ec2" {
  ami                         = "ami-0daee08993156ca1a"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.followme_key.key_name

  user_data = file("${path.module}/userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "followme-ec2"
  }
}

