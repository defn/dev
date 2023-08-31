terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}