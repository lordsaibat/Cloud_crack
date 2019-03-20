variable "subnet_id" {}

variable "vpc_id" {}

variable "count" {
  default = 1
}

variable "location" {
  default = ""
}

variable "instance_type" {
  default = "p2.xlarge" #change based on size t2.micro p2.xlarge p2.8xlarge p2.16xlarge
  
}

variable "amis" {
  type = "map"
  default = {
   "us-east-1" =  "ami-07360d1b1c9e13198"
  }
}

variable "hash_op" {
  type ="string"
  default ="-m 5600"
}
variable "word_lists" {
  type = "string"
  default ="/home/ec2-user/wordlists/0-9.txt /home/ec2-user/wordlists/Top207-probable-v2.txt"
}

variable "bucketname" {
 type = "string"
 default= "my-password-bucket"
}

variable "pem_file_location" {
#Windows
type = "string"
default = ""
}
variable "pub_file_location" {
#Windows
type = "string"
default = ""
}