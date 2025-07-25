variable "bucket_name" {
  type        = string
  description = "S3 버킷 이름"
}

variable "environment" {
  type        = string
  description = "배포 환경 (예: dev, prod)"
}
