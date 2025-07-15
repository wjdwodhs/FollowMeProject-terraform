resource "aws_db_instance" "followme_rds" {
  identifier              = "followme-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "wjdwodhs123"
  db_name                 = "followme"
  port                    = 3306

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.followme_db_subnet.name

  multi_az                = false
  publicly_accessible     = false
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "followme-rds"
  }
}

resource "aws_db_subnet_group" "followme_db_subnet" {
  name       = "followme-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "followme-db-subnet-group"
  }
}
