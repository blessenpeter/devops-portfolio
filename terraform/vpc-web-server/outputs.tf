output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_a.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_a.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "ami_id" {
  value = data.aws_ami.al2023.id
}

output "ami_name" {
  value = data.aws_ami.al2023.name
}

output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}