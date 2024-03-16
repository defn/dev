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
    key            = "stacks/acc-coil-lib/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "coil-lib-sso"
  alias   = "coil-lib"
}

module "coil-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "coil"
  stage     = "ops"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.coil-lib
  }
}
