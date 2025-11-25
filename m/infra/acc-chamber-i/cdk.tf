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
    key          = "stacks/acc-chamber-i/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-i"
  alias   = "chamber-i"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-i
}

variable "config" {}

module "chamber-i" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-i
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-i.auditor_arn
}
