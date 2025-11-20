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
    key          = "stacks/acc-helix-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "helix-ops"
  alias   = "helix-ops"
  region  = "us-east-1"
}

module "helix-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "helix"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.helix-ops
  }
}

output "auditor_arn" {
  value = module.helix-ops.auditor_arn
}
