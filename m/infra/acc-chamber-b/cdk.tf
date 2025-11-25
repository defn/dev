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
    key          = "stacks/acc-chamber-b/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-b"
  alias   = "chamber-b"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-b
}

locals {
  aws_config = jsonencode({
    "chamber-b" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "chamber-b" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-b
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-b.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
