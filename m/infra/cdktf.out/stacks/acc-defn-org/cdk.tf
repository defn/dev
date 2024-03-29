terraform {
  required_providers {
    aws = {
      version = "5.43.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-defn-org/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "defn-org-sso"
  alias   = "defn-org"
}

module "defn-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "defn"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.defn-org
  }
}
