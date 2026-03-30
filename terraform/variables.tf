#Set variables 
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "ami_id" { #ami from ec2 instance by packer 
  type = string
}

variable "my_ip" { #public ip addr
  type = string
}

variable "key_name" {
  type = string
}
