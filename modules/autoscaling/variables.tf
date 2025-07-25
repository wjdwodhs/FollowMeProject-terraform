variable "name" {
  type        = string
  description = "Name of the Auto Scaling Group"
}

variable "max_size" {
  type        = number
  description = "Maximum number of EC2 instances"
}

variable "min_size" {
  type        = number
  description = "Minimum number of EC2 instances"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group"
}

variable "launch_template_id" {
  type        = string
  description = "ID of the launch template"
}

variable "launch_template_version" {
  type        = string
  description = "Version of the launch template"
}

variable "instance_name_tag" {
  type        = string
  description = "Value for Name tag of instances"
}
