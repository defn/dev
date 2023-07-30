module "terraform_state_backend" {
  source     = "../../terraform-aws-tfstate-backend"
  context    = module.this.context
  attributes = ["state"]

  providers = {
    aws = aws.defn-org
  }

  profile              = "defn-org-sso"
  terraform_state_file = "defn-org/bootstrap/remote-state/terraform.tfstate"

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}