## get default subnet from vpc 

data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.default_Vpc.id
}

## get ami for aws 
data "aws_ami" "aws-linux-2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]

  }
}
