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
    key            = "stacks/acc-chamber-l/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-l"
  alias   = "chamber-l"
  region  = "us-east-1"
}

module "chamber-l" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-l
  }
}
