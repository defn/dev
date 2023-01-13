terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.0"
    }
  }
}

data "coder_provisioner" "this" {}

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

  startup_script = "exec /usr/local/bin/code-server --auth none"
}

resource "coder_app" "code-server" {
  agent_id = coder_agent.main.id

  url  = "http://localhost:8080/?folder=/Users/defn"
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

resource "local_file" "token" {
  filename = "/Users/defn/.config/coderv2/coder-agent-token"
  content  = coder_agent.main.token
}
