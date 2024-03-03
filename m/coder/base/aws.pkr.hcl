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
    "script/000-install-bare",
    "script/001-install-base",
    "script/800-defn-dev",
    "script/999-update"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "coder"
  owner     = "099720109477"
  ami       = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

source "amazon-ebs" "this" {
  ami_description = local.name
  ami_name        = "${local.name}-amd64-${local.timestamp}"

  associate_public_ip_address = "true"
  ssh_interface               = "public_ip"
  ssh_username                = "ubuntu"

  spot_price    = "auto"
  instance_type = "t3.xlarge"
  region        = "us-west-2"

  launch_block_device_mappings {
    encrypted             = true
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  source_ami_filter {
    owners      = [local.owner]
    most_recent = true

    filters = {
      name         = local.ami
      architecture = "x86_64"

      root-device-type    = "ebs"
      virtualization-type = "hvm"
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
    Name      = "Packer base ${local.timestamp}"
    ManagedBy = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    scripts = var.scripts
  }
}