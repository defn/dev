variable "scripts" {
  type = list(string)
  default = [
    "script/998-defn-dev-update",
    "script/999-update"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "update"
  owner     = "self"
  ami       = "base-*"
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

  source_ami_filter {
    owners      = [local.owner]
    most_recent = true

    filters = {
      name         = local.ami
      architecture = "x86_64"
    }
  }

  run_tags = {
    Name      = "Packer"
    ManagedBy = "Packer"
  }

  run_volume_tags = {
    Name      = "Packer"
    ManagedBy = "Packer"
  }

  snapshot_tags = {
    Name      = "Packer"
    ManagedBy = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    scripts = var.scripts
  }
}
