terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    fly = {
      source = "fly-apps/fly"
    }
    aws = {
      source = "hashicorp/aws"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}