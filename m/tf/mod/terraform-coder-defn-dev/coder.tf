data "coder_workspace" "me" {}

locals {
  username = "ubuntu"

  coder_name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"

  auth = local.aws_ec2_count == 1 ? "aws-instance-identity" : null

  user_data = <<EOT
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
hostname: coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
(setsid sudo -u ${local.username} sh -c '${coder_agent.main.init_script}') &

--//--
EOT
}

resource "coder_agent" "main" {
  auth = local.auth

  arch                   = "amd64"
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = file("${path.module}/startup.sh")

  env = {
    GIT_AUTHOR_NAME     = data.coder_workspace.me.owner
    GIT_COMMITTER_NAME  = data.coder_workspace.me.owner
    GIT_AUTHOR_EMAIL    = data.coder_workspace.me.owner_email
    GIT_COMMITTER_EMAIL = data.coder_workspace.me.owner_email

    LOCAL_ARCHIVE = "/usr/lib/locale/locale-archive"
    LC_ALL        = "C.UTF-8"
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  url          = "http://localhost:13337/?folder=/home/${local.username}/m"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "tilt" {
  agent_id     = coder_agent.main.id
  slug         = "tilt"
  display_name = "tilt"
  url          = "http://localhost:10350"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:10350"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "web" {
  agent_id     = coder_agent.main.id
  slug         = "web"
  display_name = "web"
  url          = "http://localhost:3002"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:3002"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "docs" {
  agent_id     = coder_agent.main.id
  slug         = "docs"
  display_name = "docs"
  url          = "http://localhost:3001"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:3001"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "storybook" {
  agent_id     = coder_agent.main.id
  slug         = "storybook"
  display_name = "storybook"
  url          = "http://localhost:6006"
  icon         = "/icon/code.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:6006"
    interval  = 5
    threshold = 6
  }
}

#resource "coder_app" "hugo" {
#  agent_id     = coder_agent.main.id
#  slug         = "hugo"
#  display_name = "hugo"
#  url          = "http://localhost:1313"
#  icon         = "/icon/code.svg"
#  subdomain    = true
#  share        = "owner"
#
#  healthcheck {
#    url       = "http://localhost:1313"
#    interval  = 5
#    threshold = 6
#  }
#}
#
#resource "coder_app" "temporal" {
#  agent_id     = coder_agent.main.id
#  slug         = "temporal"
#  display_name = "temporal"
#  url          = "http://localhost:8233"
#  icon         = "/icon/code.svg"
#  subdomain    = true
#  share        = "owner"
#
#  healthcheck {
#    url       = "http://localhost:8233"
#    interval  = 5
#    threshold = 6
#  }
#}
