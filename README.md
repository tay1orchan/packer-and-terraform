# packer-and-terraform

This repo contains two folders: Packer and Terraform. Packer allows us to create an AWS AMI, and Terraform allowed us to provision/create the AWS infrastructure using the AMI from Packer. 

Packer: 
- Contains: packerfile.pkr.hcl

- In this file, I created a custom AWS AMI based on Amazon Linux with Docker installed, as well as my public SSH key. This allowed me to create an AMI for the EC2 instances that will be built later on using Terraform. 

- To run it:
  1. Inside the folder, start by exporting your temporary AWS credentials from AWS academy into your terminal session. You will need these credentials:  AWS_KEY_ID, AWS_ACCESS_KEY, AWS_SECRET_TOKEN, AWS_REGION. This can be done by typing in export <Credential type>="YOUR_KEY".
  2. Initialize the packer file and download plugins. Run: packer init .
  3. Ensure template is valid before building the AMI. Run:  packer validate -var "public_key_path=~/.ssh/id_ed25519.pub" .
  <img width="752" height="76" alt="Screenshot 2026-03-30 at 10 30 30 AM" src="https://github.com/user-attachments/assets/70ed5fec-7da9-40c5-8a0d-86b4500738f9" />
  
  4. Create the AMI! Run: packer build -var "public_key_path=~/.ssh/id_ed25519.pub" .

Expected Result: 
After running these commands, expect a lot of output as it builds the AMI image. Once it is done, the output will confirm that the build has finished, and will display the AMI ID of the new image. Make sure to save it! 
<img width="1097" height="764" alt="Screenshot 2026-03-29 at 11 19 14 PM" src="https://github.com/user-attachments/assets/02b21ee8-a252-4422-9ce1-4921840b0907" />
<img width="902" height="382" alt="Screenshot 2026-03-30 at 10 39 42 AM" src="https://github.com/user-attachments/assets/ea706cb6-00af-40cf-b420-5930bd572caa" />

To confirm, you can also view your AMIs in the AWS EC2 Console! 
<img width="1260" height="284" alt="Screenshot 2026-03-30 at 12 11 20 AM" src="https://github.com/user-attachments/assets/5d92ae36-0e6a-4a68-9077-7662c3a530fe" />

Terraform: 
- Contains: main.tf, variables.tf, output.tf

- In this file, I created Terraform scripts to configure/provision my AWS resources. I used the ami id given when building on Packer to create 6 ec2 instances, bastion host, vpc, and subnets.

- To run it:
  1. Create a file to store environment variables, such as region, ami-id, key_name, and your public IP. 
  2. From terraform folder, run: terraform init.
  <img width="670" height="229" alt="Screenshot 2026-03-30 at 10 44 07 AM" src="https://github.com/user-attachments/assets/20dfc0f3-8a0e-442a-b961-fa5eb64b2ba7" />
  
  3. Check that the configuration is valid! Run: terraform validate
  4. Run: terraform plan
  5. To build, run: terraform apply
 
  Expected Result: 
  At the end of the output, you should see a message prompting you to enter a value. Type "yes", and the provisioning will begin. This will produce a lot of output as everything is being configured. The end result will give you your bastion public ip as well as the 6 ec2 instances that were created. Make sure you save the bastion public ip and at least one of the ec2 instance ips! 
<img width="933" height="790" alt="Screenshot 2026-03-30 at 12 03 19 AM" src="https://github.com/user-attachments/assets/127904ad-4e61-4bdb-9bdf-e8cd21c4b5a8" />

To connect to your private EC2 instances from Bastion host: 
1. From terminal, ssh into the bastion host with command: ssh -A -i /Path/to_pub_key/.ssh/id_ed25519 ec2-user@<bastion_host_ip>
2. While sshed into bastion host, SSH into one of the 6 EC2 instances. Use command: 
<img width="837" height="468" alt="Screenshot 2026-03-30 at 10 56 46 AM" src="https://github.com/user-attachments/assets/eba6d6f2-fd7e-4e2a-b62d-31139415291b" />

Now you have successfully connected to a private instance from the bastion host! If you want to check the other instances, repeat step 2. 

Once done, make sure to delete infrastructure resources, using terraform destroy command. 


<img width="567" height="213" alt="Screenshot 2026-03-30 at 6 06 02 PM" src="https://github.com/user-attachments/assets/82489b4d-a8e3-46b3-8c74-3694a6573837" />


PROMETHEUS AND GRAFANA (Assignment #9): 
  Continuing with packer and terraform, this assignment incorporates a monitoring EC2 instance into the private subnet. To do so, a script that installs both Prometheus and Grafana is necessary, as well as re-configuring the AMI in Packer so that Prometheus can access its data. 

  Instructions on how to run: 
  1. Once Packer and Terraform are both changed to incorporate Prometheus and Grafana, repeat the same instructions as above. Be sure to note the new AMI ID, and put that into the Terraform variables file.
  2. After running Terraform apply, the output should return the bastion public IP, the six EC2 instance private IPs, and the monitoring private IP. Be sure to note the bastion and monitoring IPs. 

<img width="813" height="201" alt="Screenshot 2026-04-01 at 2 30 10 AM" src="https://github.com/user-attachments/assets/5bbe5083-cdb9-4cce-a2d4-1739233e3ce2" />
  3. Use the given Bastion IP to ssh into it. Run the same command as above: ssh -A -i /Path/to_pub_key/.ssh/id_ed25519 ec2-user@<bastion_host_ip>
  4. From the bastion, now SSH into the monitoring instance. Here, we will perform checks on the Prometheus and Grafana servers to make sure they are up. Use command: ssh -i /Path/to_pub_key/.ssh/id_ed25519 ec2-user@<monitoring_ip>
  
<img width="951" height="413" alt="Screenshot 2026-04-01 at 2 30 50 AM" src="https://github.com/user-attachments/assets/208363c3-5e5f-4b16-b52f-76d604eff020" />

5. Run these commands to check their states (should be active):
   - sudo systemctl status prometheus
   - sudo systemctl status grafana-server
   <img width="1342" height="312" alt="Screenshot 2026-04-01 at 1 44 32 AM" src="https://github.com/user-attachments/assets/48e7f436-8648-4fd6-8499-1a91e87fa369" />
   <img width="1350" height="321" alt="Screenshot 2026-04-01 at 1 44 52 AM" src="https://github.com/user-attachments/assets/b66de242-36c6-46ea-8681-34f8ecbf2118" />


