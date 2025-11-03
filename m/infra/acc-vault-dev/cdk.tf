# auto-generated: aws.cue infra_acc_terraform
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
    key            = "stacks/acc-vault-dev/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-dev"
  alias   = "vault-dev"
  region  = "us-east-1"
}

module "vault-dev" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-dev
  }
}
