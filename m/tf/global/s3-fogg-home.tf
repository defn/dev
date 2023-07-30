module "s3-fogg-home" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "fogg-home" ]

  providers = {
    aws = aws.fogg-home
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}