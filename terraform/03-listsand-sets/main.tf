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

variable "names" {
   
    default = ["r1","r2","r3"] 
}

resource "aws_iam_user" "my_iam_user" {
    count =length(var.names)
    name = var.names[count.index]
  
}