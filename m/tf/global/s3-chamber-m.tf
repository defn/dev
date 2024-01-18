module "s3-chamber-m" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-m"]

  providers = {
    aws = aws.chamber-m
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}