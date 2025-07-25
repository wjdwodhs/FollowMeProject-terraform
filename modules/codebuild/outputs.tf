output "connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "project_name" {
  value = aws_codebuild_project.followme_project.name
}
