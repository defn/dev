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
    key          = "stacks/output/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "defn-org"
  alias   = "defn-org"
  region  = "us-east-1"
}

data "terraform_remote_state" "chamber-1" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-1/terraform.tfstate"
    region = "us-east-1"
  }
}

output "all" {
  value = {
    "chamber-1" : data.terraform_remote_state.chamber-1.outputs
  }
}
