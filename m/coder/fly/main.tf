data "coder_workspace" "me" {}

resource "coder_agent" "main" {
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

    uptime
  EOT

  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
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
}

resource "coder_metadata" "workspace" {
  resource_id = fly_app.workspace.id

  item {
    key   = "Region"
    value = data.coder_parameter.region.value
  }

  item {
    key   = "CPU Type"
    value = data.coder_parameter.cputype.value
  }

  item {
    key   = "CPU Count"
    value = data.coder_parameter.cpu.value
  }

  item {
    key   = "Memory (GB)"
    value = data.coder_parameter.memory.value
  }

  item {
    key   = "Volume Size (GB)"
    value = data.coder_parameter.volume-size.value
  }
}
