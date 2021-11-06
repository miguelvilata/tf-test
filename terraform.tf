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

variable "tags" {
    type    = map(string)
    default = { "Author" = "Terraformed Automated", "Env" = "Prod" }
}

# provider "aws" {
#   region  = "eu-west-1"
#   profile = "geekshubs"
# }

#vpc aquí es una label interna
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.16.0/24"
  instance_tenancy = "default"

  tags = merge({ Name = "VPC test" }, var.tags)
}

resource "aws_subnet" "subnet" {
  vpc_id                    = aws_vpc.vpc.id
  #cidr_block               = "10.0.16.0/24"
  cidr_block                = aws_vpc.vpc.cidr_block #para coger todo el bloque de ips
  availability_zone         = "eu-west-1a"

  tags = merge({ Name = "Subnet public" }, var.tags)
}

#route table que utiliza el gateway
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
  
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = merge({ Name = "Route table" }, var.tags)
}

#asociar la ruta a la subnet, para conectarla con el gateway
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = "${aws_route_table.route_table_public.id}"
}

resource "aws_network_interface" "network_interface_uve" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["10.0.16.101"]

  tags = merge({ Name = "Private network public" }, var.tags)
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ Name = "Internet Gateway" }, var.tags)
}

data "aws_ami" "nginx" {
    owners = ["979382823631"]

    filter {
        name   = "name"
        values = ["bitnami-nginx-1.18.0-32-r09-linux-debian-10-x86_64-hvm-ebs-nami*"]
    }
}

resource "aws_instance" "app_server" {
  #ami           = "ami-0ed961fa828560210" #el problema del amiid es que pueden ser deprecadas (y lo són), aparte la ami con ese id está diponible sólo para una región
  ami                           = data.aws_ami.nginx.id
  instance_type                 = "t2.micro"
  subnet_id                     = aws_subnet.subnet.id
  associate_public_ip_address   = true

#  network_interface {
#    network_interface_id = aws_network_interface.network_interface_uve.id
#    device_index         = 0
#  }  

  tags = merge({ Name = "EC2 instance" }, var.tags)
}

output "app_server_ip" {
    value = aws_instance.app_server.public_ip
}

#crear internet gateway
#   añadir ruta