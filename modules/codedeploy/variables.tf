variable "app_name" {
  type        = string
  description = "Name of the CodeDeploy application"
}

variable "deployment_group_name" {
  type        = string
  description = "Name of the CodeDeploy deployment group"
}

variable "service_role_arn" {
  type        = string
  description = "IAM Role ARN for CodeDeploy"
}

variable "target_group_name" {
  type        = string
  description = "Name of the target group used by the load balancer"
}

variable "autoscaling_group_name" {
  type        = string
  description = "Name of the Auto Scaling Group"
}
