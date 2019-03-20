terraform {
  required_version = ">= 0.11.0"
}

resource "aws_iam_user" "bucket_user" {
  name ="password_bucket_user"
}

resource "aws_iam_group" "bucket_group" {
  name = "password_bucket_group"
}

resource "aws_iam_group_membership" "bucket_team" {
  name = "tf-bucket-group-membership"

  users = [
    "${aws_iam_user.bucket_user.name}",
  ]

  group = "${aws_iam_group.bucket_group.name}"
}

data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.directory_name}",
      "arn:aws:s3:::${var.directory_name}/*",
    ]

  }
}

resource "aws_iam_policy" "bucket" {
  name   = "bucket_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.example.json}"
}

resource "aws_iam_policy_attachment" "bucket-attach" {
  name       = "bucket-attachment"
  users      = ["${aws_iam_user.bucket_user.name}"]
  groups     = ["${aws_iam_group.bucket_group.name}"]
  policy_arn = "${aws_iam_policy.bucket.arn}"
}

resource "aws_iam_access_key" "bucket_user" {
  user    = "${aws_iam_user.bucket_user.name}"
}