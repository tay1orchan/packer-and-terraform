#Set variables 
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "my_ip" { #public ip addr
  type = string
}

variable "key_name" {
  type = string
}
