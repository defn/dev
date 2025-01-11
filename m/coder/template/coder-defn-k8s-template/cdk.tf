terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    coder = {
      version = "2.1.0"
      source  = "coder/coder"
    }
  }
  backend "local" {
  }
}

variable "use_kubeconfig" {
  type        = bool
  description = ""
  default     = true
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

data "coder_parameter" "homedir" {
  default      = "/home/ubuntu/m"
  description  = "home directory"
  display_name = "HOME dir"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  name         = "homedir"
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

data "coder_parameter" "nix_volume_size" {
  default      = "25"
  description  = "The size of the nix volume to create for the workspace in GB"
  display_name = "nix volume size"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  name         = "nix_volume_size"
  type         = "number"
  validation {
    max = 300
    min = 25
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

// coder
data "coder_workspace_owner" "me" {
}

data "coder_workspace" "me" {
}


resource "coder_agent" "main" {
  arch           = "amd64"
  os             = "linux"
  startup_script = <<-EOT
    set -e
    exec >>/tmp/coder-agent.log
    exec 2>&1
    cd
    ssh -o StrictHostKeyChecking=no git@github.com true || true
    git fetch origin
    git reset --hard origin/main

    cd ~/m
    bin/startup.sh
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
    ssh_helper      = false
    vscode          = false
    vscode_insiders = false
  }
}

// apps

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  display_name = "code-server"
  icon         = "/icon/code.svg"
  share        = "owner"
  slug         = "cs"
  subdomain    = true
  url          = "http://localhost:8080/?folder=${data.coder_parameter.homedir.value}"
  healthcheck {
    interval  = 5
    threshold = 6
    url       = "http://localhost:8080/healthz"
  }
}

// provider

provider "kubernetes" {
  config_path = var.use_kubeconfig == true ? "~/.kube/config" : null
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  }
}

resource "kubernetes_persistent_volume_claim" "work" {
  depends_on = [
    kubernetes_namespace.main
  ]
  metadata {
    name      = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    namespace = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    labels = {
      "app.kubernetes.io/name"     = "coder-pvc"
      "app.kubernetes.io/instance" = "coder-pcv-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace_owner.me.id
      "com.coder.user.username"    = data.coder_workspace_owner.me.name
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace_owner.me.email
    }
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${data.coder_parameter.nix_volume_size.value}Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "main" {
  count = data.coder_workspace.me.start_count
  depends_on = [
    kubernetes_persistent_volume_claim.work,
    kubernetes_namespace.main
  ]
  wait_for_rollout = false
  metadata {
    name      = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    namespace = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace_owner.me.id
      "com.coder.user.username"    = data.coder_workspace_owner.me.name
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
        "app.kubernetes.io/instance" = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
        "app.kubernetes.io/part-of"  = "coder"
        "com.coder.resource"         = "true"
        "com.coder.workspace.id"     = data.coder_workspace.me.id
        "com.coder.workspace.name"   = data.coder_workspace.me.name
        "com.coder.user.id"          = data.coder_workspace_owner.me.id
        "com.coder.user.username"    = data.coder_workspace_owner.me.name
      }
    }
    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"     = "coder-workspace"
          "app.kubernetes.io/instance" = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
          "app.kubernetes.io/part-of"  = "coder"
          "com.coder.resource"         = "true"
          "com.coder.workspace.id"     = data.coder_workspace.me.id
          "com.coder.workspace.name"   = data.coder_workspace.me.name
          "com.coder.user.id"          = data.coder_workspace_owner.me.id
          "com.coder.user.username"    = data.coder_workspace_owner.me.name
        }
      }
      spec {
        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }

        container {
          name              = "dev"
          image             = "169.254.32.1:5000/defn/dev:latest"
          image_pull_policy = "Always"
          command           = ["bash", "-c", "cd; source .bash_profile; git pull; j create-coder-agent-sync"]
          security_context {
            run_as_user = "1000"
          }
          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          env {
            name = "CODER_AGENT_URL"
            value = data.coder_workspace.me.access_url
          }
          env {
            name  = "CODER_NAME"
            value = data.coder_workspace.me.name
          }
          env {
            name  = "CODER_HOMEDIR"
            value = data.coder_parameter.homedir.value
          }
          env {
            name  = "CODER_INIT_SCRIPT_BASE64"
            value = base64encode(coder_agent.main.init_script)
          }

          volume_mount {
            mount_path = "/home/ubuntu/.local"
            name       = "work"
            read_only  = false
          }
        }

        volume {
          name = "work"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.work.metadata.0.name
            read_only  = false
          }
        }
      }
    }
  }
}
