
resource "aws_s3_bucket_object" "file_0" {
  bucket = "${var.bucket_name}"
  key = "0-9.txt"
  //source = "./files/0-9.txt"
  //Windows Path
  source = ".\\files\\0-9.txt"
}

resource "aws_s3_bucket_object" "file_1" {
  bucket = "${var.bucket_name}"
  key = "Top207-probable-v2.txt"
  //source = "./files/Top207-probable-v2.txt"
  //Windows Path
  source = ".\\files\\Top207-probable-v2.txt"
}
