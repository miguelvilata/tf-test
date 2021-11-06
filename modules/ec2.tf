
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file(var.public_key_path)
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

