resource "aws_iam_role" "codedeploy_role" {
  name = "followme-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# 기본 CodeDeploy EC2 배포용
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# Blue/Green 배포 제어 권한 추가
resource "aws_iam_policy" "codedeploy_bluegreen_policy" {
  name = "codedeploy-bluegreen-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "codedeploy:*",
          "iam:PassRole",
          "s3:*",
          "cloudwatch:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_bluegreen_policy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_bluegreen_policy.arn
}
