provider "aws" {
  profile = "demo-ops-sso"
  region  = "us-west-2"
}

module "terraform_state_backend" {
  source    = "cloudposse/tfstate-backend/aws"
  version   = "1.4.1"
  namespace = "demonstrate"
  stage     = "terraform"
  name      = "remote-state"

  profile = "demo-ops-sso"

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}
