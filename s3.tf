resource "aws_s3_bucket" "example" {
  bucket = "terraform-backend123a456s"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "test" {
  bucket = "test-23a44333s"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

