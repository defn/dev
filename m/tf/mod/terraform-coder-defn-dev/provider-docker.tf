provider "docker" {
  host = "unix:///Users/defn/.docker/run/docker.sock"
}

resource "docker_image" "main" {
  count = local.docker_count

  name = data.coder_parameter.docker_image.value
}

resource "docker_container" "workspace" {
  count = local.docker_count * data.coder_workspace.me.start_count

  image = docker_image.main[count.index].name

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
}