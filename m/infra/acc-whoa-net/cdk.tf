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
    key          = "stacks/acc-whoa-net/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "whoa-net"
  alias   = "whoa-net"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.whoa-net
}

locals {
  aws_config = jsonencode({
    "whoa-net" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "whoa-net" {
  account   = 510430971399
  name      = "terraform"
  namespace = "whoa"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.whoa-net
  }

  config = var.config
}

output "auditor_arn" {
  value = module.whoa-net.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
