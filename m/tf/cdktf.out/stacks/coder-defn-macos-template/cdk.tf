terraform {
  required_providers {
    coder = {
      version = "0.13.0"
      source  = "coder/coder"
    }
  }
  backend "local" {

  }


}
data "coder_parameter" "homedir" {
  default      = "/home/ubuntu"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  name         = "homedir"
  type         = "string"
}
data "coder_workspace" "me" {
}


resource "null_resource" "main" {
  triggers = {
    always_run = coder_agent.main.token
  }

  provisioner "local-exec" {
    when = create
    command = "( (echo pkill -9 -f coder.agent '||' true; echo pkill -9 -f code-server '||' true; echo cd; echo export STARSHIP_NO=1 CODER_AGENT_TOKEN=${coder_agent.main.token}; echo source .bash_profile; echo ${base64encode(coder_agent.main.init_script)} | base64 -d) | bash -x - >>/tmp/startup.log 2>&1 &) &"
  }
}

resource "coder_agent" "main" {
  arch = "amd64"
  auth = "token"
  env = {
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
  }
  os                     = "darwin"
  startup_script         = "export STARSHIP_NO= && source .bash_profile && code-server --auth none"
  startup_script_timeout = 180
  display_apps {
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}
resource "coder_app" "code-server" {
  agent_id     = "${coder_agent.main.id}"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "code-server"
  subdomain    = false
  url          = "http://localhost:8080/?folder=${data.coder_parameter.homedir.value}"
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:8080/healthz"
  }
}

provider "coder" {
}

module "coder_login" {
  agent_id = "${coder_agent.main.id}"
  source   = "https://registry.coder.com/modules/coder-login"
}

