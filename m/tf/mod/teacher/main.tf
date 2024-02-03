variable "tsauthkey" {
  default = ""
}

module "workspace" {
  source = "./mod/terraform-coder-defn-ec2"

  tsauthkey = var.tsauthkey
}
