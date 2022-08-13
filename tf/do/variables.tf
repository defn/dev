variable "want" {
  type    = number
  default = null
}

variable "home" {
  type    = string
  default = null
}

variable "archive_global" {
  type    = string
  default = null
}

variable "archive_defn" {
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

  archives = {
    global = var.archive_global
    defn   = var.archive_defn
  }


  droplet = {
    defn = {
      context      = "k3d-defn"
      host         = "k3d-defn.tiger-mamba.ts.net"
      ip           = "100.101.82.85"
      droplet_size = "s-2vcpu-4gb"
    }

    global = {
      context      = "k3d-global"
      host         = "k3d-global.tiger-mamba.ts.net"
      ip           = "100.112.92.65"
      droplet_size = "s-1vcpu-2gb"
    }
  }

  volume = {
    global = {
      volume_size = "1"
    }

    defn = {
      volume_size = "1"
    }
  }
}
