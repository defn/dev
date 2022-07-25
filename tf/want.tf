variable "want" {
  type    = number
  default = null
}

locals {
  want = coalesce(var.want, 1)

  name   = "remo"
  region = "sfo3"

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
