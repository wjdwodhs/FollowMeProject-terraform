resource "aws_secretsmanager_secret" "rds_secret" {
  name = "followme-rds-secret"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "wjdwodhs123"
  })
}
