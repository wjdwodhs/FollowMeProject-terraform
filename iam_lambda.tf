resource "aws_iam_role" "lambda_backup_role" {
  name = "lambda-ec2-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_backup_policy" {
  name = "lambda-ec2-backup-policy"
  role = aws_iam_role.lambda_backup_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # EC2 관련 권한
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateImage",
          "ec2:CreateTags",
          "ec2:DescribeInstances"
        ],
        Resource = "*"
      },
      # 로그 권한
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = "arn:aws:sns:ap-northeast-2:516268691817:ec2-monitoring-alert"
      }
    ]
  })
}

