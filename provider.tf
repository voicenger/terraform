terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
  backend "s3" {
    bucket = "test-23a44333s"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}



provider "aws" {
  # Configuration options
}

