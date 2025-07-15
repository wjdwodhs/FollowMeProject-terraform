# EC2용 IAM Role
resource "aws_iam_role" "ec2_s3_access" {
  name = "followme-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# S3 접근 정책
resource "aws_iam_policy" "s3_access_policy" {
  name        = "followme-s3-access-policy"
  description = "Allow EC2 to access specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::followme-deploy-bucket-jjo",
          "arn:aws:s3:::followme-deploy-bucket-jjo/*"
        ]
      }
    ]
  })
}

# CodeDeploy 접근 정책
resource "aws_iam_policy" "codedeploy_access_policy" {
  name        = "followme-codedeploy-access"
  description = "Allow EC2 to interact with CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codedeploy:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Secrets Manager 접근 정책
resource "aws_iam_policy" "secrets_policy" {
  name = "followme-read-secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = aws_secretsmanager_secret.rds_secret.arn
      }
    ]
  })
}

# 정책 연결 (모두 ec2_s3_access에 붙임)
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_codedeploy_policy" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.codedeploy_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_secret_policy" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}

# EC2에 붙일 Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "followme-ec2-profile"
  role = aws_iam_role.ec2_s3_access.name
}
