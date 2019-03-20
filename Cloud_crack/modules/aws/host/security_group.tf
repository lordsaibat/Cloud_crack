terraform {
  required_version = ">= 0.11.0"
}

data "external" "get_public_ip" {
  program = ["bash", "./scripts/get_public_ip.sh" ]
}

resource "aws_security_group" "ec2_host" {
  name = "ec2-host"
  description = "Labs setup by Terraform"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${data.external.get_public_ip.result["ip"]}/32"]
  }
  egress {
       from_port       = 0
    	 to_port         = 0
    	 protocol        = "-1"
    	 cidr_blocks     = ["0.0.0.0/0"]
    }
}
