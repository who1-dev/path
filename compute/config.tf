terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.87"
    }
  }
  backend "s3" {
    bucket = "pathomics-infra-state-05f8hes"
    key    = "compute/terraform.tfstate"
    region = "us-east-2"
  }
  required_version = ">= 0.13" # Ensure you're using Terraform 0.13 or newer
}

provider "aws" {
  region = module.common.default_region # Change to your preferred AWS region
}