provider "aws" {
  region  = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name" = "custom"
  }
}

locals {
  private = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  zone    = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

resource "aws_subnet" "private_subnet" {
  count = length(local.private)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.private[count.index]
  availability_zone = local.zone[count.index % length(local.zone)]

  tags = {
    "Name" = "private-subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(local.public)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public[count.index]
  availability_zone = local.zone[count.index % length(local.zone)]

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "custom"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "public"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "public" {
  depends_on = [aws_internet_gateway.ig]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "Public NAT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public.id
  }

  tags = {
    "Name" = "private"
  }
}

resource "aws_route_table_association" "public_private" {
  for_each       = { for k, v in aws_subnet.private_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
