terraform {
  required_providers {
    aws = {
      version = "5.41.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-fogg-postx/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "fogg-postx-sso"
  alias   = "fogg-postx"
}

module "fogg-postx" {
  account   = 510430971399
  name      = "terraform"
  namespace = "fogg"
  stage     = "ops"
  source    = "../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.fogg-postx
  }
}
