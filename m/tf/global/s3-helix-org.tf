module "s3-helix-org" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["helix-org"]

  providers = {
    aws = aws.helix-org
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}