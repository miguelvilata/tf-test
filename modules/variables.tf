#el scope de estas variables son los módulos, aquí 
variable "public_key_path" {
    description = "Public key path"
    default = "~/.ssh/id_rsa.pub"
}

variable "default_tags" {
    type    = map(string)
    default = { "Author" = "Terraformed Automated (UVE)", "Env" = "Prod", "Name" = "UVE" }
}

variable "cidr_block" {

}

variable "instance_count" {
    type = number
}
