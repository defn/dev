variable "want" {
  type    = number
  default = null
}

variable "home" {
  type    = string
  default = null
}

locals {
  want = coalesce(var.want, 0)

  name    = "remo"
  region  = "sfo3"
  version = "1.23"
  size    = "s-2vcpu-4gb"

  tailscale_domain = "tiger-mamba.ts.net"

  droplet = {
    "defn" = {
      context = "k3d-remo-defn"
      host = "k3d-remo-defn.tiger-mamba.ts.net"
      ip = "100.85.87.36"
      droplet_size = "s-2vcpu-4gb"
    }
  }

  volume = {
    "defn" = {
      volume_size = "1"
    }
  }
}
