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
    key          = "stacks/acc-chamber-j/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "chamber-j"
  alias   = "chamber-j"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.chamber-j
}

locals {
  aws_config = jsonencode({
    "chamber-j" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "chamber-j" {
  account   = 510430971399
  name      = "terraform"
  namespace = "chamber"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.chamber-j
  }

  config = var.config
}

output "auditor_arn" {
  value = module.chamber-j.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
