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
    key          = "stacks/acc-imma-pub/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "imma-pub"
  alias   = "imma-pub"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.imma-pub
}

locals {
  aws_config = jsonencode({
    "imma-pub" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "imma-pub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "imma"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-pub
  }

  config = var.config
}

output "auditor_arn" {
  value = module.imma-pub.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
