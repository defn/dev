terraform {
  required_providers {
    aws = {
      version = "5.44.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-jianghu-tahoe/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "jianghu-tahoe-sso"
  alias   = "jianghu-tahoe"
}

module "jianghu-tahoe" {
  account   = 510430971399
  name      = "terraform"
  namespace = "jianghu"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.jianghu-tahoe
  }
}
