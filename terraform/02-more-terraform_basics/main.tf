terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "3.70"
        }
    }
}

provider "aws"  {
    region = "ap-south-1"
  
}

variable "iam_username_prefix" {
    type = string 
    default = "my_iam_user" 
}

resource "aws_iam_user" "my_iam_user" {
    count =2
    name = "${var.iam_username_prefix}_exmp_${count.index}"
  
}