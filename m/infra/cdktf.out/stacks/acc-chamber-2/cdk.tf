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
    key            = "stacks/acc-chamber-2/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "chamber-2-sso"
  alias   = "chamber-2"
}
module "chamber-2" {
  account   = 767397818037
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-2
  }
}