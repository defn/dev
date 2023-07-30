module "s3-chamber-w" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "chamber-w" ]

  providers = {
    aws = aws.chamber-w
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}