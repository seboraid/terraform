output "bucket" {
  value = aws_s3_bucket.bucket
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.nginx-profile
}