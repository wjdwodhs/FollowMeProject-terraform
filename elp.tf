# Elastic IP 생성
resource "aws_eip" "followme_eip" {
  instance = aws_instance.ec2.id

  tags = {
    Name = "followme-eip"
  }
}
