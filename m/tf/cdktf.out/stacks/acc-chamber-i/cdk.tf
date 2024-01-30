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
    key            = "stacks/acc-chamber-i/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "chamber-i-sso"
  alias   = "chamber-i"
}
module "chamber-i" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-i
  }
}