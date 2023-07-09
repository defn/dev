variable "scripts" {
  type = list(string)
  default = [
    "script/000-install-bare",
    "script/001-install-base",
    "script/999-update"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "this" {
  ami_description             = "base"
  ami_name                    = "base-amd64-${local.timestamp}"
  associate_public_ip_address = "true"
  encrypt_boot                = "true"
  instance_type               = "t3.small"
  spot_price                  = "auto"
  region                      = "us-west-2"

  ssh_interface = "public_ip"
  ssh_username  = "ubuntu"

  run_tags = {
    ManagedBy = "Packer"
  }
  run_volume_tags = {
    ManagedBy = "Packer"
  }
  snapshot_tags = {
    ManagedBy = "Packer"
  }

  source_ami_filter {
    owners      = ["099720109477"]
    most_recent = true

    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      architecture        = "x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    scripts = var.scripts
  }
}
