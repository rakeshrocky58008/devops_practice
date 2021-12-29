terraform {
    required_providers{
        aws = {
            source= "hashicorp/aws"
            version="~>3.0"
        }
    }
}

#config aws 

provider "aws" {
    region = "ap-south-1"

}

resource "aws_iam_user" "iam_user" {
  name = "iam_user_terraform_001"

}

resource "aws_s3_bucket" "s3_bucket" {
   bucket = "s3-bucket-iac-terraform-001"
}


