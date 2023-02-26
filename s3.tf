
module "s3mio" {
  source = "./modules/globo-website-s3"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  bucket_name = local.s3_bucket_name

  elb_service_account_arn = data.aws_elb_service_account.root.arn
}

## aws_s3_object
resource "aws_s3_object" "website_resources" {

  for_each = {
    index = "website/index.html"
    logo  = "website/Globo_logo_Vert.png"
  }

  bucket        = module.s3mio.bucket.id
  key           = each.value
  source        = each.value
  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}s3-object-website"
  })
}
