resource "aws_security_group" "safeground_aws_sg" {
    name = "safeground-security-group"
    description = "allow ssh, http/https and tcp on port 3000 ingress traffic and all egress traffic"
    vpc_id = aws_vpc.safeground_aws_vpc.id
    tags = {
        Name = "safeground-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.safeground_aws_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 22
  to_port             = 22
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.safeground_aws_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 80
  to_port             = 80
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.safeground_aws_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 443
  to_port             = 443
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
  security_group_id = aws_security_group.safeground_aws_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 3000
  to_port             = 3000
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.safeground_aws_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "-1"   
}