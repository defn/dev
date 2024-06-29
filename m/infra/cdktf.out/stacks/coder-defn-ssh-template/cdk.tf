terraform {
  required_providers {
    coder = {
      version = "0.21.0"
      source  = "coder/coder"
    }
    null = {
      version = "3.2.2"
      source  = "null"
    }
  }
  backend "local" {

  }

}

provider "coder" {
}

data "coder_parameter" "homedir" {
  default      = "/home/ubuntu/m"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "homedir"
  type         = "string"
}

data "coder_parameter" "command" {
  default      = "j create-coder-agent"
  description  = "Remote command"
  display_name = "Remote command"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "command"
  type         = "string"
}

data "coder_parameter" "remote" {
  default      = ""
  description  = "Remote ssh"
  display_name = "Remote ssh"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "remote"
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

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch = data.coder_parameter.arch.value
  auth = "token"
  env = {
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
  }
  os             = data.coder_parameter.os.value
  startup_script = "cd ~ && j destroy-coder-agent && cd ~/m && exec j coder::code-server $${CODER_NAME}"
  display_apps {
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}

provider "null" {
}

resource "null_resource" "deploy" {
  triggers = {
    always_run = "${coder_agent.main.token}"
  }
  count = data.coder_workspace.me.start_count
  provisioner "local-exec" {
    command = "(echo cd; echo exec env CODER_AGENT_URL=${data.coder_workspace.me.access_url} CODER_AGENT_TOKEN=${coder_agent.main.token} CODER_NAME=${data.coder_workspace.me.name} CODER_HOMEDIR=${data.coder_parameter.homedir.value} CODER_INIT_SCRIPT_BASE64=${base64encode(coder_agent.main.init_script)} TS_AUTH_KEY=$(~/bin/ts-auth-key 2>/dev/null) ${data.coder_parameter.command.value}) | ${data.coder_parameter.remote.value} bash -x -"
    when    = create
  }
}

module "coder_login" {
  agent_id = coder_agent.main.id
  source   = "https://registry.coder.com/modules/coder-login"
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "cs"
  subdomain    = false
  url          = "http://localhost:8080/?folder=${data.coder_parameter.homedir.value}"
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:8080/healthz"
  }
}
