provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner = var.lord_of_terraform
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
