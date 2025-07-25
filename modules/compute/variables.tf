variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "user_data_path" {
  default = "userdata.sh"
}
variable "ec2_sg_id" {}
variable "iam_instance_profile" {}
variable "subnet_ids" {
  description = "List of subnet IDs for EC2 or ASG"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group ARN for ASG"
  type        = string
}
