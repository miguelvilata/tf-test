variable "tags" {
    type    = map(string)
    default = {}
}

data "aws_availability_zones" "available" {
  state = "available"
}