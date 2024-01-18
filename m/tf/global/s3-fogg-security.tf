module "s3-fogg-security" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["fogg-security"]

  providers = {
    aws = aws.fogg-security
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}