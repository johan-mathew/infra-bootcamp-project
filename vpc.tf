resource "aws_vpc" "team_3_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_vpc"
  }
}

resource "aws_subnet" "team_3_subnet_public_1" {
  vpc_id                  = aws_vpc.team_3_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_subnet_public_1"
  }
}

resource "aws_subnet" "team_3_subnet_public_2" {
  vpc_id                  = aws_vpc.team_3_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_subnet_public_2"
  }
}
resource "aws_internet_gateway" "team_3_ig" {
  vpc_id = aws_vpc.team_3_vpc.id

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_internet_gateway"
  }
}

resource "aws_route_table" "team_3_rt" {
  vpc_id = aws_vpc.team_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team_3_ig.id
  }
  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_rt"
  }
}

resource "aws_route_table_association" "team_3_rta_public_1" {
  subnet_id      = aws_subnet.team_3_subnet_public_1.id
  route_table_id = aws_route_table.team_3_rt.id
}

resource "aws_route_table_association" "team_3_rta_public_2" {
  subnet_id      = aws_subnet.team_3_subnet_public_2.id
  route_table_id = aws_route_table.team_3_rt.id
}

resource "aws_network_acl" "team_3_nacl" {
  vpc_id = aws_vpc.team_3_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "49.37.191.15/32"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 99
    action     = "allow"
    cidr_block = "103.170.54.87/32"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 98
    action     = "allow"
    cidr_block = "49.37.33.223/32"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_nacl"
  }
}