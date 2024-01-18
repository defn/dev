module "s3-chamber-7" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-7"]

  providers = {
    aws = aws.chamber-7
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}