module "s3-gyre-ops" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["gyre-ops"]

  providers = {
    aws = aws.gyre-ops
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}