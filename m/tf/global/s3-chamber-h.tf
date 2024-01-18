module "s3-chamber-h" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-h"]

  providers = {
    aws = aws.chamber-h
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}