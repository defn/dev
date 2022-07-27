terraform {
  cloud {
    organization = "defn"

    workspaces {
      name = "dev-defn"
    }
  }
}

data "digitalocean_kubernetes_cluster" "dev" {
  name = local.cluster
}


provider "digitalocean" {}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.dev.endpoint
  token = data.digitalocean_kubernetes_cluster.dev.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.dev.kube_config[0].cluster_ca_certificate
  )
}

resource "digitalocean_container_registry_docker_credentials" "dev" {
  registry_name = data.digitalocean_kubernetes_cluster.dev.name
}


resource "kubernetes_secret" "dev" {
  metadata {
    name      = "registry"
    namespace = "default"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.dev.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "digitalocean_kubernetes_node_pool" "dev" {
  cluster_id = data.digitalocean_kubernetes_cluster.dev.id

  name       = "${local.cluster}-${local.name}"
  size       = local.size
  node_count = 1
  tags       = [local.name]

  labels = {
    env = local.name
  }

  taint {
    effect = "NoSchedule"
    key    = "env"
    value  = local.name
  }
}

resource "kubernetes_stateful_set" "dev" {
  metadata {
    name      = local.name
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
                  values   = [local.name]
                }
              }
            }
          }
        }

        toleration {
          key      = "env"
          operator = "Equal"
          value    = local.name
        }

        volume {
          name = "work"
          empty_dir {}
        }

        container {
          name              = "dev"
          image             = "defn/dev:latest"
          image_pull_policy = "Always"

          command = ["/usr/bin/tini", "--"]
          args    = ["tail", "-f", "/dev/null"]

          volume_mount {
            name       = "work"
            mount_path = "/home/ubuntu/work"
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

