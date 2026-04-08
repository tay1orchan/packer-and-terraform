packer { //tell packer to use amazon plugin 
	required_plugins { 
		amazon = { 
			version = ">= 1.3.0"
			source = "github.com/hashicorp/amazon"
		}
	}
}

variable "aws_region" { 
	type = string
	default = "us-west-2"
}

variable "instance_type" { 
	type = string
	default = "t2.micro"
}

variable "ssh_username" { 
	type = string
	default = "ec2-user"
}

variable "public_key_path" { 
	type = string 
}

//define builder source
source "amazon-ebs" "amazonlinux" { 
	region = var.aws_region
	instance_type = var.instance_type
	ssh_username = var.ssh_username
	ami_name = "amazon-linux-ami"

	//ami base to start from 
	source_ami_filter { 
		filters = { 
			name = "al2023-ami-2023*"
		}
		owners = ["137112412989"]
		most_recent = true 
	}
}

build { 
	sources = ["source.amazon-ebs.amazonlinux"]

	//install docker 
	provisioner "shell" { 
		inline = [
			"sudo dnf install -y docker",
			"sudo systemctl enable docker"
		]
	}

	//add public key  
	provisioner "file" { 
		source = var.public_key_path
		destination = "/tmp/id.pub"
	}

	provisioner "shell" {
		inline = [
			"mkdir -p /home/ec2-user/.ssh",
			"cat /tmp/id.pub >> /home/ec2-user/.ssh/authorized_keys",
			"chown -R ec2-user:ec2-user /home/ec2-user/.ssh",
			"chmod 700 /home/ec2-user/.ssh",
			"chmod 600 /home/ec2-user/.ssh/authorized_keys"
		]
	}

	//node exporter for prometheus
	provisioner "shell" {
	  inline = [
	    "sudo dnf update -y",
	    "sudo dnf install -y wget tar",
	    "cd /tmp",
	    "wget https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz",
	    "tar -xzf node_exporter-1.10.2.linux-amd64.tar.gz",
	    "sudo cp node_exporter-1.10.2.linux-amd64/node_exporter /usr/local/bin/",
	    "echo '[Unit]' | sudo tee /etc/systemd/system/node_exporter.service",
	    "echo 'Description=Node Exporter' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo 'After=network.target' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo '' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo '[Service]' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo 'ExecStart=/usr/local/bin/node_exporter' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo '' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo '[Install]' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/node_exporter.service",
	    "sudo systemctl daemon-reload",
	    "sudo systemctl enable node_exporter",
	    "sudo systemctl start node_exporter"
	  ]
	}
}

