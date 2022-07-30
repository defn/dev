locals {
  cluster = "remo"
  region  = "sfo3"

  nodes = {
    "defn" = {
      size = "s-2vcpu-4gb"
    }
  }

  envs = {
    "core" = {
      host = "remo.tiger-mamba.ts.net"
      ip   = "169.254.32.1"
    }
  }
}
