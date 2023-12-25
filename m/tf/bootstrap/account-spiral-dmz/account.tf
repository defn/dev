module "spiral-dmz" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.spiral-dmz
  }
}