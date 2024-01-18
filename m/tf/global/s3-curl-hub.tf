module "s3-curl-hub" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["curl-hub"]

  providers = {
    aws = aws.curl-hub
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}