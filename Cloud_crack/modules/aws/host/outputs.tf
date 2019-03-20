output "ips" {
  value = ["${aws_instance.ec2_host.*.public_ip}"]
}