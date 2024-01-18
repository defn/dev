module "s3-imma-amanibhavam" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-amanibhavam"]

  providers = {
    aws = aws.imma-amanibhavam
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}