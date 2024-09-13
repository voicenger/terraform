# Create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = var.dynamodb_table,
    Description = "DynamoDB terraform table to lock states"
  }
}

# Create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform_state" {
  bucket              = "aws-terraform-${random_id.id.hex}-state-voicenger"
  object_lock_enabled = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Description = "S3 Remote Terraform State Store"
  }
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_s3" {
#   bucket = aws_s3_bucket.terraform_state.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykeys3state.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# resource "aws_kms_key" "mykeys3state" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

# resource "aws_kms_alias" "mykeys3state" {
#   name          = "alias/mykeys3state"
#   target_key_id = aws_kms_key.mykeys3state.key_id
# }

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_id" "id" {
  byte_length = 4
}