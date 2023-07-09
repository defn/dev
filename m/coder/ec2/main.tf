data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  auth                   = "aws-instance-identity"
  arch                   = "amd64"
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e

    cd
    ssh -o StrictHostKeyChecking=no git@github.com true || true
    if ! test -d .git/.; then
      git clone http://github.com/defn/dev dev
      mv dev/.git .
      rm -rf dev
      git reset --hard
    else
      git pull
    fi

    rm -rf .cache
    sudo install -d -m 0700 -o ubuntu -g ubuntu /nix/home/cache
    ln -nfs /nix/home/cache .cache

    rm -rf work
    sudo install -d -m 0700 -o ubuntu -g ubuntu /nix/home/work
    ln -nfs /nix/home/work work

    make nix
    make symlinks
    make perms
    make home

    ~/bin/nix/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
  EOT

  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"

    LOCAL_ARCHIVE = "/usr/lib/locale/locale-archive"
    LC_ALL        = "C.UTF-8"
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  url          = "http://localhost:13337/?folder=/home/${local.username}"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

locals {
  username = "ubuntu"

  user_data = <<EOT
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
hostname: ${lower(data.coder_workspace.me.name)}
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

function setup {
  (echo "Update-Manager::Never-Include-Phased-Updates;"; echo "APT::Get::Never-Include-Phased-Updates: True;") > /etc/apt/apt.conf.d/99-Phased-Updates

  apt-get update && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends lsb-release tzdata locales ca-certificates wget curl xz-utils rsync make git direnv bash-completion less pass \
          sudo tini procps iptables net-tools iputils-ping iproute2 dnsutils gnupg \
          openssh-client fzf build-essential \
      && apt-get clean && apt purge -y nano \
      && rm -f /usr/bin/gs \
      && curl -sSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 \
      &&  sudo chmod 755 /usr/local/bin/bazel

  apt update && apt upgrade -y

  ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
      && dpkg-reconfigure -f noninteractive tzdata \
      && locale-gen en_US.UTF-8 \
      && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

  groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu \
      && echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu \
      && install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

  install -d -m 0755 -o root -g root /run/user \
      && install -d -m 0700 -o root -g root /run/sshd \
      && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg \
      && install -d -m 0700 -o ubuntu -g ubuntu /app /cache

  chown -R ubuntu:ubuntu /home/ubuntu && chmod u+s /usr/bin/sudo

  mkdir -p /nix
  chown -R ubuntu:ubuntu /nix
}

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive

setup || true

sudo -u ${local.username} sh -c '${coder_agent.main.init_script}'

--//--
EOT
}

resource "coder_metadata" "workspace" {
  count = data.coder_workspace.me.start_count

  resource_id = aws_instance.dev[count.index].id

  item {
    key   = "Region"
    value = data.coder_parameter.region.value
  }

  item {
    key   = "Instance Type"
    value = aws_instance.dev[count.index].instance_type
  }

  item {
    key   = "Volume Size (GB)"
    value = "${aws_instance.dev[count.index].root_block_device[0].volume_size} GiB"
  }
}
