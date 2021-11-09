
terraform {
  required_version = ">= 0.14.9"
}

terraform {
  
# esto debería ir por entorno o tener una variable interpolada
#  backend "s3" {
#    bucket  = "terrafor-develops-dev"
#    key     = "prod.tsfatate"
#    dynamodb_table = "prod-tf-lock" #es como un redis, con esta configuración te permite hacer un lock, para que haya varias personas tocando
#  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.61.0"
    }
  }
}

provider "aws" {
}

