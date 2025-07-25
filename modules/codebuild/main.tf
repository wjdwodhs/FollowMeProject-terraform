resource "aws_codebuild_project" "followme_project" {
  name          = "followme-build"
  description   = "Build project for FollowMe WAR packaging"
  service_role  = var.codebuild_role_arn
  build_timeout = 10

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
  }

  artifacts {
    type     = "S3"
    location = var.artifact_bucket
    packaging = "ZIP"
    path     = "output"
    name     = "build-artifact.zip"
    override_artifact_name = false
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "S3_BUCKET"
      value = var.artifact_bucket
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

resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}
