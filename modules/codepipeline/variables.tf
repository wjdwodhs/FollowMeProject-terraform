variable "pipeline_name" {
  type        = string
  description = "CodePipeline name"
}

variable "pipeline_role_arn" {
  type        = string
  description = "IAM role ARN for CodePipeline"
}

variable "artifact_bucket" {
  type        = string
  description = "S3 bucket name for artifact storage"
}

variable "connection_arn" {
  type        = string
  description = "CodeStar Connection ARN"
}

variable "repository_id" {
  type        = string
  description = "GitHub repo: owner/repo"
}

variable "branch" {
  type        = string
  description = "GitHub branch name"
}

variable "codebuild_project_name" {
  type        = string
  description = "CodeBuild project name"
}

variable "codedeploy_app_name" {
  type        = string
  description = "CodeDeploy application name"
}

variable "codedeploy_group_name" {
  type        = string
  description = "CodeDeploy deployment group name"
}
