module "s3-fogg-hub" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "fogg-hub" ]

  providers = {
    aws = aws.fogg-hub
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}