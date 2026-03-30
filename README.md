# packer-and-terraform

This repo contains two folders: Packer and Terraform. Packer allows us to create an AWS AMI, and Terraform allowed us to provision/create the AWS infrastructure using the AMI from Packer. 

Packer: 
- Contains: packerfile.pkr.hcl

- In this file, I created a custom AWS AMI based on Amazon Linux with Docker installed, as well as my public SSH key. This allowed me to create a template for the EC2 instances that will be built later on using Terraform. 

- To run it:
  1. Inside the folder, start by exporting your temporary AWS credentials from AWS academy into your terminal session. You will need these credentials:  AWS_KEY_ID, AWS_ACCESS_KEY, AWS_SECRET_TOKEN, AWS_REGION. This can be done by typing in export <Credential type>="YOUR_KEY".
  2. Initialize the packer file and download plugins. Run: packer init .
  3. Ensure template is valid before building the AMI. Run:  packer validate -var "public_key_path=~/.ssh/id_ed25519.pub" .
  4. Create the AMI! Run: packer build -var "public_key_path=~/.ssh/id_ed25519.pub" .

After running these commands, expect a lot of output as it builds the AMI image. Once it is done, you will text that confirms the build has finished, and the AMI ID of the new image. 
<img width="1097" height="764" alt="Screenshot 2026-03-29 at 11 19 14 PM" src="https://github.com/user-attachments/assets/02b21ee8-a252-4422-9ce1-4921840b0907" />
<img width="1215" height="197" alt="Screenshot 2026-03-29 at 11 21 23 PM" src="https://github.com/user-attachments/assets/1dbfa960-4343-41de-b51b-74f89127d365" />

To confirm, you can also view your AMIs in the AWS EC2 Console! 
<img width="1260" height="284" alt="Screenshot 2026-03-30 at 12 11 20 AM" src="https://github.com/user-attachments/assets/5d92ae36-0e6a-4a68-9077-7662c3a530fe" />

Terraform: 




