locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }

  s3_bucket_name = lower("${var.company}-${var.project}-bucket-${random_integer.rand.result}")
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}