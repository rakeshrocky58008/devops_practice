terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#config aws 

provider "aws" {
  region = "ap-south-1"

}


// S3 bucket 
//LOCKING  - Dynamo DB 

resource "aws_s3_bucket" "enterprise-backend-state" {
  bucket = "dev-applications-backend-state-rak"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"

      }
    }
  }
}

resource "aws_dynamodb_table" "enterprise-backend-lock" {
  name         = "enterprise_backend_lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


