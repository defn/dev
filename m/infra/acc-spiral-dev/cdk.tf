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
    key          = "stacks/acc-spiral-dev/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "spiral-dev"
  alias   = "spiral-dev"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.spiral-dev
}

locals {
  aws_config = jsonencode({
    "spiral-dev" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "spiral-dev" {
  account   = 510430971399
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-dev
  }

  config = var.config
}

output "auditor_arn" {
  value = module.spiral-dev.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
