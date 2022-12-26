terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.2"
    }
  }
}

data "coder_provisioner" "this" {}

provider "docker" {}

data "coder_workspace" "this" {}

resource "coder_agent" "main" {
  arch = data.coder_provisioner.this.arch
  os   = "linux"

  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.this.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.this.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.this.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.this.owner_email}"
  }

  startup_script = "exec ~/.nix-profile/bin/nix run .#codeserver -- --auth none"
}

resource "coder_app" "code-server" {
  agent_id = coder_agent.main.id

  url  = "http://localhost:8080/?folder=/home/ubuntu"
  icon = "/icon/code.svg"

  slug         = "code-server"
  display_name = "code-server"

  subdomain = false
  share     = "owner"

  healthcheck {
    url       = "http://localhost:8080/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "docker_volume" "nix_volume" {
  name = "coder-${data.coder_workspace.this.id}-nix"

  lifecycle {
    ignore_changes = all
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace.this.owner
  }

  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.this.owner_id
  }

  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.this.id
  }

  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.this.name
  }
}

resource "docker_volume" "work_volume" {
  name = "coder-${data.coder_workspace.this.id}-work"

  lifecycle {
    ignore_changes = all
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace.this.owner
  }

  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.this.owner_id
  }

  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.this.id
  }

  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.this.name
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.this.start_count

  image = "ghcr.io/defn/dev:latest-devcontainer"

  name     = "coder-${data.coder_workspace.this.owner}-${lower(data.coder_workspace.this.name)}"
  hostname = data.coder_workspace.this.name

  privileged = true

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}"
  ]

  entrypoint = [
    "bash", "-c",
    "set -xfu; cd; git pull; bash -x bin/persist-cache; export CODER_AGENT_AUTH=token; export CODER_AGENT_URL=http://host.docker.internal:5555/; exec ~/.nix-profile/bin/nix run .#coder -- agent"
  ]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  mounts {
    type   = "bind"
    source = "/var/run/docker.sock"
    target = "/var/run/docker.sock"
  }

  mounts {
    type   = "bind"
    source = "/tmp/cache/nix"
    target = "/tmp/cache/nix"
  }

  volumes {
    container_path = "/nix"
    volume_name    = docker_volume.nix_volume.name
    read_only      = false
  }

  volumes {
    container_path = "/work"
    volume_name    = docker_volume.work_volume.name
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace.this.owner
  }

  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.this.owner_id
  }

  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.this.id
  }

  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.this.name
  }
}
