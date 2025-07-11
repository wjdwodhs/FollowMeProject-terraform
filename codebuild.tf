resource "aws_codebuild_project" "followme_project" {
  name          = "followme-build"
  description   = "Build project for FollowMe WAR packaging"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 10

  source {
    type            = "GITHUB"
    location        = "https://github.com/wjdwodhs/FollowMeProject.git"
    git_clone_depth = 1
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.followme_bucket.bucket
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/followme-build"
      stream_name = "build-log"
    }
  }

  source_version = "main"
}
