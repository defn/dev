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
    key          = "stacks/acc-circus-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

variable "config" {}

provider "aws" {
  profile = "circus-ops"
  alias   = "circus-ops"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.circus-ops
}

locals {
  aws_config = jsonencode({
    "circus-ops" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

output "aws_config" {
  value = local.aws_config
}

output "auditor_arn" {
  value = module.circus-ops.auditor_arn
}

module "circus-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "circus"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.circus-ops
  }

  config = var.config
}
