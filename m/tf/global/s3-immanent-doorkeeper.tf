module "s3-immanent-doorkeeper" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "immanent-doorkeeper" ]

  providers = {
    aws = aws.immanent-doorkeeper
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}