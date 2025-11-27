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
    key          = "stacks/acc-whoa-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

variable "config" {}

provider "aws" {
  profile = "whoa-org"
  alias   = "whoa-org"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.whoa-org
}

locals {
  aws_config = jsonencode({
    "whoa-org" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

output "aws_config" {
  value = local.aws_config
}

output "auditor_arn" {
  value = module.whoa-org.auditor_arn
}

module "whoa-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "whoa"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.whoa-org
  }

  config = var.config
}
