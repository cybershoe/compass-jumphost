terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployment_keypair" {
  key_name_prefix = var.prefix
  public_key      = var.public_key_openssh
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(var.tags, {
    Name = "${var.prefix}-jumphosts-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = "${var.prefix}-jumphosts-igw"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.prefix}-jumphosts-public-subnet"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, {
    Name = "${var.prefix}-jumphosts-public-rt"
  })
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

output "keypair_name" {
  value = aws_key_pair.deployment_keypair.key_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}