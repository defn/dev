terraform {
  required_providers {
    aws = {
      version = "5.34.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-vault-dev/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "vault-dev-sso"
  alias   = "vault-dev"
}
module "vault-dev" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "./assets/__cdktf_module_asset_26CE565C/FCCCACB0261C3A645A0C39F64D95AE04/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-dev
  }
}