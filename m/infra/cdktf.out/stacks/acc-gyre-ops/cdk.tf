terraform {
  required_providers {
    aws = {
      version = "5.94.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-gyre-ops/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "gyre-ops-sso-source"
  alias   = "gyre-ops"
}

module "gyre-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "gyre"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.gyre-ops
  }
}
