module "s3-chamber-j" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-j"]

  providers = {
    aws = aws.chamber-j
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}