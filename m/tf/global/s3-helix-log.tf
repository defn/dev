module "s3-helix-log" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["helix-log"]

  providers = {
    aws = aws.helix-log
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}