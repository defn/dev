provider "docker" {}

resource "docker_image" "main" {
  name = "quay.io/defn/dev:latest"
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count

  image = docker_image.main.name

  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"

  hostname = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"

  entrypoint = ["bash", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/nix"
    volume_name    = "defn-dev-nix"
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
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