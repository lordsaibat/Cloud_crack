terraform {
  required_version = ">= 0.11.0"
}
provider "aws" {
  region = "${var.location}"
}

data "aws_region" "current" {}

resource "aws_instance" "ec2_host" {

  tags = {
    Name = "Cloud_Crack"
  }

  ami = "${var.amis[data.aws_region.current.name]}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.ec2_host.*.key_name[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.ec2_host.id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true


  #Setup S3_bucket connection

        provisioner "remote-exec" {
	      inline = [
		    "sudo apt-get update",
        "sudo apt-get install debconf-utils -y",
        "echo 'libc6 libraries/restart-without-asking boolean true' | sudo debconf-set-selections",
        "DEBIAN_FRONTEND=noninteractive sudo apt-get install hashcat s3fs -yq --force-yes",
		    ]
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
        }
     }

     provisioner "file" {
	       source      = "./config/passwd-s3fs"
         destination = "~/passwd-s3fs"
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
          }
        }

        provisioner "remote-exec" {
	      inline = [
        "sudo cp ~/passwd-s3fs /etc/passwd-s3fs",  
		    "sudo chmod 640 /etc/passwd-s3fs",
        "mkdir ~/wordlists",
		    ]
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
        }
     }
 
        provisioner "file" {
	       source      = "./config/fuse.conf"
         destination = "/home/ec2-user/fuse.conf"
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
          }
        }
       provisioner "file" {
	       source      = "./crack/crackme.txt"
         destination = "/home/ec2-user/crackme.txt"
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
          }
        }
        provisioner "remote-exec" {
	      inline = [
		    "sudo cp /home/ec2-user/fuse.conf /etc/fuse.conf",
        "sudo s3fs -o allow_other ${var.bucketname} /home/ec2-user/wordlists",
        "ls -al /home/ec2-user/wordlists",
		    ]
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
        }
     }

        provisioner "remote-exec" {
	       inline = [
		     "sudo hashcat ${var.hash_op} crackme.txt ${var.word_lists} -o cracked.txt --status --status-time=1",
		     ]
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
        }
     }

        provisioner "remote-exec" {
	      inline = [
		    "cat cracked.txt",
		    ]
		
        connection {
          user = "ec2-user"
          host = "${aws_instance.ec2_host.public_ip}"
          agent = false
          private_key = "${var.pem_file_location}"
        }
     }

/*
        provisioner "local-exec" {
	      command = [
		    "scp -i ${var.pem_file_location} ${aws_instance.ec2_host.public_ip}:/cracked.txt ./results/"
		    ]
		
         }
*/
        
	tags {
	  Name = "Cloud Crack"
	}


  provisioner "local-exec" {
    when = "destroy"
    command = "rm .\\ssh_keys\\ec2_host_key*"
  }

}

resource "aws_key_pair" "ec2_host" {
  count = "${var.count}"
  key_name = "Cloudcrack-key"
  public_key = "${var.pub_file_location}"
}
