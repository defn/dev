data "coder_workspace" "me" {}

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
hostname: ${lower(data.coder_workspace.me.name)}
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
exec sudo -u ${local.username} sh -c '${coder_agent.main.init_script}' &

--//--
EOT
}

resource "coder_agent" "main" {
  auth                   = "aws-instance-identity"
  arch                   = "amd64"
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e

    sudo install -d -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg

    sudo apt-get update
    sudo apt-get install -y build-essential fzf jq

    sudo curl -sSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64
    sudo chmod 755 /usr/local/bin/bazel

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
    
    make nix
    make symlinks
    make perms
    make home

    source .bash_profile

    ~/bin/nix/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &

    (cd m && ~/bin/nix/tilt up) &
  EOT

  env = {
    GIT_AUTHOR_NAME     = data.coder_workspace.me.owner
    GIT_COMMITTER_NAME  = data.coder_workspace.me.owner
    GIT_AUTHOR_EMAIL    = data.coder_workspace.me.owner_email
    GIT_COMMITTER_EMAIL = data.coder_workspace.me.owner_email

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
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "tilt" {
  agent_id     = coder_agent.main.id
  slug         = "tilt"
  display_name = "tilt"
  url          = "http://localhost:10350"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:10350"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "hugo" {
  agent_id     = coder_agent.main.id
  slug         = "hugo"
  display_name = "hugo"
  url          = "http://localhost:1313"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:1313"
    interval  = 5
    threshold = 6
  }
}

resource "coder_metadata" "workspace" {
  resource_id = aws_instance.dev.id

  item {
    key   = "Region"
    value = data.coder_parameter.region.value
  }

  item {
    key   = "Instance Type"
    value = aws_instance.dev.instance_type
  }

  item {
    key   = "Volume Size (GB)"
    value = "${aws_instance.dev.root_block_device[0].volume_size} GiB"
  }
}
