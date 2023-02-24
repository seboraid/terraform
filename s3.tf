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
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-bucket"
  })
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
resource "aws_s3_object" "website_resources" {

  for_each = {
    index = "website/index.html"
    logo  = "website/Globo_logo_Vert.png"
  }

  bucket        = aws_s3_bucket.bucket.id
  key           = each.value
  source        = each.value
  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-object-website"
  })
}

## aws_iam_role

resource "aws_iam_role" "allow_nginx_s3" {
  name               = "${local.name_prefix}-s3-access-role"
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
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-access-role"
  })
}

## aws_iam_role_policy

resource "aws_iam_role_policy" "allow_s3_all" {
  name   = "${local.name_prefix}-iam-role-policy-allow_s3_all"
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
  name = "${local.name_prefix}-iam-instance-profile-nginx-profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-instance-profile-nginx-profile"
  })
}