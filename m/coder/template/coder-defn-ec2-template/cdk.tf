terraform {
  required_providers {
    aws = {
      version = "5.82.2"
      source  = "aws"
    }
    coder = {
      version = "2.1.0"
      source  = "coder/coder"
    }
  }
  backend "local" {
  }
}

data "coder_parameter" "region" {
  default      = "us-west-2"
  description  = "Cloud region"
  display_name = "Cloud region"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "region"
  type         = "string"
  option {
    name  = "us-west-1"
    value = "us-west-1"
  }
  option {
    name  = "us-west-2"
    value = "us-west-2"
  }
  option {
    name  = "us-east-1"
    value = "us-east-1"
  }
  option {
    name  = "us-east-2"
    value = "us-east-2"
  }
}

data "coder_parameter" "az" {
  default      = "a"
  description  = "Cloud availability zone"
  display_name = "Cloud availability zone"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "az"
  type         = "string"
  mutable      = true
}

data "coder_parameter" "spot" {
  description  = "Spot instance"
  display_name = "Spot instance"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "spot"
  type         = "string"
  option {
    name  = "yes"
    value = "yes"
  }
  option {
    name  = "no"
    value = "no"
  }
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
    name  = "2n"
    value = "m6idn.large"
  }
  option {
    name  = "4"
    value = "m6id.xlarge"
  }
  option {
    name  = "4n"
    value = "m6idn.xlarge"
  }
  option {
    name  = "4gpu"
    value = "g4dn.xlarge"
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

data "coder_parameter" "tsauthkey" {
  description  = "Tailscale node authorization key"
  display_name = "Tailscale auth key"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "tsauthkey"
  type         = "string"
}

data "coder_parameter" "homedir" {
  default      = "/home/ubuntu/m"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "homedir"
  type         = "string"
}

data "coder_parameter" "username" {
  default      = "ubuntu"
  description  = "Linux account name"
  display_name = "Username"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "username"
  type         = "string"
}

data "coder_parameter" "nix_volume_size" {
  default      = "25"
  description  = "The size of the nix volume to create for the workspace in GB"
  display_name = "nix volume size"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  name         = "nix_volume_size"
  type         = "number"
  validation {
    max = 300
    min = 25
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

// coder
data "coder_workspace_owner" "me" {
}

data "coder_workspace" "me" {
}


resource "coder_agent" "main" {
  arch = "amd64"
  os = "linux"
  auth = "aws-instance-identity"
  startup_script = <<-EOT
    set -e
    exec >>/tmp/coder-agent.log
    exec 2>&1
    cd
    ssh -o StrictHostKeyChecking=no git@github.com true || true
    git fetch origin
    git reset --hard origin/main

    cd ~/m
    bin/startup.sh
  EOT
  env = {
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace_owner.me.email}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace_owner.me.name}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace_owner.me.email}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace_owner.me.name}"
    LC_ALL              = "C.UTF-8"
    LOCAL_ARCHIVE       = "/usr/lib/locale/locale-archive"
  }
  connection_timeout = 200
  display_apps {
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}

// apps

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "cs"
  subdomain    = true
  url          = "http://localhost:8080/?folder=${data.coder_parameter.homedir.value}"
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:8080/healthz"
  }
}

resource "coder_app" "headlamp" {
  agent_id     = coder_agent.main.id
  display_name = "headlamp"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "headlamp"
  subdomain    = true
  url          = "http://localhost:6655"
}

resource "coder_app" "argocd" {
  agent_id     = coder_agent.main.id
  display_name = "argocd"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "argocd"
  subdomain    = true
  url          = "http://localhost:6666"
}


// provider

provider "aws" {
  region = data.coder_parameter.region.value
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
  assume_role_policy = jsonencode({ "Statement" = [{ "Action" = "sts:AssumeRole", "Effect" = "Allow", "Principal" = { "Service" = "ec2.amazonaws.com" }, "Sid" = "" }], "Version" = "2012-10-17" })
  name               = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.dev.name
}

resource "aws_iam_role_policy_attachment" "secretsmanager" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.dev.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.dev.name
}

resource "aws_security_group" "dev_security_group" {
  description = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
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
      "172.31.0.0/16"
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
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  vpc_id = aws_default_vpc.default.id
}

module "dev_oidc_cdn" {
  attributes = [
    "oidc",
  ]
  deployment_principal_arns = {
    "arn:aws:iam::510430971399:role/coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}" = [
      "/openid",
    ]
  }
  name                 = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  origin_force_destroy = true
  versioning_enabled   = false
  source               = "./mod/terraform-aws-cloudfront-s3-cdn"
}

resource "aws_iam_instance_profile" "dev_instance_profile" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  role = aws_iam_role.dev.name
}

resource "aws_instance" "dev_ec2_instance" {
  ami                  = data.aws_ami.ubuntu.id
  availability_zone    = "${data.coder_parameter.region.value}${data.coder_parameter.az.value}"
  ebs_optimized        = true
  iam_instance_profile = aws_iam_instance_profile.dev_instance_profile.name
  instance_type        = data.coder_parameter.instance_type.value
  monitoring           = false

  dynamic "instance_market_options" {
    for_each = data.coder_parameter.spot.value == "yes" ? [1] : []
    content {
      market_type = "spot"

      spot_options {
        spot_instance_type           = "persistent"
        instance_interruption_behavior = "stop"
      }
    }
  }
  tags = {
    Coder_Provisioned = "true"
    Name              = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
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
hostname: coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}
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

if ! tailscale ip -4 | grep ^100; then
  sudo tailscale up --accept-dns --accept-routes --authkey="${data.coder_parameter.tsauthkey.value}" --operator=ubuntu --ssh --timeout 60s
fi

root_disk=
zfs_disk=
if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
  root_disk=nvme0n1
  zfs_disk=nvme1n1
else
  root_disk=nvme1n1
  zfs_disk=nvme0n1
fi

systemctl stop docker.socket || true
systemctl stop docker || true

zpool create defn "/dev/$zfs_disk"

for z in nix work docker; do
  zfs create defn/$z
  zfs set atime=off defn/$z
  zfs set compression=off defn/$z
  zfs set dedup=on defn/$z
done

zfs set mountpoint=/nix defn/nix
zfs set mountpoint=/home/ubuntu/work defn/work
zfs set mountpoint=/var/lib/docker defn/docker

s5cmd cat s3://dfn-defn-global-defn-org/zfs/nix.zfs | zfs receive -F defn/nix &
s5cmd cat s3://dfn-defn-global-defn-org/zfs/work.zfs | zfs receive -F defn/work &
s5cmd cat s3://dfn-defn-global-defn-org/zfs/docker.zfs | zfs receive -F defn/docker &
wait

systemctl start docker.socket || true
systemctl start docker || true

install -d -m 0755 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
install -d -m 0755 -o ubuntu -g ubuntu /nix /nix
install -d -m 1777 -o ubuntu -g ubuntu /tmp/uscreens

nohup sudo -H -u ${data.coder_parameter.username.value} env \
  CODER_INIT_SCRIPT_BASE64=${base64encode(coder_agent.main.init_script)} \
  CODER_AGENT_URL="${data.coder_workspace.me.access_url}" \
  CODER_NAME="coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}" \
    bash -c 'cd && git pull && source .bash_profile && bin/persist-cache && (s5cmd cat s3://dfn-defn-global-defn-org/zfs/nix.tar.gz | tar xfz -) && cd m && exec just coder::coder-agent' >>/tmp/user-data.log 2>&1 &
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
    volume_size           = data.coder_parameter.nix_volume_size.value
    volume_type           = "gp3"
  }
  #lifecycle {
  #  ignore_changes = [
  #    ami,
  #  ]
  #}
}

resource "coder_metadata" "dev_metadata" {
  resource_id = aws_instance.dev_ec2_instance.id
  item {
    key   = "instance type"
    value = aws_instance.dev_ec2_instance.instance_type
  }
  item {
    key   = "spot"
    value = data.coder_parameter.spot.value
  }
  item {
    key   = "disk"
    value = aws_instance.dev_ec2_instance.root_block_device[0].volume_size
  }
  item {
    key   = "region"
    value = data.coder_parameter.region.value
  }
  item {
    key   = "az"
    value = data.coder_parameter.az.value
  }
  count = (data.coder_parameter.provider.value == "aws-ec2") ? 1 : 0
}

resource "aws_ec2_instance_state" "dev_instance_state" {
  instance_id = aws_instance.dev_ec2_instance.id
  state       = (data.coder_workspace.me.transition == "start") ? "running" : "stopped"
}
