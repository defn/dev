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
    key            = "stacks/acc-vault-pub/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-pub"
  alias   = "vault-pub"
  region  = "us-east-1"
}

module "vault-pub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-pub
  }
}
