output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "amazon_instance_private_ips" {
  value = aws_instance.amazon_instances[*].private_ip
}

output "ubuntu_instance_private_ips" {
  value = aws_instance.ubuntu_instances[*].private_ip
}

output "monitoring_private_ip" {
  value = aws_instance.monitoring_instance.private_ip
}

output "ancible_ip" { 
  value = aws_instance.ansible_controller.private_ip


}
