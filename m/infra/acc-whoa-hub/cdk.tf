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
    key          = "stacks/acc-whoa-hub/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "whoa-hub"
  alias   = "whoa-hub"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.whoa-hub
}

locals {
  aws_config = jsonencode({
    "whoa-hub" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "whoa-hub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "whoa"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.whoa-hub
  }

  config = var.config
}

output "auditor_arn" {
  value = module.whoa-hub.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
