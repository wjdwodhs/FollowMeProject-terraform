resource "aws_s3_bucket" "followme_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "followme_bucket" {
  bucket = aws_s3_bucket.followme_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "followme_bucket" {
  bucket = aws_s3_bucket.followme_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "followme_bucket" {
  bucket = aws_s3_bucket.followme_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
