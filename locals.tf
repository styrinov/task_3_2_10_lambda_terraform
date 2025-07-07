locals {
  cert_validation_option = tolist(aws_acm_certificate.api_cert.domain_validation_options)[0]
  api_domain_name        = "${var.api_subdomain}.${var.my_domain}"
}
