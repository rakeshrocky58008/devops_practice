
##variable



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

## pick vpc from default region by using below 
resource "aws_default_vpc" "default_Vpc" {
}





## SG - > http server -> 80 tcp , 22 TCP (ssh) , CIDR ["0.0.0.0/0"]

resource "aws_security_group" "HTTP_security_group" {
  name   = "HTTP_security_group"
  vpc_id = aws_default_vpc.default_Vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "HTTP_security_group"
  }
}


## create ec2 

resource "aws_instance" "http_server" {
  // ami = "ami-052cef05d01020f1d"
  ami                    = data.aws_ami.aws-linux-2_latest.image_id
  key_name               = "default_ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.HTTP_security_group.id]
  subnet_id              = tolist(data.aws_subnet_ids.default_subnets.ids)[1]


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                               //install httpd 
      "sudo service httpd start",                                                                                //start 
      "echo welcome to http server rakesh , server is at ${self.public_dns} | sudo tee /var/www/html/index.html" //copy a file 


    ]

  }
}
