locals {
  cluster = "remo"
  region  = "sfo3"

  envs = {
    "defn" = {
      size = "s-2vcpu-4gb"
    }
  }
}
