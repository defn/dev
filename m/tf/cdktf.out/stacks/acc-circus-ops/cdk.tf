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
    key            = "stacks/acc-circus-ops/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "circus-ops-sso"
  alias   = "circus-ops"
}
module "circus-ops" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.circus-ops
  }
}