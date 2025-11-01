terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-whoa-dev/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "whoa-dev"
  region  = "us-east-1"
  alias   = "whoa-dev"
}

module "whoa-dev" {
  account   = 510430971399
  name      = "terraform"
  namespace = "whoa"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.whoa-dev
  }
}
