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
    key            = "stacks/acc-chamber-m/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "chamber-m-sso-source"
  alias   = "chamber-m"
}

module "chamber-m" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-m
  }
}
