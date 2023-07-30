module "s3-chamber-f" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "chamber-f" ]

  providers = {
    aws = aws.chamber-f
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}