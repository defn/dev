terraform {
  required_providers {
    aws = {
      version = "5.38.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-vault-pub/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "vault-pub-sso"
  alias   = "vault-pub"
}
module "vault-pub" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-pub
  }
}