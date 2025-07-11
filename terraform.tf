terraform {
  required_version = "1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
  }

  backend "s3" {
    bucket = "0b9ec6a0-4338-4faf-b5d3-ae79aedd8089-terraform-state-bucket"
    key    = "terraform_state_test/terraform.tfstate"
    region = "eu-north-1"
  }
}