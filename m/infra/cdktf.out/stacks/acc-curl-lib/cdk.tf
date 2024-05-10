terraform {
  required_providers {
    aws = {
      version = "5.49.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-curl-lib/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "curl-lib-sso"
  alias   = "curl-lib"
}

module "curl-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "curl"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.curl-lib
  }
}
