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
    key          = "stacks/acc-chamber-7/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-7"
  alias   = "chamber-7"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-7
}

locals {
  aws_config = jsonencode({
    "chamber-7" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "chamber-7" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-7
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-7.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
