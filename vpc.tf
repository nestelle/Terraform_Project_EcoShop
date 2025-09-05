# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ecosop-vpc" # orthographe respectée selon cahier des charges
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${var.project_name}-igw" }
}

# Subnets
locals {
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  private_db_subnets  = ["10.0.100.0/24", "10.0.200.0/24"]
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in local.public_subnets : idx => cidr }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-public-${each.key}" }
}

resource "aws_subnet" "private_app" {
  for_each = { for idx, cidr in local.private_app_subnets : idx => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]
  tags = { Name = "${var.project_name}-app-${each.key}" }
}

resource "aws_subnet" "private_db" {
  for_each = { for idx, cidr in local.private_db_subnets : idx => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]
  tags = { Name = "${var.project_name}-db-${each.key}" }
}

# EIP & NAT Gateway (dans le 1er subnet public)
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = { Name = "${var.project_name}-nat" }
  depends_on    = [aws_internet_gateway.igw]
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project_name}-app-rt" }
}

resource "aws_route_table_association" "private_app_assoc" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project_name}-db-rt" }
}

resource "aws_route_table_association" "private_db_assoc" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}