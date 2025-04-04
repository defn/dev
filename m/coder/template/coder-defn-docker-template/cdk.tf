terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
  backend "local" {}
}

provider "coder" {
}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

data "coder_parameter" "homedir" {
  default      = "/home/ubuntu/m"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "homedir"
  type         = "string"
}

data "coder_parameter" "os" {
  default      = "linux"
  description  = "Operating system"
  display_name = "Operation system"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "os"
  type         = "string"
}

data "coder_parameter" "arch" {
  default      = "amd64"
  description  = "CPU arch"
  display_name = "CPU arch"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "arch"
  type         = "string"
}

resource "coder_agent" "main" {
  arch = data.coder_parameter.arch.value
  auth = "token"
  os   = data.coder_parameter.os.value
  display_apps {
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}

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

//
// params
//

//
// custom
//

variable "docker_socket" {
  default = ""
  type    = string
}

provider "docker" {
  host = var.docker_socket != "" ? var.docker_socket : null
}

resource "docker_volume" "dotfiles_volume" {
  name = "coder-${data.coder_workspace.me.id}-dotfiles"

  lifecycle {
    ignore_changes = all
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_volume" "code_server_extensions_volume" {
  name = "coder-${data.coder_workspace.me.id}-code-server-extensions"

  lifecycle {
    ignore_changes = all
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

data "docker_registry_image" "defn_dev" {
  name = "ghcr.io/defn/dev:latest"
}

resource "docker_image" "workspace" {
  name          = "${data.docker_registry_image.defn_dev.name}@${data.docker_registry_image.defn_dev.sha256_digest}"
  pull_triggers = [data.docker_registry_image.defn_dev.sha256_digest]
  keep_locally  = true
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count

  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"

  image    = docker_image.workspace.name
  hostname = data.coder_workspace.me.name

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "CODER_AGENT_URL=${data.coder_workspace.me.access_url}",
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "CODER_NAME=${data.coder_workspace.me.name}",
    "CODER_HOMEDIR=${data.coder_parameter.homedir.value}",
    "CODER_INIT_SCRIPT_BASE64=${base64encode(coder_agent.main.init_script)}",
    "GIT_AUTHOR_EMAIL=${data.coder_workspace_owner.me.email}",
    "GIT_AUTHOR_NAME=${data.coder_workspace_owner.me.name}",
    "GIT_COMMITTER_EMAIL=${data.coder_workspace_owner.me.email}",
    "GIT_COMMITTER_NAME=${data.coder_workspace_owner.me.name}",
  ]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/home/ubuntu/.local/share/code-server/extensions"
    volume_name    = docker_volume.code_server_extensions_volume.name
    read_only      = false
  }

  volumes {
    container_path = "/home/ubuntu/dotfiles"
    volume_name    = docker_volume.dotfiles_volume.name
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

