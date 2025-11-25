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
    key          = "stacks/acc-immanent-ged/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "immanent-ged"
  alias   = "immanent-ged"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.immanent-ged
}

locals {
  aws_config = jsonencode({
    "immanent-ged" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

variable "config" {}

module "immanent-ged" {
  account   = 510430971399
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-ged
  }

  config = var.config
}

output "auditor_arn" {
  value = module.immanent-ged.auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
