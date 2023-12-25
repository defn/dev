module "imma-dgwyn" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.imma-dgwyn
  }
}