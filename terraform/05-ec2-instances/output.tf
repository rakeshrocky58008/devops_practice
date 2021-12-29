output "aws_security_group" {
  value = aws_security_group.HTTP_security_group
}

output "aws_instance" {
  value = aws_instance.http_server
}

output "aws_dns" {
  value = aws_instance.http_server.public_dns
}