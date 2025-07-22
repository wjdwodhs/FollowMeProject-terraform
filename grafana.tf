resource "aws_instance" "grafana" {
  ami                         = "ami-0daee08993156ca1a"  
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_a.id  
  key_name                    = "followme-key"          
  vpc_security_group_ids      = [aws_security_group.grafana_sg.id]
  associate_public_ip_address = true

  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data = file("${path.module}/grafana.sh")

  tags = {
    Name = "grafana"
  }
}

resource "aws_eip" "grafana_eip" {
  instance = aws_instance.grafana.id

  tags = {
    Name = "grafana-eip"
  }
}
