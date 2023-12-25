locals {
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = local.ns
  }
}

resource "kubernetes_service_account" "main" {
  metadata {
    name      = local.ns
    namespace = local.ns
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::510430971399:role/ro"
    }
  }
}

resource "helm_release" "main" {
  count      = data.coder_parameter.vcluster.value
  name       = "vcluster"
  namespace  = local.ns
  repository = "https://charts.loft.sh"
  chart      = "vcluster"
  version    = "0.17.1"

  set {
    name  = "sync.pods.ephemeralContainers"
    value = "true"
  }

  set {
    name  = "sync.persistentvolumes.enabled"
    value = "true"
  }

  set {
    name  = "sync.ingresses.enabled"
    value = "true"
  }

  set {
    name  = "sync.nodes.enabled"
    value = "true"
  }

  set {
    name  = "sync.serviceaccounts.enabled"
    value = "true"
  }
}

resource "kubernetes_cluster_role_binding" "main" {
  metadata {
    name = local.ns
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.ns
    namespace = local.ns
  }
}

resource "kubernetes_deployment" "main" {
  wait_for_rollout = false

  metadata {
    name      = local.ns
    namespace = local.ns

    labels = {
      "app.kubernetes.io/name"     = local.ns
      "app.kubernetes.io/instance" = local.ns
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace.me.owner_id
      "com.coder.user.username"    = data.coder_workspace.me.owner
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace.me.owner_email
    }
  }

  spec {
    replicas = local.pod_count * data.coder_workspace.me.start_count

    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.ns
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.ns
        }
        annotations = {
          "linkerd.io/inject" = "enabled"
        }
      }

      spec {
        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }

        service_account_name = local.ns

        container {
          name              = "coder-agent"
          image             = data.coder_parameter.docker_image.value
          image_pull_policy = "Always"
          command           = ["bash", "-c", coder_agent.main.init_script]

          security_context {
            run_as_user = "1000"
            privileged  = true
          }

          env {
            name  = "CODER_PROC_MEMNICE_ENABLE"
            value = "1"
          }

          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }

          volume_mount {
            mount_path = "/var/run/docker.sock"
            name       = "docker"
            read_only  = false
          }

        }

        volume {
          name = "docker"
          host_path {
            path = "/var/run/docker.sock"
          }
        }

      }
    }
  }
}
