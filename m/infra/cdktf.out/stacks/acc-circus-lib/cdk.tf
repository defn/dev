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
    key            = "stacks/acc-circus-lib/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "circus-lib-sso-source"
  alias   = "circus-lib"
}

module "circus-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "circus"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.circus-lib
  }
}
