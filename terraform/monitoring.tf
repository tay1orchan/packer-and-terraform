resource "aws_security_group" "monitoring_sg" {
  name   = "monitoring-sg"
  vpc_id = module.vpc.vpc_id

  //ssh from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]

  }

  //access to grafana 
  ingress {
    description     = "Grafana from bastion"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  //access to prometheus
  ingress {
    description     = "Prometheus UI from bastion"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "monitoring_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = file("${path.module}/monitoring.tftpl")



}
