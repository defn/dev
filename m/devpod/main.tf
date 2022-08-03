resource "kubernetes_stateful_set" "dev" {
  for_each = var.envs

  metadata {
    name      = each.key
    namespace = "default"
  }

  wait_for_rollout = false

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dev"
      }
    }

    template {
      metadata {
        labels = {
          app = "dev"
        }
      }

      spec {

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "env"
                  operator = "In"
                  values   = [each.key]
                }
              }
            }
          }
        }

        toleration {
          key      = "env"
          operator = "Equal"
          value    = each.key
        }

        volume {
          name = "work"
          empty_dir {}
        }

        volume {
          name = "certs"
          host_path {
            path = "/var/lib/tailscale/certs"
          }
        }

        container {
          name              = "dev"
          image             = "defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["tail", "-f", "/dev/null"]

          env {
            name  = "DEFN_DEV_WORKDIR"
            value = each.value.workdir
          }

          env {
            name  = "DEFN_DEV_HOST"
            value = each.value.host
          }

          env {
            name  = "DEFN_DEV_IP"
            value = each.value.ip
          }

          volume_mount {
            name       = "work"
            mount_path = "/home/ubuntu/work"
          }

          volume_mount {
            name       = "certs"
            mount_path = "/var/lib/tailscale/certs"
          }
        }

        container {
          name              = "code-server"
          image             = "defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "exec ~/bin/e code-server --bind-addr 0.0.0.0:8888"]


          env {
            name  = "DEFN_DEV_WORKDIR"
            value = each.value.workdir
          }

          env {
            name  = "DEFN_DEV_HOST"
            value = each.value.host
          }

          env {
            name  = "DEFN_DEV_IP"
            value = each.value.ip
          }

          env {
            name  = "PASSWORD"
            value = "admin"
          }

          volume_mount {
            name       = "work"
            mount_path = "/home/ubuntu/work"
          }

          volume_mount {
            name       = "certs"
            mount_path = "/var/lib/tailscale/certs"
          }
        }

        container {
          name              = "vault"
          image             = "defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "exec ~/bin/e vault server -config vault.yaml"]

          volume_mount {
            name       = "work"
            mount_path = "/home/ubuntu/work"
          }
        }

        container {
          name              = "doh"
          image             = "defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "exec ~/bin/e cloudflared proxy-dns --port 5553"]
        }

        container {
          name              = "buildkitd"
          image             = "earthly/buildkitd:v0.6.19"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "BUILDKIT_TCP_TRANSPORT_ENABLED"
            value = "true"
          }

          env {
            name  = "BUILDKIT_MAX_PARALLELISM"
            value = "4"
          }

          env {
            name  = "CACHE_SIZE_PCT"
            value = "90"
          }

          security_context {
            privileged = true
          }

          tty = true
        }

        container {
          name              = "registry"
          image             = "registry:2"
          image_pull_policy = "IfNotPresent"
        }
      }
    }

    service_name = "dev"
  }
}

resource "kubernetes_service" "vault" {
  metadata {
    name      = "vault"
    namespace = "default"
  }

  spec {
    selector = {
      app = "dev"
    }

    port {
      port        = 8200
      target_port = 8200
    }

    session_affinity = "ClientIP"
    type             = "ClusterIP"
  }
}

resource "kubernetes_service" "code_server" {
  metadata {
    name      = "code-server"
    namespace = "default"
  }

  spec {
    selector = {
      app = "dev"
    }

    port {
      port        = 8888
      target_port = 8888
    }

    session_affinity = "ClientIP"
    type             = "ClusterIP"
  }
}

resource "kubernetes_cluster_role_binding" "dev" {
  metadata {
    name = "dev"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}

resource "kubernetes_ingress_v1" "code_server" {
  metadata {
    name      = "code-server"
    namespace = "default"

    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "https8888"
      "traefik.ingress.kubernetes.io/router.tls"         = "true"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "code-server"

              port {
                number = 8888
              }
            }
          }
        }
      }
    }
  }
}

