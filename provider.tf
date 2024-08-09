terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0" # Adjust the version as needed
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # Adjust the version as needed
    }
  }
  backend "s3" {
    bucket         = "aws-terraform-c9c98e64-state-voicenger"
    key            = "backend/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "aws-terraform-states-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "Team"      = "DevOps",
      "manage-by" = "Terraform",
      "Project"   = "voicenger"
    }
  }
}

