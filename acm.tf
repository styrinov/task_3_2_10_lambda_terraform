resource "aws_acm_certificate" "api_cert" {
  domain_name       = local.api_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.cert_validation_option.resource_record_name
  type    = local.cert_validation_option.resource_record_type
  records = [local.cert_validation_option.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api_cert_validation" {
  certificate_arn         = aws_acm_certificate.api_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
