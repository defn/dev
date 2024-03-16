terraform {
  required_providers {
    null = {
      version = "3.2.2"
      source  = "null"
    }
    coder = {
      version = "0.13.0"
      source  = "coder/coder"
    }
  }
  backend "local" {

  }

}

data "coder_parameter" "homedir" {
  default      = "/home/ubuntu/m"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "homedir"
  type         = "string"
}

data "coder_parameter" "remote" {
  default      = ""
  description  = "Remote ssh"
  display_name = "Remote ssh"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "remote"
  type         = "string"
}

data "coder_parameter" "arch" {
  default      = "amd64"
  description  = "CPU arch"
  display_name = "CPU arch"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
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
    LC_ALL              = "C.UTF-8"
    LOCAL_ARCHIVE       = "/usr/lib/locale/locale-archive"
  }
  os                     = "linux"
  startup_script         = "export STARSHIP_NO= && source .bash_profile && code-server --auth none"
  startup_script_timeout = 180
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
  provisioner "local-exec" {
    command = "( (echo pkill -9 -f coder.agent '||' true; echo pkill -9 -f code-server '||' true; echo cd; echo export STARSHIP_NO=1 CODER_AGENT_TOKEN=${coder_agent.main.token}; echo source .bash_profile; echo ${base64encode(coder_agent.main.init_script)} | base64 -d) | ssh ${data.coder_parameter.remote.value} bash -x - >>/tmp/startup2.log 2>&1 &) &"
    when    = create
  }
}

provider "coder" {
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
