terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
  }
}

data "coder_workspace" "me" {}

resource "coder_agent" "dev" {
  os             = "linux"
  arch           = "amd64"
  dir            = "/workspace"
  startup_script = <<EOF
code-server --auth none --port 13337
EOF
}

resource "coder_app" "dev" {
  agent_id          = coder_agent.dev.id
  name              = "VS Code"
  icon              = data.coder_workspace.me.access_url + "/icons/vscode.svg"
  url               = "http://localhost:13337"
  relative_path     = true
}