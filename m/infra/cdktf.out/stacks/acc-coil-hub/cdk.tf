terraform {
  required_providers {
    aws = {
      version = "5.75.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-coil-hub/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "coil-hub-sso"
  alias   = "coil-hub"
}

module "coil-hub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "coil"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = "aws.coil-hub"
  }
}
