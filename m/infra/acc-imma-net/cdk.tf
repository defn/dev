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
    key          = "stacks/acc-imma-net/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

variable "config" {}

provider "aws" {
  profile = "imma-net"
  alias   = "imma-net"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.imma-net
}

locals {
  aws_config = jsonencode({
    "imma-net" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

output "aws_config" {
  value = local.aws_config
}

output "auditor_arn" {
  value = module.imma-net.auditor_arn
}

module "imma-net" {
  account   = 510430971399
  name      = "terraform"
  namespace = "imma"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-net
  }

  config = var.config
}
