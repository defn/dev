terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    fly = {
      source = "fly-apps/fly"
    }
  }
}

provider "coder" {
  feature_use_managed_variables = true
}