data "aws_availability_zones" "availability_zones" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "styrinov" {
  name         = var.my_domain
  private_zone = false
}

data "aws_route53_zone" "primary" {
  name         = "styrinov.com.ua."
  private_zone = false
}
