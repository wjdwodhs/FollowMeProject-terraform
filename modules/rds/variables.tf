variable "identifier" {
  type = string
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "engine" {
  type    = string
  default = "mysql"
}
variable "engine_version" {
  type    = string
  default = "8.0"
}
variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "db_name" {
  type = string
}
variable "port" {
  type    = number
  default = 3306
}
variable "security_group_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "subnet_group_name" {
  type = string
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "skip_final_snapshot" {
  type    = bool
  default = true
}
