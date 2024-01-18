module "s3-immanent-herbal" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["immanent-herbal"]

  providers = {
    aws = aws.immanent-herbal
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}