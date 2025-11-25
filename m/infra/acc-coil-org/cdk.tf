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
    key          = "stacks/acc-coil-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "coil-org"
  alias   = "coil-org"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.coil-org
}

locals {
  aws_config = jsonencode({
    "coil-org" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "coil-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "coil"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.coil-org
  }

  config = var.config
}

output "auditor_arn" {
  value = module.coil-org.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
