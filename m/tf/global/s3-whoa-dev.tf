module "s3-whoa-dev" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["whoa-dev"]

  providers = {
    aws = aws.whoa-dev
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}