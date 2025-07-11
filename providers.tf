provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner = var.lord_of_terraform
    }
  }
}
