terraform {
  required_providers {
    aws = {
      version = "5.94.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-immanent-hand/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "immanent-hand-sso-source"
  alias   = "immanent-hand"
}

module "immanent-hand" {
  account   = 510430971399
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-hand
  }
}
