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
    key            = "stacks/acc-spiral-ops/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "spiral-ops"
  region  = "us-east-1"
  alias   = "spiral-ops"
}

module "spiral-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-ops
  }
}
