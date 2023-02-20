##################################################################################
# DATA
##################################################################################

data "aws_iam_policy_document" "allow_access_to_s3_from_elb" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.root.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/alb-logs/*",
    ]
  }
}

##################################################################################
# RESOURCES
##################################################################################

## aws_s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket = local.s3_bucket_name
  tags   = local.common_tags
}

## aws_s3_bucket_acl

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

## aws_s3_bucket_policy

resource "aws_s3_bucket_policy" "allow_access_to_s3_from_elb" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_to_s3_from_elb.json
}

## aws_s3_object
resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.bucket.id
  key    = "website/index.html"
  source = "website/index.html"

  tags = local.common_tags
}

resource "aws_s3_object" "website_logo" {
  bucket = aws_s3_bucket.bucket.id
  key    = "website/Globo_logo_Vert.png"
  source = "website/Globo_logo_Vert.png"

  tags = local.common_tags
}

## aws_iam_role

resource "aws_iam_role" "allow_nginx_s3" {
  name               = "s3-access-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  
}
EOF
  tags               = local.common_tags
}

## aws_iam_role_policy

resource "aws_iam_role_policy" "allow_s3_all" {
  name   = "allow_s3_all"
  role   = aws_iam_role.allow_nginx_s3.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.bucket.id}",
                "arn:aws:s3:::${aws_s3_bucket.bucket.id}/website/*"
            ]
        }
    ]
  
}
EOF
}

## aws_iam_instance_profile

resource "aws_iam_instance_profile" "nginx-profile" {
  name = "nginx-profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}