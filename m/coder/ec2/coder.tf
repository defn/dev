data "coder_workspace" "me" {}

locals {
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
hostname: coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}
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
  arch                   = "amd64"
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e

    sudo apt-get update
    sudo apt-get install -y build-essential fzf jq gettext

    sudo dd if=/dev/zero of=/root/swap bs=1M count=4096
    sudo chmod 0600 /root/swap
    sudo mkswap /root/swap
    sudo swapon /root/swap

    if [[ ! -d "/nix/home/.git/." ]]; then
      ssh -o StrictHostKeyChecking=no git@github.com true || true
      git clone http://github.com/defn/dev /nix/home
      pushd /nix/home
      git reset --hard
      popd
    else
      pushd /nix/home
      git pull
      popd
    fi

    sudo rm -rf "$HOME"
    sudo ln -nfs /nix/home "$HOME"
    ssh -o StrictHostKeyChecking=no git@github.com true || true

    sudo install -d -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg

    cd

    if [[ ! -x "bin/bazel" ]]; then
      case "$(uname -m)" in
        aarch64)
          curl -sSL -o bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-arm64
          ;;
        *)
          curl -sSL -o bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64
          ;;
      esac

      chmod 755 bin/bazelisk
      ln -nfs bazelisk bin/bazel
    fi

    make install

    source .bash_profile
     (cd m && setsid ~/bin/nix/tilt up 2>&1) &
  EOT

  env = {
    GIT_AUTHOR_NAME     = data.coder_workspace.me.owner
    GIT_COMMITTER_NAME  = data.coder_workspace.me.owner
    GIT_AUTHOR_EMAIL    = data.coder_workspace.me.owner_email
    GIT_COMMITTER_EMAIL = data.coder_workspace.me.owner_email

    LOCAL_ARCHIVE = "/usr/lib/locale/locale-archive"
    LC_ALL        = "C.UTF-8"
  }

  auth = "aws-instance-identity"
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

resource "coder_app" "temporal" {
  agent_id     = coder_agent.main.id
  slug         = "temporal"
  display_name = "temporal"
  url          = "http://localhost:8233"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:8233"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "nomad" {
  agent_id     = coder_agent.main.id
  slug         = "nomad"
  display_name = "nomad"
  url          = "http://localhost:4646"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:4646"
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
