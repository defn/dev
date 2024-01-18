module "s3-immanent-namer" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["immanent-namer"]

  providers = {
    aws = aws.immanent-namer
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}