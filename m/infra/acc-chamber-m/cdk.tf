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
    key            = "stacks/acc-chamber-m/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-m"
  alias   = "chamber-m"
  region  = "us-east-1"
}

module "chamber-m" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-m
  }
}
