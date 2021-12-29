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

variable "users" {

  default = {
    rak : { country : "r1", def : "add" },
    u : { country : "r2", def : "dwfew" },
    j : { country : "r3", def : "dsdssd " }
  }
}

resource "aws_iam_user" "my_iam_user" {

  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
  }
}
