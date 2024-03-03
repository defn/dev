module "s3-fogg-asset" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "fogg-asset" ]

  providers = {
    aws = aws.fogg-asset
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}