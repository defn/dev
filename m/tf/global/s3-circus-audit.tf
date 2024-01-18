module "s3-circus-audit" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["circus-audit"]

  providers = {
    aws = aws.circus-audit
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}