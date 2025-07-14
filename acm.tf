data "aws_acm_certificate" "issued" {
  domain       = "followmegroupware.xyz"
  statuses     = ["ISSUED"]
  most_recent  = true
}
