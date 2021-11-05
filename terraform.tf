terraform {
  required_version = ">= 0.14.9"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.61.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "geekshubs"
}

#vpc_uve aquí es una label interna
resource "aws_vpc" "vpc_uve" {
  cidr_block       = "10.0.16.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "uve"
  }
}

resource "aws_subnet" "subnet_uve" {
  vpc_id            = aws_vpc.vpc_uve.id
  cidr_block        = "10.0.16.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "uve subnet example"
  }
}

resource "aws_network_interface" "network_interface_uve" {
  subnet_id   = aws_subnet.subnet_uve.id
  private_ips = ["10.0.16.101"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0ed961fa828560210"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.network_interface_uve.id
    device_index         = 0
  }  
}