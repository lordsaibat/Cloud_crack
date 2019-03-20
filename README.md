# Cloud Crack

## Background
Password cracking rigs are expensive and sometimes not utilized a lot. So one way to still be able to still crack passwords is to use AWS. This project utilizes terraform to spin up infrastructure quickly, crack the passwords, cat it out, and destroy the infrastructure. 

## Steps
### Setup Password Bucket
#### Background
In order to save time on getting the instance spun up we rely on an S3 bucket to store your password list(s). The module will create the S3 bucket based on your input, upload the files, create an IAM user/group, and generate bucket credentials to use in the instance. This module only needs to be ran once, it can be ran multiple times to upload different files. 

##### Todos
1. Place your files in the S3/files directory (I have included two as an example). 
2. Edit S3/modules/S3/files.tf to add each file in the above step.
3. Edit S3/cloudbucket.tf, change bucket-name/directory-name to something unique
4. Run terraform in the S3 directory, terraform apply

Once terraform is done, make note of the ID and secret in the terminal this is needed for the EC2 deployment.

### Setup EC2 Password Cracker
#### Background
Terraform will spin up the instance, install hashcat, copy over the password/fuse conf for the S3 bucket connection, place it in the correct directories, copy over the crackme, and run hashcat. Once hashcat is completed, the cracked.txt file will be cat to the terminal. 

#### Todos
1. Edit Cloud_crack/config/.passwd-s3fs file, place the ID and secret from the S3 bucket section.
2. Edit Cloud_crack/crack/crackme.txt
3. Place SSH key or Generate one in ssh_keys directory. The private key needs to be named ec2_host_key and public key ec2_host_key.pub. There is a Powershell script that will generate a key in Cloud_crack\Gen-keys.ps1/
4. Edit Cloud/cloudcrack.tf file:
 - Change instance if desired
 - Change hash_op to options you are going to use *if you forgot the options check Cloud_crack/README.md
 - Change word_lists to the names of the files in your bucket
 - Change bucket_name to the name of the bucket in the S3 module
5. Run Terraform:
   terraform.exe apply -var "hash_op=-m 5600" & terraform.exe destroy

 


