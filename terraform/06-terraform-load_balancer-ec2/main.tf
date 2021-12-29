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

resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
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

}


## load balancer 

resource "aws_elb" "elb" {
  name = "elb"
  subnets = toset(slice(tolist(data.aws_subnet_ids.default_subnets.ids),0,2))
  security_groups = [aws_security_group.elb_sg.id]
  instances = values(aws_instance.http_servers).*.id

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

}


## create ec2 

resource "aws_instance" "http_servers" {
  // ami = "ami-052cef05d01020f1d"
  ami                    = data.aws_ami.aws-linux-2_latest.image_id
  key_name               = "default_ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.elb_sg.id]
  
 /* subnets for each avaiable in ec2 for region hence for_each loop 
 aws_subnet_ids.default_subnets.ids -> gives sets of all subenets available
  */
 
 for_each = toset(slice(tolist(data.aws_subnet_ids.default_subnets.ids),0,2))
 subnet_id = each.value

 tags = {

   name : "http_servers_$(each.value)"
 }


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
