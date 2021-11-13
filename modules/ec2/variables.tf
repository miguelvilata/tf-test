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

variable "public_key_path" {
    description = "Public key path"
    default = "~/.ssh/id_rsa.pub"
}

data "template_file" "user_data" {
  template = "modules/ec2/cloud-init/add-ssh-web-app.yaml"
  
  vars = {
#    public_key = file(var.public_key_path)
    #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWiCok+NMX2TzQfgdVad/LbVbX3SXilsGPU1CW0MG7R0BhulA9yEUyLbg4XZ4gUrxKYKBSbiVmWJOBV2N7/9qaq185tVk3dggi7XXNZkLps0MWOJEoPSbBpohXmQBDjgMb9P6DuRw0/mOYyK+A5b6tFxSTtmEFoQcOqusrrwZHGsjjCmseh+kp0u/p4W5RymLtR3hjWbgdc8Cq32W00i2fR5BcKVUt25aiRpe8NZP3BLw6iM2i+TdrlPW3813JH8ucdq/KVNdB634MCXf/7+CWpzzpWXlSA86Uxn41kEERNPABZxuOC4uJ8/9sepdlB2IAmFJyi3h/9M7hMwoiNZrGvvW1lkHT6ZPwPShLTu+6NXFqibadf1u9CdDJ+6E/o05Gh3STDj4sdIOLEc0FltRFazmhALq0oBztGAipcrnlWgwso4dGOrep8ElcR+xPHWxCLz/kh8vwUdJ7xTC+TXtX84DA5U2B+CGCrA4IV0BB+Lrm2r2IOg4yx9EVcDJCLH8= miguel@miguel-ZenBook-UX325EA-UX325EA"
    public_key = "test"
  }
}
