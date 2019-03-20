terraform {
  required_version = ">= 0.11.0"
}

// Create VPC for AWS instances

module "create_vpc" {
  source = "./modules/aws/create-vpc"
}

// -------------------------------------

module "host" {
  source = "./modules/aws/host"
  location = "us-east-1"
  instance_type = "p2.xlarge" #change based on size t2.micro p2.xlarge p2.8xlarge p2.16xlarge
  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"
  //change this to the hash your going to crack and other options
  hash_op = "-m 5600" 
  //change this to each wordlist seperated by space
  word_lists = "/home/ec2-user/wordlists/0-9.txt /home/ec2-user/wordlists/Top207-probable-v2.txt"
  //change this to your bucket name
  bucketname = "my-password-bucket"
  //private key location (Windows)
  pem_file_location= "${file(".\\ssh_keys\\ec2_host_key")}"
  //private key location (Linux)
  //pem_file_location= "${file("./ssh_keys/ec2_host_key")}"
  //private key location (Windows)
  pub_file_location= "${file(".\\ssh_keys\\ec2_host_key.pub")}"
  //private key location (Linux)
  //pub_file_location= "${file("./ssh_keys/ec2_host_key.pub")}"

}

output "host_ips" {
  value = "${module.host.ips}"
}
