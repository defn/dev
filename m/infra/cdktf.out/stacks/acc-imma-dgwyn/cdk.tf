terraform {
  required_providers {
    aws = {
      version = "5.44.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-imma-dgwyn/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "imma-dgwyn-sso"
  alias   = "imma-dgwyn"
}

module "imma-dgwyn" {
  account   = 510430971399
  name      = "terraform"
  namespace = "imma"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-dgwyn
  }
}
