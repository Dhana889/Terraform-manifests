resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-MyVPC"
  }
}

resource "aws_subnet" "public1a" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1a_cidr_block_public
  availability_zone       = var.subnet_az_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Public-Subnet-1a"
  }
}

resource "aws_subnet" "public1b" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1b_cidr_block_public
  availability_zone       = var.subnet_az_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Public-Subnet-1b"
  }
}

resource "aws_subnet" "private1a" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1a_cidr_block_private
  availability_zone       = var.subnet_az_1a
  map_public_ip_on_launch = false

  tags = {
    Name = "Terraform-Private-Subnet-1a"
  }
}

resource "aws_subnet" "private1b" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1b_cidr_block_private
  availability_zone       = var.subnet_az_1b
  map_public_ip_on_launch = false

  tags = {
    Name = "Terraform-Private-Subnet-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Terraform-Internet-Gateway"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Terraform-Public-RouteTable"
  }
}

resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "172.33.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "Terraform-Private-RouteTable"
  }
}

resource "aws_route_table_association" "pvtrt1a" {
  subnet_id      = aws_subnet.private1a.id
  route_table_id = aws_route_table.Private.id
}

resource "aws_route_table_association" "pvtrt1b" {
  subnet_id      = aws_subnet.private1b.id
  route_table_id = aws_route_table.Private.id
}

resource "aws_main_route_table_association" "mainroute" {
  vpc_id         = aws_vpc.myvpc.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "allow_tls_Public"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "allow_tls_private" {
  name        = "allow_tls_private"
  description = "Allow TLS inbound traffic from Public security group and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "allow_tls_private"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_http_1" {
  security_group_id            = aws_security_group.allow_tls_private.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
  referenced_security_group_id = aws_security_group.allow_tls.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ssh_1" {
  security_group_id            = aws_security_group.allow_tls_private.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
  referenced_security_group_id = aws_security_group.allow_tls.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_mysql_1" {
  security_group_id            = aws_security_group.allow_tls_private.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.allow_tls.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id            = aws_security_group.allow_tls_private.id
  ip_protocol                  = "-1" # semantically equivalent to all ports
  referenced_security_group_id = aws_security_group.allow_tls.id
}