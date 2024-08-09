variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "aws-terraform-states-lock"
}

variable "aws_region" {
  description = "AWS Region for AWS"
  default     = "eu-central-1"
}