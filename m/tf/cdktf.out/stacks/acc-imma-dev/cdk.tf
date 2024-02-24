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
    key            = "stacks/acc-imma-dev/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "imma-dev-sso"
  alias   = "imma-dev"
}
module "imma-dev" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-dev
  }
}