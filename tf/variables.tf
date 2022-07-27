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
  size    = "s-1vcpu-2gb"

  tailscale_domain = "tiger-mamba.ts.net"

  droplet = {
    "defn" = {
      droplet_size = "s-4vcpu-8gb-amd"
    }
  }

  volume = {
    "defn" = {
      volume_size = "10"
    }
  }
}
