module "s3-curl-org" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "curl-org" ]

  providers = {
    aws = aws.curl-org
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}