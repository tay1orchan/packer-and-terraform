#Use AWS as provider 

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

#AWS resources
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}


#allow ssh only from my ip
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#allow ssh from bastion
resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#bastion host
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "bastion-host"
  }
}

#6 ec2 instances 
resource "aws_instance" "private_instances" {
  count                  = 6
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_instance_private_ips" {
  value = aws_instance.private_instances[*].private_ip
}
