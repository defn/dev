module "s3-chamber-d" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-d"]

  providers = {
    aws = aws.chamber-d
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}