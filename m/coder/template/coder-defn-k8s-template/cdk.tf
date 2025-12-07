terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  backend "local" {}
}

provider "coder" {
  url = "http://coder.coder.svc.cluster.local"
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
  subdomain    = false
  open_in      = "tab"
  order        = 0
  healthcheck {
    url       = "http://localhost:8080/healthz"
    interval  = 5
    threshold = 999999999
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
provider "kubernetes" {
  config_path = var.use_kubeconfig == true ? "/home/ubuntu/m/k3d/.kube/config" : null
}

variable "use_kubeconfig" {
  type    = bool
  default = true
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores"
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "1 Core"
    value = "1"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory in GB"
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "1 GB"
    value = "1"
  }
}

data "coder_parameter" "provider" {
  default      = "k8s-pod"
  description  = "The service provider to deploy the workspace in"
  display_name = "Provider"
  icon         = "/emojis/1f30e.png"
  name         = "provider"
  option {
    name  = "Kubernetes Pod"
    value = "k8s-pod"
  }
}


resource "kubernetes_deployment" "main" {
  count            = data.coder_workspace.me.start_count
  wait_for_rollout = false
  metadata {
    name      = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}")
    namespace = lower("coder-${data.coder_workspace_owner.me.name}")
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}")
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = lower(data.coder_workspace.me.id)
      "com.coder.workspace.name"   = lower(data.coder_workspace.me.name)
      "com.coder.user.id"          = lower(data.coder_workspace_owner.me.id)
      "com.coder.user.username"    = lower(data.coder_workspace_owner.me.name)
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace_owner.me.email
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name"     = "coder-workspace"
        "app.kubernetes.io/instance" = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}")
        "app.kubernetes.io/part-of"  = "coder"
        "com.coder.resource"         = "true"
        "com.coder.workspace.id"     = lower(data.coder_workspace.me.id)
        "com.coder.workspace.name"   = lower(data.coder_workspace.me.name)
        "com.coder.user.id"          = lower(data.coder_workspace_owner.me.id)
        "com.coder.user.username"    = lower(data.coder_workspace_owner.me.name)
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"     = "coder-workspace"
          "app.kubernetes.io/instance" = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}")
          "app.kubernetes.io/part-of"  = "coder"
          "com.coder.resource"         = "true"
          "com.coder.workspace.id"     = lower(data.coder_workspace.me.id)
          "com.coder.workspace.name"   = lower(data.coder_workspace.me.name)
          "com.coder.user.id"          = lower(data.coder_workspace_owner.me.id)
          "com.coder.user.username"    = lower(data.coder_workspace_owner.me.name)
        }
      }

      spec {
        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }

        volume {
          name = "user"
          persistent_volume_claim {
            claim_name = lower("coder-${data.coder_workspace_owner.me.name}")
            read_only  = false
          }
        }
        volume {
          name = "docker-sock"
          host_path {
            path = "/var/run/docker.sock"
          }
        }

        container {
          name              = "dev"
          image             = "ghcr.io/defn/dev:v1.57.1-amd64"
          image_pull_policy = "Always"
          command           = ["/bin/tini", "--", "bash", "-c", "cd; source .bash_profile; cd m; ./entrypoint.sh"]

          // chown these mounts in m/bin/startup.sh
          volume_mount {
            mount_path = "/home/ubuntu/.local/share/code-server/extensions"
            name       = "user"
            read_only  = false
            sub_path   = "local-share-code-server-extensions"
          }
          volume_mount {
            mount_path = "/home/ubuntu/.config/gh"
            name       = "user"
            read_only  = false
            sub_path   = "config-gh"
          }
          volume_mount {
            mount_path = "/home/ubuntu/dotfiles"
            name       = "user"
            read_only  = false
            sub_path   = "dotfiles"
          }
          volume_mount {
            mount_path = "/var/run/docker.sock"
            name       = "docker-sock"
          }
          security_context {
            run_as_user = "1000"
          }

          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          env {
            name  = "CODER_AGENT_URL"
            value = "http://coder.coder"
          }
          env {
            name  = "CODER_NAME"
            value = lower(data.coder_workspace.me.name)
          }
          env {
            name  = "CODER_HOMEDIR"
            value = data.coder_parameter.homedir.value
          }
          env {
            name  = "GIT_AUTHOR_EMAIL"
            value = data.coder_workspace_owner.me.email
          }
          env {
            name  = "GIT_AUTHOR_NAME"
            value = data.coder_workspace_owner.me.name
          }
          env {
            name  = "GIT_COMMITTER_EMAIL"
            value = data.coder_workspace_owner.me.email
          }
          env {
            name  = "GIT_COMMITTER_NAME"
            value = data.coder_workspace_owner.me.name
          }
        }
      }
    }
  }
}

