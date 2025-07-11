output "public_ip" {
  value = aws_eip.followme_eip.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.followme_bucket.bucket
}
