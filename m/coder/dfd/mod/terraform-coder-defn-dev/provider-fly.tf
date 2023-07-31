
locals {
  fly = {
    nix_size = data.coder_parameter.nix_volume_size.value
    region   = "lax"
    image    = data.coder_parameter.docker_image.value
    cpus     = data.coder_parameter.cpu.value
    cputype  = "performance"
    memorymb = data.coder_parameter.memory.value * 1024
  }
}

resource "fly_app" "workspace" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  org  = "personal"
}

resource "fly_volume" "nix_volume" {
  app    = fly_app.workspace.name
  name   = "coder_${data.coder_workspace.me.owner}_${lower(replace(data.coder_workspace.me.name, "-", "_"))}_nix"
  size   = local.fly.nix_size
  region = local.fly.region
}

resource "fly_machine" "workspace" {
  count = data.coder_workspace.me.start_count

  app      = fly_app.workspace.name
  region   = local.fly.region
  name     = data.coder_workspace.me.name
  image    = local.fly.image
  cpus     = local.fly.cpus
  cputype  = local.fly.cputype
  memorymb = local.fly.memorymb

  env = {
    CODER_AGENT_TOKEN = coder_agent.main.token
  }

  entrypoint = ["bash", "-c", coder_agent.main.init_script]

  services = [{
    ports = [{
      port     = 443
      handlers = ["tls", "http"]
      }, {
      port     = 80
      handlers = ["http"]
    }]

    protocol        = "tcp",
    "internal_port" = 80
    }, {
    ports = [{
      port     = 8080
      handlers = ["tls", "http"]
    }]

    protocol        = "tcp",
    "internal_port" = 8080
  }]

  mounts = [{
    volume = fly_volume.nix_volume.id
    path   = "/nix"
  }]
}