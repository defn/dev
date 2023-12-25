module "imma-amanibhavam" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.imma-amanibhavam
  }
}