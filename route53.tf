# Route53의 호스팅 영역 가져오기
data "aws_route53_zone" "main" {
  name = "followmegroupware.xyz."
}

# A레코드: 도메인을 ALB에 연결
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "followmegroupware.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.followme_alb.dns_name
    zone_id                = aws_lb.followme_alb.zone_id
    evaluate_target_health = true
  }
}

# www 서브도메인도 ALB로 연결
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.followmegroupware.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.followme_alb.dns_name
    zone_id                = aws_lb.followme_alb.zone_id
    evaluate_target_health = true
  }
}
