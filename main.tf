
module "web_vpc" {
  path = "./modules/vpc"
}

module "web_server_prod" {
  tags            = merge(var.default_tags, {})
  path            = "./modules/ec2"
  cidr_block      = "10.0.1.0/24"
  instance_count  = 2
}

module "web_server_staging" {
  tags            = merge(var.default_tags, {})
  path            = "./modules/ec2"
  cidr_block      = "10.0.1.0/24"
  instance_count  = 1
}

#ver:
#https://medium.com/@mitesh_shamra/manage-aws-vpc-with-terraform-d477d0b5c9c5
