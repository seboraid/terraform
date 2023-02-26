locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }

  s3_bucket_name = lower("${local.name_prefix}bucket-${random_integer.rand.result}")
  name_prefix    = lower("${var.naming_prefix}-dev-")
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
