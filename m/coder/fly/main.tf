terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.11.0"
    }
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}