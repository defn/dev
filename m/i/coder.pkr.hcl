packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "scripts" {
  type = list(string)
  default = [
    "script/999-defn-dev"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "coder"
  owner     = "self"
  ami       = "coder-*"
}

source "amazon-ebs" "this" {
  ami_description = local.name
  ami_name        = "${local.name}-amd64-${local.timestamp}"

  associate_public_ip_address = "true"
  ssh_interface               = "public_ip"
  ssh_username                = "ubuntu"

  spot_price    = "auto"
  instance_type = "m5d.large"
  region        = "us-west-2"

  source_ami_filter {
    owners      = [local.owner]
    most_recent = true

    filters = {
      name         = local.ami
      architecture = "x86_64"
    }
  }

  run_tags = {
    Name                     = "Packer"
    ManagedBy                = "Packer"
    "karpenter.sh/discovery" = "k3d-dfd"
  }

  run_volume_tags = {
    Name                     = "Packer"
    ManagedBy                = "Packer"
    "karpenter.sh/discovery" = "k3d-dfd"
  }

  snapshot_tags = {
    Name      = "Packer coder latest ${local.timestamp}"
    ManagedBy = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    scripts = var.scripts
  }
}