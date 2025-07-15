resource "aws_codedeploy_app" "followme_app" {
  name             = "followme-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "followme_deployment_group" {
  app_name              = aws_codedeploy_app.followme_app.name
  deployment_group_name = "followme-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                         = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }

    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.followme_tg.name
    }  
  }

  autoscaling_groups = [aws_autoscaling_group.followme_asg.name]

  lifecycle {
    create_before_destroy = true
  }

}
