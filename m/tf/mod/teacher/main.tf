variable "tsauthkey" {
  default = ""
}

module "workspace" {
  source = "./mod/terraform-coder-defn-dev"

  tsauthkey = var.tsauthkey
}
