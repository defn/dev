module "whoa-secrets" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.whoa-secrets
  }
}