# You can define your variables here, but in this example everything is inline
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "my_domain" {
  description = "Base domain name"
  type        = string
}

variable "api_subdomain" {
  description = "API subdomain prefix"
  type        = string
  default     = "api"
}