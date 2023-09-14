data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  auth = "aws-instance-identity"

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
    GIT_AUTHOR_NAME     = data.coder_workspace.me.owner
    GIT_COMMITTER_NAME  = data.coder_workspace.me.owner
    GIT_AUTHOR_EMAIL    = data.coder_workspace.me.owner_email
    GIT_COMMITTER_EMAIL = data.coder_workspace.me.owner_email

    LOCAL_ARCHIVE = "/usr/lib/locale/locale-archive"
    LC_ALL        = "C.UTF-8"
  }
}

resource "coder_metadata" "main" {
  count       = local.aws_ec2_count
  resource_id = aws_instance.dev[count.index].id
  item {
    key   = "instance type"
    value = aws_instance.dev[count.index].instance_type
  }
  item {
    key   = "disk"
    value = "${aws_instance.dev[count.index].root_block_device[0].volume_size} GiB"
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  url          = "http://localhost:13337/?folder=/home/${local.username}/m"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

