terraform {
  required_version = ">= 0.11.0"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  region = "${var.location}"
  acl = "private"
  versioning {
    enabled = false
  }
}