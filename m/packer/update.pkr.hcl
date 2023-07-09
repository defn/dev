variable "scripts" {
  type = list(string)
  default = [
    "script/998-defn-dev-update",
    "script/999-update"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "this" {
  ami_description = "update"
  ami_name        = "update-amd64-${local.timestamp}"

  associate_public_ip_address = "true"
  ssh_interface               = "public_ip"
  ssh_username                = "ubuntu"

  spot_price    = "auto"
  instance_type = "t3.small"
  region        = "us-west-2"

  source_ami_filter {
    owners      = ["self"]
    most_recent = true

    filters = {
      name         = "base-*"
      architecture = "x86_64"
    }
  }

  run_tags = {
    ManagedBy = "Packer"
  }

  run_volume_tags = {
    ManagedBy = "Packer"
  }

  snapshot_tags = {
    ManagedBy = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    scripts = var.scripts
  }
}
