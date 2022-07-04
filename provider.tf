provider "aws" {
  region = var.default_region

  assume_role {
    role_arn = var.provider_role_arn
  }
}

# terraform {
#   required_version = ">= 0.13.0"
# }
