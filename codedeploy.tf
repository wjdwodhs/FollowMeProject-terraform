resource "aws_codedeploy_app" "followme_app" {
  name             = "followme-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "followme_deployment_group" {
  app_name              = aws_codedeploy_app.followme_app.name
  deployment_group_name = "followme-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "followme-ec2"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
