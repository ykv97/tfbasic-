terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.vpc_id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
   tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public"
  }
}


resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "gateway"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route" "r" {
  route_table_id = aws_route_table.internet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}