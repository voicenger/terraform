terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend123a456s"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}



provider "aws" {
  # Configuration options
}

