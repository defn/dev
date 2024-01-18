module "s3-immanent-hand" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["immanent-hand"]

  providers = {
    aws = aws.immanent-hand
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}