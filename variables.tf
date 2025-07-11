# You can define your variables here, but in this example everything is inline
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "env" {
  type        = string
  default = "dev"
}

variable "lambda_function_name" {
  default = "http-crud-tutorial-function"
}

variable "api_gateway_name" {
  default = "http-crud-api"
}

variable "dynamodb_table_name" {
  default = "notes-table"
}

variable "lord_of_terraform" {
  description = "Owner of this project"
  type        = string
  default     = "Serhii Tyrinov"
}
