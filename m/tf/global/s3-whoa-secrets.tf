module "s3-whoa-secrets" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["whoa-secrets"]

  providers = {
    aws = aws.whoa-secrets
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}