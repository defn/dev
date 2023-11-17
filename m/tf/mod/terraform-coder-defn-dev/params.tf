variable "tsauthkey" {}

locals {
  aws_ec2_count = data.coder_parameter.provider.value == "aws-ec2" ? 1 : 0

  username = "ubuntu"

  coder_name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"

  user_data = <<EOT
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
hostname: ${local.coder_name}
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

set -x

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf
sudo sysctl -p /etc/sysctl.d/99-dfd.conf

sudo tailscale up --accept-dns=true --accept-routes=true --operator ubuntu --ssh --authkey "${var.tsauthkey}"

sudo -H -E -u ${local.username} bash -c 'cd && (git pull || true) && cd m && bin/user-data.sh ${data.coder_workspace.me.access_url} ${local.coder_name}'
--//--
EOT
}

data "coder_parameter" "provider" {
  name         = "provider"
  display_name = "Provider"
  description  = "The service provider to deploy the workspace in"
  default      = "aws-ec2"
  icon         = "/emojis/1f30e.png"
  mutable      = true

  option {
    name  = "Amazon Web Services VM"
    value = "aws-ec2"
  }
}

data "coder_parameter" "instance_type" {
  name         = "instance_type"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace"
  type         = "string"
  default      = "m6id.large"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  option {
    name  = "2"
    value = "m6id.large"
  }
  option {
    name  = "4"
    value = "m6id.xlarge"
  }
  option {
    name  = "8"
    value = "m6id.2xlarge"
  }
  option {
    name  = "16"
    value = "m6id.4xlarge"
  }
}

data "coder_parameter" "nix_volume_size" {
  name         = "nix_volume_size"
  display_name = "nix volume size"
  description  = "The size of the nix volume to create for the workspace in GB"
  type         = "number"
  default      = "100"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  validation {
    min = 100
    max = 200
  }
}
