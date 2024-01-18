module "s3-circus-ops" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["circus-ops"]

  providers = {
    aws = aws.circus-ops
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}