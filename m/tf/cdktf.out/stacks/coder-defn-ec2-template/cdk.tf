terraform {
  required_providers {
    aws = {
      version = "5.35.0"
      source  = "aws"
    }
    coder = {
      version = "0.13.0"
      source  = "coder/coder"
    }
  }
  backend "local" {

  }


}
data "coder_parameter" "username" {
  default      = "ubuntu"
  description  = "Linux accoount name"
  display_name = "Username"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "username"
  type         = "string"
}
data "coder_parameter" "region" {
  default      = "us-west-2"
  description  = "Cloud region"
  display_name = "Cloud region"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "region"
  type         = "string"
}
data "coder_parameter" "az" {
  default      = "a"
  description  = "Cloud availability zone"
  display_name = "Cloud availability zone"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "az"
  type         = "string"
}
data "coder_parameter" "instance_type" {
  default      = "m6id.large"
  description  = "The number of CPUs to allocate to the workspace"
  display_name = "CPU"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "instance_type"
  type         = "string"
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
  default      = "100"
  description  = "The size of the nix volume to create for the workspace in GB"
  display_name = "nix volume size"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  name         = "nix_volume_size"
  type         = "number"
  validation {
    max = 300
    min = 100
  }
}
data "coder_parameter" "provider" {
  default      = "aws-ec2"
  description  = "The service provider to deploy the workspace in"
  display_name = "Provider"
  icon         = "/emojis/1f30e.png"
  name         = "provider"
  option {
    name  = "Amazon Web Services VM"
    value = "aws-ec2"
  }
}
data "coder_parameter" "tsauthkey" {
  default      = "TODO"
  description  = "Tailscale node authorization key"
  display_name = "Tailscale auth key"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "tsauthkey"
  type         = "string"
}
data "coder_workspace" "me" {
}
resource "coder_agent" "main" {
  arch = "amd64"
  auth = "token"
  env = {
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
    LC_ALL              = "C.UTF-8"
    LOCAL_ARCHIVE       = "/usr/lib/locale/locale-archive"
  }
  os                     = "linux"
  startup_script         = "cd ~/m && bin/startup.sh"
  startup_script_timeout = 180
  display_apps {
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}
resource "aws_default_vpc" "default" {
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [
    "self"
  ]
  filter {
    name = "name"
    values = [
      "coder-*"
    ]
  }
  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }
}
resource "aws_iam_role" "dev" {
  assume_role_policy = "${jsonencode({ "Statement" = [{ "Action" = "sts:AssumeRole", "Effect" = "Allow", "Principal" = { "Service" = "ec2.amazonaws.com" }, "Sid" = "" }], "Version" = "2012-10-17" })}"
  name               = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
}
resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${aws_iam_role.dev.name}"
}
resource "aws_iam_role_policy_attachment" "secretsmanager" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = "${aws_iam_role.dev.name}"
}
resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${aws_iam_role.dev.name}"
}
resource "aws_security_group" "dev_security_group" {
  description = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "allow all egress"
    from_port   = 0
    ipv6_cidr_blocks = [
      "::/0"
    ]
    prefix_list_ids = null
    protocol        = "-1"
    security_groups = null
    self            = null
    to_port         = 0
  }
  ingress {
    cidr_blocks = [
      "172.31.32.0/20"
    ]
    description      = "allow vpc ingress"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = null
    self             = null
    to_port          = 0
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "allow wireguard udp"
    from_port   = 41641
    ipv6_cidr_blocks = [
      "::/0"
    ]
    prefix_list_ids = null
    protocol        = "udp"
    security_groups = null
    self            = null
    to_port         = 41641
  }
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  tags = {
    "karpenter.sh/discovery" = "k3d-dfd"
  }
  vpc_id = "${aws_default_vpc.default.id}"
}
resource "coder_app" "code-server" {
  agent_id     = "${coder_agent.main.id}"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "code-server"
  subdomain    = false
  url          = "http://localhost:13337/?folder=/home/${data.coder_parameter.username.value}/m"
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:13337/healthz"
  }
}

provider "aws" {
  region = "${data.coder_parameter.region.value}"
}

provider "coder" {
}
module "coder-login" {
  agent_id = "${coder_agent.main.id}"
  source   = "https://registry.coder.com/modules/coder-login"
}
resource "aws_iam_instance_profile" "dev_instance_profile" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  role = "${aws_iam_role.dev.name}"
}
resource "aws_instance" "dev_ec2_instance" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.coder_parameter.region.value}${data.coder_parameter.az.value}"
  ebs_optimized        = true
  iam_instance_profile = "${aws_iam_instance_profile.dev_instance_profile.name}"
  instance_type        = "${data.coder_parameter.instance_type.value}"
  monitoring           = false
  tags = {
    Coder_Provisioned = "true"
    Name              = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  }
  user_data = <<EOF
Content-type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
hostname: coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}
cloud_final_modules:
- [scripts-user, always]

--//
Content-type: text/x-shellscript; charset="us-ascii"
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

while true; do
  if test -n "$(dig +short "cache.nixos.org" || true)"; then
    break
  fi
  sleep 5
done

if ! tailscale ip -4 | grep ^100; then
  sudo tailscale up --accept-dns --accept-routes --authkey="${data.coder_parameter.tsauthkey.value}" --operator=ubuntu --ssh --timeout 60s # missing --advertise-routes= on reboot
fi

nohup sudo -H -E -u ${data.coder_parameter.username.value} bash -c 'cd && (git pull || true) && cd m && exec bin/user-data.sh ${data.coder_workspace.me.access_url} coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name} ${coder_agent.main.token}' >>/tmp/user-data.log 2>&1 &
disown
--//--
EOF
  vpc_security_group_ids = [
    "${aws_security_group.dev_security_group.id}"
  ]
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
    instance_metadata_tags      = "enabled"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "${data.coder_parameter.nix_volume_size.value}"
    volume_type           = "gp3"
  }
}
resource "coder_metadata" "main_20" {
  resource_id = "${aws_instance.dev_ec2_instance.id}"
  item {
    key   = "instance type"
    value = "${aws_instance.dev_ec2_instance.instance_type}"
  }
  item {
    key   = "disk"
    value = "${aws_instance.dev_ec2_instance.root_block_device[0].volume_size} GiB"
  }
  count = "${(data.coder_parameter.provider.value == "aws-ec2") ? 1 : 0}"
}
resource "aws_ec2_instance_state" "dev_instance_state" {
  instance_id = "${aws_instance.dev_ec2_instance.id}"
  state       = "${(data.coder_workspace.me.transition == "start") ? "running" : "stopped"}"
}