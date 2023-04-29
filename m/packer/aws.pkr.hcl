variable "scripts1" {
  type = list(string)
  default = [
    "script/000-install-bare",
    "script/001-install-base"
  ]
}

variable "scripts2" {
  type = list(string)
  default = [
    "script/990-defn-dev",
    "script/999-update"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "this" {
  ami_description             = "k3d-control"
  ami_name                    = "k3d-control-${local.timestamp}"
  associate_public_ip_address = "true"
  encrypt_boot                = "true"
  instance_type               = "t3.small"
  spot_price                  = "auto"
  region                      = "us-west-1"

  ssh_interface = "public_ip"
  ssh_username  = "ubuntu"

  tags = {
    ManagedBy                = "Packer"
    "karpenter.sh/discovery" = "k3d-control"
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

  source_ami_filter {
    owners      = ["099720109477"]
    most_recent = true

    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      architecture        = "x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "file" {
    source      = "k3d/bin/k3d"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/k3d /usr/local/bin/"
    ]
  }

  provisioner "shell" {
    scripts = var.scripts1
  }

  provisioner "shell" {
    scripts = var.scripts2
  }
}
