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
    key            = "stacks/acc-chamber-8/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-8"
  alias   = "chamber-8"
  region  = "us-east-1"
}

module "chamber-8" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-8
  }
}
