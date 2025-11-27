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
    key          = "stacks/acc-gyre-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

variable "config" {}

provider "aws" {
  profile = "gyre-ops"
  alias   = "gyre-ops"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.gyre-ops
}

locals {
  aws_config = jsonencode({
    "gyre-ops" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

output "aws_config" {
  value = local.aws_config
}

output "auditor_arn" {
  value = module.gyre-ops.auditor_arn
}

module "gyre-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "gyre"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.gyre-ops
  }

  config = var.config
}
