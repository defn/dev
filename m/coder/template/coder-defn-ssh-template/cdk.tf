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

data "coder_parameter" "username" {
  default      = "ubuntu"
  description  = "Linux account name"
  display_name = "Username"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "username"
  type         = "string"
}

data "coder_parameter" "ai_prompt" {
  name    = "AI Prompt"
  type    = "string"
  mutable = false
}

data "coder_parameter" "system_prompt" {
  default = "Be succinct, no marketing or kissing ass"
  name    = "System Prompt"
  mutable = false
}

resource "coder_agent" "main" {
  arch = data.coder_parameter.arch.value
  auth = "token"
  os   = data.coder_parameter.os.value

  startup_script = <<-EOT
    set -e
    exec >>/tmp/coder-agent.log
    exec 2>&1
    cd
    ssh -o StrictHostKeyChecking=no git@github.com true || true
    git fetch origin
    git reset --hard origin/main

    cd ~/m
    bin/startup.sh || true
  EOT

  env = {
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace_owner.me.email}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace_owner.me.name}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace_owner.me.email}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace_owner.me.name}"
    LC_ALL              = "C.UTF-8"
    LOCAL_ARCHIVE       = "/usr/lib/locale/locale-archive"
  }

  connection_timeout = 200
  display_apps {
    web_terminal    = false
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}

resource "coder_app" "preview" {
  agent_id     = coder_agent.main.id
  slug         = "preview"
  display_name = "Preview"
  icon         = "/emojis/1f50e.png"
  url          = "http://localhost:3001"
  share        = "owner"
  subdomain    = true
  open_in      = "tab"
  order        = 0
  healthcheck {
    url       = "http://localhost:3001/"
    interval  = 5
    threshold = 15
  }
}

resource "coder_ai_task" "task" {
  count  = data.coder_workspace.me.start_count
  app_id = coder_app.code-server.id
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "cs"
  subdomain    = true
  url          = "http://localhost:8080/?folder=${data.coder_parameter.homedir.value}"
  order        = 2
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:8080/healthz"
  }
  open_in = "tab"
}

// implementation

data "coder_parameter" "remote" {
  default      = ""
  description  = "Remote ssh"
  display_name = "Remote ssh"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "remote"
  type         = "string"
}

provider "null" {
}

resource "null_resource" "deploy" {
  triggers = {
    always_run = "${coder_agent.main.token}"
  }
  count = data.coder_workspace.me.start_count
  provisioner "local-exec" {
    command = "(echo cd; echo cd m; echo exec env GIT_AUTHOR_EMAIL=${data.coder_workspace_owner.me.email} GIT_AUTHOR_NAME=${data.coder_workspace_owner.me.name} GIT_COMMITTER_EMAIL=${data.coder_workspace_owner.me.email} GIT_COMMITTER_NAME=${data.coder_workspace_owner.me.name} CODER_AGENT_URL_ORIGINAL=${data.coder_workspace.me.access_url} CODER_AGENT_URL=${data.coder_parameter.remote.value == "" ? "http://169.254.32.1:3000" : data.coder_workspace.me.access_url} CODER_AGENT_TOKEN=${coder_agent.main.token} CODER_NAME=${data.coder_workspace.me.name} CODER_HOMEDIR=${data.coder_parameter.homedir.value} CODER_AGENT_DEVCONTAINERS_ENABLE=true CODER_SESSION_TOKEN=${data.coder_workspace_owner.me.session_token} CODER_URL=${data.coder_workspace.me.access_url} ./entrypoint.sh setup) | ${data.coder_parameter.remote.value} bash -x -"
    when    = create
  }
}
