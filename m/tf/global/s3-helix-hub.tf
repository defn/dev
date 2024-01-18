module "s3-helix-hub" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["helix-hub"]

  providers = {
    aws = aws.helix-hub
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}