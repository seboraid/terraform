# Bucket Name
variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

# ELB service account
variable "elb_service_account_arn" {
  type        = string
  description = "ELB Service account ARN"
}

# Common Tags
variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {}
}

variable "name_prefix" {
  type        = string
  description = "Name prefix"
  default = ""
}