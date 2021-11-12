#el scope de estas variables es root
variable "tags" {
    type    = map(string)
    default = {}
}

variable "aws_vpc" {
    type = string
} 

variable "aws_subnet" {
    type = string
} 

variable "cidr_block" {
    type = string
} 

variable "instance_count" {
    type = number
} 

data "template_file" "user_data" {
  template = file("./scripts/add-ssh-web-app.yaml")
}

variable "public_key_path" {
    description = "Public key path"
    default = "~/.ssh/id_rsa.pub"
}
