resource "aws_codepipeline" "followme_pipeline" {
  name     = "followme-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.followme_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn     = aws_codestarconnections_connection.github.arn
        FullRepositoryId  = "wjdwodhs/FollowMeProject"
        BranchName        = "main"
        DetectChanges     = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["ROOT"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.followme_project.name
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name             = "DeployToEC2"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["ROOT"]
      configuration = {
        ApplicationName     = aws_codedeploy_app.followme_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.followme_deployment_group.deployment_group_name
      }
      run_order = 1
    }
  }
}
