# --- EC2 IAM Role & Policies ---
resource "aws_iam_role" "ec2_s3_access" {
  name = "followme-ec2-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name = "followme-s3-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject", "s3:GetObjectVersion",
        "s3:ListBucket", "s3:GetBucketLocation"
      ]
      Resource = [
        "arn:aws:s3:::followme-deploy-bucket-jjo",
        "arn:aws:s3:::followme-deploy-bucket-jjo/*"
      ]
    }]
  })
}

resource "aws_iam_policy" "codedeploy_access_policy" {
  name = "followme-codedeploy-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["codedeploy:*", "logs:*"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "secrets_policy" {
  name = "followme-read-secrets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue"]
      Resource = var.rds_secret_arn
    }]
  })
}

resource "aws_iam_policy" "cloudwatch_readonly_policy" {
  name = "followme-cloudwatch-readonly"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "cloudwatch:*", "logs:*",
        "ec2:DescribeTags", "ec2:DescribeInstances"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "followme-ec2-profile"
  role = aws_iam_role.ec2_s3_access.name
}

resource "aws_iam_role_policy_attachment" "ec2_attach_s3" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "ec2_attach_codedeploy" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.codedeploy_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "ec2_attach_secret" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}
resource "aws_iam_role_policy_attachment" "ec2_attach_cw" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.cloudwatch_readonly_policy.arn
}

# --- CodeBuild IAM ---
resource "aws_iam_role" "codebuild_role" {
  name = "followme-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "followme-codebuild-policy"
  role = aws_iam_role.codebuild_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["logs:*", "s3:*", "codebuild:*"]
      Resource = "*"
    }]
  })
}

# --- CodePipeline IAM ---
resource "aws_iam_role" "codepipeline_role" {
  name = "followme-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "followme-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:*", "codebuild:*", "codestar-connections:UseConnection"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# --- CodeDeploy IAM ---
resource "aws_iam_role" "codedeploy_role" {
  name = "followme-codedeploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codedeploy.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_policy" "codedeploy_bluegreen_policy" {
  name = "codedeploy-bluegreen-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "autoscaling:*", "ec2:*", "elasticloadbalancing:*",
        "codedeploy:*", "iam:PassRole", "s3:*", "cloudwatch:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_bluegreen_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_bluegreen_policy.arn
}

# --- Lambda IAM ---
resource "aws_iam_role" "lambda_backup_role" {
  name = "lambda-ec2-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_backup_policy" {
  name = "lambda-ec2-backup-policy"
  role = aws_iam_role.lambda_backup_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ec2:CreateImage", "ec2:CreateTags", "ec2:DescribeInstances"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["logs:*"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["sns:Publish"]
        Resource = "arn:aws:sns:ap-northeast-2:516268691817:ec2-monitoring-alert"
      }
    ]
  })
}
