provider "aws" {
  region  = "us-east-2"
  profile = "terraform"
}

terraform {
  backend "s3" {
    bucket         = "defn-bootstrap-remote-state"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    profile        = "terraform"
    dynamodb_table = "defn-bootstrap-remote-state"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "defn-bootstrap-remote-state"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }

    bucket_key_enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name                        = "defn-bootstrap-remote-state"
  deletion_protection_enabled = true
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
