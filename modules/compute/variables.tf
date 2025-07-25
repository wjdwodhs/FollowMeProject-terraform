variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "ec2_sg_id" {}
variable "iam_instance_profile" {}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}

variable "desired_capacity" {
  default = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {}
