module "s3-whoa-prod" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["whoa-prod"]

  providers = {
    aws = aws.whoa-prod
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}