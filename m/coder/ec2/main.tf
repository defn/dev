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
  curl -sSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 \
      &&  sudo chmod 755 /usr/local/bin/bazel

  apt-get update && apt-get upgrade -y

  install -d -m 0755 -o root -g root /run/user \
      && install -d -m 0700 -o root -g root /run/sshd \
      && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg \
      && install -d -m 0700 -o ubuntu -g ubuntu /app /cache

  mkdir -p /nix
  chown -R ubuntu:ubuntu /nix
}

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
