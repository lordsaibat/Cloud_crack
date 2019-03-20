output "bucket-id" {
  value = "${aws_iam_access_key.bucket_user.id}"
}
output "bucket-secret" {
  value = "${aws_iam_access_key.bucket_user.secret}"
}
