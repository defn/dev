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

    volume_claim_template {
      metadata {
        name = "work"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1G"
          }
        }
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
          name = "dind"
          empty_dir {}
        }

        volume {
          name = "earthly"
          host_path {
            path = "/mnt/earthly"
          }
        }

        volume {
          name = "docker"
          host_path {
            path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "tailscale"
          host_path {
            path = "/var/lib/tailscale/pod/var/lib/tailscale"
          }
        }

        volume {
          name = "tsrun"
          empty_dir {}
        }

        container {
          name              = "dev"
          image             = "quay.io/defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["tail", "-f", "/dev/null"]

          tty = true

          env {
            name  = "DEFN_DEV_HOST"
            value = each.value.host
          }

          volume_mount {
            name       = "docker"
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "work"
            mount_path = "/work"
          }

          volume_mount {
            name       = "tsrun"
            mount_path = "/var/run/tailscale"
          }

          security_context {
            privileged = true
          }
        }

        container {
          name              = "code-server"
          image             = "quay.io/defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "while true; do if test -S /var/run/tailscale/tailscaled.sock; then break; fi; sleep 1; done; sudo tailscale up --ssh --accept-dns=false --hostname=${each.key}-0; exec ~/bin/e code-server --bind-addr 0.0.0.0:8888 --disable-telemetry"]

          tty = true

          env {
            name  = "DEFN_DEV_HOST"
            value = each.value.host
          }

          env {
            name  = "PASSWORD"
            value = "admin"
          }

          volume_mount {
            name       = "docker"
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "work"
            mount_path = "/work"
          }

          volume_mount {
            name       = "tsrun"
            mount_path = "/var/run/tailscale"
          }

          security_context {
            privileged = true
          }
        }

        container {
          name              = "tailscale"
          image             = "quay.io/defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["sudo", "tailscaled", "--statedir", "/var/lib/tailscale"]

          volume_mount {
            name       = "work"
            mount_path = "/work"
          }

          volume_mount {
            name       = "tsrun"
            mount_path = "/var/run/tailscale"
          }

          volume_mount {
            name       = "tailscale"
            mount_path = "/var/lib/tailscale"
          }

          security_context {
            privileged = true
          }
        }

        container {
          name              = "caddy"
          image             = "quay.io/defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "(echo \"https://${each.key}-0.${each.value.domain} {\"; echo 'reverse_proxy http://localhost:8888'; echo '}') > Caddyfile; exec sudo `~ubuntu/bin/e asdf which caddy` run"]

          volume_mount {
            name       = "tsrun"
            mount_path = "/var/run/tailscale"
          }
        }

        container {
          name              = "vault"
          image             = "quay.io/defn/dev:latest"
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
          image             = "quay.io/defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["bash", "-c", "exec ~/bin/e cloudflared proxy-dns --port 5553"]
        }

        container {
          name              = "buildkit"
          image             = "earthly/buildkitd:v0.6.22"
          image_pull_policy = "IfNotPresent"
          command           = ["sh", "-c"]
          args              = ["awk '/if.*rm.*data_root.*then/ {print \"rm -rf $data_root || true; data_root=/tmp/meh;\" }; {print}' /var/earthly/dockerd-wrapper.sh > /tmp/1 && chmod 755 /tmp/1 && mv -f /tmp/1 /var/earthly/dockerd-wrapper.sh; exec /usr/bin/entrypoint.sh buildkitd --config=/etc/buildkitd.toml"]
          tty               = true

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

          volume_mount {
            name       = "earthly"
            mount_path = "/tmp/earthly"
          }

          security_context {
            privileged = true
          }
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
