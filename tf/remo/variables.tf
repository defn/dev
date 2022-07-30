variable "want" {
  type    = number
  default = null
}

locals {
  want = coalesce(var.want, 0)

  cluster = "remo"
  region  = "sfo3"

  droplets = {
    "defn" = {
      size = "s-2vcpu-4gb"
    }
  }

  envs = {
    "remo" = {
      host = "remo.tiger-mamba.ts.net"
      ip   = "169.254.32.1"
    }
  }
}
