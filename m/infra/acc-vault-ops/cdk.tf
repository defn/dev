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
    key          = "stacks/acc-vault-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-ops"
  alias   = "vault-ops"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.vault-ops
}

locals {
  aws_config = jsonencode({
    "vault-ops" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "vault-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-ops
  }

  config = var.config
}

output "auditor_arn" {
  value = module.vault-ops.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
