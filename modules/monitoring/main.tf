resource "aws_instance" "grafana" {
  ami                         = "ami-0daee08993156ca1a"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  iam_instance_profile = var.iam_instance_profile
  user_data            = file("${path.module}/grafana.sh")

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
