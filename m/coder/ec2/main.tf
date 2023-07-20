terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.11.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }
}
