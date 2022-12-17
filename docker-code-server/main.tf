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

  startup_script = "/home/ubuntu/.nix-profile/bin/nix run github:defn/pkg/codeserver-4.9.1-1?dir=codeserver -- --auth none"
}

resource "coder_app" "code-server" {
  agent_id = coder_agent.main.id

  url  = "http://localhost:8080/?folder=/home/ubuntu"
  icon = "/icon/code.svg"

  slug         = "code-server"
  display_name = "code-server"

  subdomain = true
  share     = "owner"

  healthcheck {
    url       = "http://localhost:8080/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.this.id}-home"

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

  name     = "coder-${data.coder_workspace.this.owner}-${lower(data.coder_workspace.this.name)}"
  hostname = data.coder_workspace.this.name

  image = "ghcr.io/defn/dev:latest-devcontainer"

  env = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/nix"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  volumes {
    container_path = "/work"
    volume_name    = docker_volume.home_volume.name
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
