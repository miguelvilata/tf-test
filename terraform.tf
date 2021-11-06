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

variable "public_key_path" {
    description = "Public key path"
    default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
    type    = map(string)
    default = { "Author" = "Terraformed Automated (UVE)", "Env" = "Prod", "Name" = "UVE" }
}

# provider "aws" {
#   region  = "eu-west-1"
#   profile = "geekshubs"
# }

#vpc aquí es una label interna
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.16.0/24"
  instance_tenancy = "default"

  tags = merge({ name = "VPC test" }, var.tags)
}

resource "aws_subnet" "subnet" {
  vpc_id                    = aws_vpc.vpc.id
  #cidr_block               = "10.0.16.0/24"
  cidr_block                = aws_vpc.vpc.cidr_block #para coger todo el bloque de ips
  availability_zone         = "eu-west-1a"

  tags = merge({ name = "Subnet public" }, var.tags)
}

#route table que utiliza el gateway
#--> me indica el profe, que aquí se debeŕia modificar la ruta existente o algo así
#--> aquí lo que estaría haciendo es crear una nueva


/*
el ha utilizado una data, para localizar la route table de la vpc y luego agregar el GT"
data "aws_route_table" "table_id" {
    vpc_id = aws_vpc.my_vpc.id_rsa
    depends_on = [aws_vpc-my_vpc]
}

resource "aws_route" "ruta" {
    route_table_id = data.aws_route_table.table_id.id
    gateway_id = aws_internet_gateway.gw.id
    destination_cidr_block = "0.0.0.0/0"
}
*/

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
  
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = merge({ name = "Route table" }, var.tags)
}

#asociar la ruta a la subnet, para conectarla con el gateway
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ name = "Internet Gateway" }, var.tags)
}

resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "sg_ssh_http" {
  name = "sg_ssh_http"

  vpc_id = aws_vpc.vpc.id
  
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
  tags = merge({ name = "http & ssh access" }, var.tags)
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
  instance_type                 = "t3.micro"
  subnet_id                     = aws_subnet.subnet.id
  associate_public_ip_address   = true
  vpc_security_group_ids        = [aws_security_group.sg_ssh_http.id]

  #ssh bitnami@ip
  key_name                      = aws_key_pair.ec2key.key_name

  tags = merge({ name = "EC2 instance" }, var.tags)
}

output "app_server_ip" {
    value = aws_instance.app_server.public_ip
}

#crear internet gateway
#   añadir ruta



#ver:
#https://medium.com/@mitesh_shamra/manage-aws-vpc-with-terraform-d477d0b5c9c5