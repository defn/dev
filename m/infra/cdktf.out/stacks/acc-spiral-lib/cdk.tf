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
    key            = "stacks/acc-spiral-lib/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "spiral-lib-sso"
  alias   = "spiral-lib"
}
module "spiral-lib" {
  account   = 767397818037
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-lib
  }
}