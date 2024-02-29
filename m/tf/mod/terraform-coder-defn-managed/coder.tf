data "coder_workspace" "me" {}

locals {
  owner  = lower(data.coder_workspace.me.owner)
  name   = lower(data.coder_workspace.me.name)
  domain = "defn.run"
  parent = "district"

  username = "ubuntu"

  prefix = "defn"
  app    = "cs"
}

resource "coder_agent" "main" {
  arch                   = "amd64"
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = file("${path.module}/startup.sh")

  display_apps {
    vscode          = false
    vscode_insiders = false
    ssh_helper      = false
  }

  env = {
    GIT_AUTHOR_NAME     = local.owner
    GIT_COMMITTER_NAME  = local.owner
    GIT_AUTHOR_EMAIL    = data.coder_workspace.me.owner_email
    GIT_COMMITTER_EMAIL = data.coder_workspace.me.owner_email

    LOCAL_ARCHIVE = "/usr/lib/locale/locale-archive"
    LC_ALL        = "C.UTF-8"

    DFD_OWNER  = local.owner
    DFD_NAME   = local.name
    DFD_PREFIX = local.prefix
    DFD_APP    = local.app

    DFD_REGISTRY = "cache.${local.domain}:5000"
    DFD_CONTEXT  = "${local.prefix}-${local.owner}-${local.name}-cluster"

    DFD_PARENT = "${local.parent}.${local.owner}.${local.domain}"
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = local.app
  display_name = "code-server"
  url          = "http://localhost:13337/"
  icon         = "/icon/code.svg"
  share        = "owner"
  subdomain    = true
}

module "coder-login" {
  source   = "https://registry.coder.com/modules/coder-login"
  agent_id = coder_agent.main.id
}
