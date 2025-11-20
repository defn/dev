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
    key          = "stacks/acc-immanent-roke/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "immanent-roke"
  alias   = "immanent-roke"
  region  = "us-east-1"
}

module "immanent-roke" {
  account   = 510430971399
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-roke
  }
}

output "auditor_arn" {
  value = module.immanent-roke.auditor_arn
}
