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
    key          = "stacks/acc-chamber-n/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-n"
  alias   = "chamber-n"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-n
}

variable "config" {}

module "chamber-n" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-n
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-n.auditor_arn
}
