variable "domain_name" {
  description = "도메인 이름 (예: followmegroupware.xyz.)"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS 이름"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB의 호스팅 영역 ID"
  type        = string
}
