module "s3-helix-sec" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["helix-sec"]

  providers = {
    aws = aws.helix-sec
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}