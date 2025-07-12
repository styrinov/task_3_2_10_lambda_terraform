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

variable "env" {
  type    = string
  default = "dev"
}

variable "lambda_function_name" {
  type    = string
  default = "http-crud-tutorial-function"
}

variable "api_gateway_name" {
  type    = string
  default = "http-crud-tutorial-api"
}

variable "dynamodb_table_name" {
  type    = string
  default = "http-crud-tutorial-items"
}

variable "lord_of_terraform" {
  description = "Owner of this project"
  type        = string
  default     = "Serhii Tyrinov"
}