terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.6"
    }
  }
}

data "coder_provisioner" "this" {}

data "coder_workspace" "this" {}

resource "coder_agent" "macos" {
  arch = data.coder_provisioner.this.arch
  os   = "darwin"

  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.this.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.this.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.this.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.this.owner_email}"
  }

  startup_script = "exec /usr/local/bin/code-server --auth none"
}

#resource "coder_app" "code-server" {
#  agent_id = coder_agent.macos.id
#
#  url  = "http://localhost:8080/"
#  icon = "/icon/code.svg"
#
#  slug         = "dev"
#  display_name = "code-server"
#
#  subdomain = true
#  share     = "owner"
#
#  healthcheck {
#    url       = "http://localhost:8080/healthz"
#    interval  = 3
#    threshold = 10
#  }
#}

resource "coder_app" "tilt" {
  agent_id = coder_agent.macos.id

  url  = "http://localhost:10350/"
  icon = "https://avatars.githubusercontent.com/u/26349925?s=200&v=4"

  slug         = "tilt"
  display_name = "tilt"

  subdomain = true
  share     = "owner"

  healthcheck {
    url       = "http://localhost:10350"
    interval  = 3
    threshold = 10
  }
}

resource "local_file" "coder-agent-token" {
  filename = "/tmp/coder-agent-token"
  content  = coder_agent.macos.token
}
