variable "codebuild_role_arn" {
  type        = string
  description = "IAM role ARN for CodeBuild"
}

variable "artifact_bucket" {
  type        = string
  description = "S3 bucket for build artifacts"
}

variable "github_repo_url" {
  type        = string
  description = "GitHub repository URL for the source"
}
