module "s3-immanent-chanter" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["immanent-chanter"]

  providers = {
    aws = aws.immanent-chanter
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}