# auto-generated: aws.cue infra_acc_terraform
terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket       = "dfn-defn-terraform-state"
    use_lockfile = true
    encrypt      = true
    key          = "stacks/acc-chamber-x/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-x"
  alias   = "chamber-x"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-x
}

variable "config" {}

module "chamber-x" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-x
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-x.auditor_arn
}
