module "s3-spiral-org" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "spiral-org" ]

  providers = {
    aws = aws.spiral-org
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}