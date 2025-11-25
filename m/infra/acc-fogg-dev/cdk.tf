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
    key          = "stacks/acc-fogg-dev/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "fogg-dev"
  alias   = "fogg-dev"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.fogg-dev
}

locals {
  aws_config = jsonencode({
    "fogg-dev" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "fogg-dev" {
  account   = 510430971399
  name      = "terraform"
  namespace = "fogg"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.fogg-dev
  }

  config = var.config
}

output "auditor_arn" {
  value = module.fogg-dev.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
