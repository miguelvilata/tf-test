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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ name = "Internet Gateway" }, var.tags)
}

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

