output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

output "public_subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.subnet_b.id
}
