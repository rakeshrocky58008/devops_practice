
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


variable  application_name {
  default = "07-backend-state"
  
}
variable project_name {
  default = "users"
}

variable environment {
  default = "dev"
}

terraform{
  backend "s3"{
    bucket = "dev-applications-backend-state-rak"
    key = "07-backend-state-users-dev"
    region = "ap-south-1"
    dynamodb_table = "enterprise_backend_lock"
    encrypt = true
  }
}







resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user"
  
}

