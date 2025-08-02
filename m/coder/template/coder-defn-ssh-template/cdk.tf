terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    null = {
      source = "null"
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

data "coder_parameter" "ai_prompt" {
    name = "AI Prompt"
    type = "string"
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

  env = {
    CODER_MCP_CLAUDE_TASK_PROMPT   = data.coder_parameter.ai_prompt.value
    CODER_MCP_APP_STATUS_SLUG      = "claude-code"
    CODER_MCP_CLAUDE_SYSTEM_PROMPT = <<-EOT
      Be terse.
    EOT
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "cs"
  subdomain    = data.coder_parameter.subdomain.value
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

data "coder_parameter" "remote" {
  default      = ""
  description  = "Remote ssh"
  display_name = "Remote ssh"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "remote"
  type         = "string"
}

data "coder_parameter" "subdomain" {
  default      = true
  description  = "Use subdomain"
  display_name = "Use sudomain"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "subdomain"
  type         = "bool"
}

//
// custom
//

provider "null" {
}

resource "null_resource" "deploy" {
  triggers = {
    always_run = "${coder_agent.main.token}"
  }
  count = data.coder_workspace.me.start_count
  provisioner "local-exec" {
    command = "(echo cd; echo cd m; echo exec env GIT_AUTHOR_EMAIL=${data.coder_workspace_owner.me.email} GIT_AUTHOR_NAME=${data.coder_workspace_owner.me.name} GIT_COMMITTER_EMAIL=${data.coder_workspace_owner.me.email} GIT_COMMITTER_NAME=${data.coder_workspace_owner.me.name} CODER_AGENT_URL_ORIGINAL=${data.coder_workspace.me.access_url} CODER_AGENT_URL=${data.coder_parameter.remote.value == "" ? "http://169.254.32.1:3000" : data.coder_workspace.me.access_url} CODER_AGENT_TOKEN=${coder_agent.main.token} CODER_NAME=${data.coder_workspace.me.name} CODER_HOMEDIR=${data.coder_parameter.homedir.value} CODER_AGENT_DEVCONTAINERS_ENABLE=true ./entrypoint.sh setup) | ${data.coder_parameter.remote.value} bash -x -"
    when    = create
  }
}


module "claude-code" {
  count               = data.coder_workspace.me.start_count
  source              = "registry.coder.com/coder/claude-code/coder"
  version             = "2.0.5"
  agent_id            = coder_agent.main.id
  folder              = "/home/ubuntu"
  install_claude_code = false

  experiment_report_tasks = true
}

module "coder-login" {
  count    = data.coder_workspace.me.start_count
  source   = "registry.coder.com/coder/coder-login/coder"
  version  = "1.0.31"
  agent_id = coder_agent.main.id
}
