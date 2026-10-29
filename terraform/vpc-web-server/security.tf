# Security group for the web server
resource "aws_security_group" "web" {
  name        = "${var.project}-web-sg"
  description = "Allow HTTP in, all traffic out"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project}-web-sg"
  }
}

# Inbound: HTTP (port 80) from anywhere
resource "aws_vpc_security_group_ingress_rule" "http_in" {
  security_group_id = aws_security_group.web.id
  description       = "HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Outbound: all traffic (the server downloads software at boot)
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.web.id
  description       = "All outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}