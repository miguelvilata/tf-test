module "web_vpc" {
  source = "./modules/vpc"
}

module "module_ec2" {
  source          = "./modules/ec2"
  tags            = merge(var.default_tags, {})
  cidr_block      = "10.0.1.0/24"
  aws_vpc         = module.web_vpc.vpc_id
  aws_subnet      = module.web_vpc.subnet_id
  instance_count  = 2
}

#ver:
#https://medium.com/@mitesh_shamra/manage-aws-vpc-with-terraform-d477d0b5c9c5
