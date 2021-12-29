output "aws_security_group" {
  value = aws_security_group.elb_sg
}

output "aws_instance" {
  value = aws_instance.http_servers
}

output "aws_dns" {
  value = values(aws_instance.http_servers).*.id
}

output "elb_pblic_dns" {
  value = aws_elb.elb
}