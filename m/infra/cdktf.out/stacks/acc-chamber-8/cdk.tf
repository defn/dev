terraform {
  required_providers {
    aws = {
      version = "5.96.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-chamber-8/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "chamber-8-sso-source"
  alias   = "chamber-8"
}

module "chamber-8" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-8
  }
}
