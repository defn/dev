module "s3-immanent-changer" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "immanent-changer" ]

  providers = {
    aws = aws.immanent-changer
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}