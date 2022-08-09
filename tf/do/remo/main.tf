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
  for_each = local.want == 0 ? {} : local.droplets

  cluster_id = data.digitalocean_kubernetes_cluster.dev.id

  name       = "${local.cluster}-${each.key}"
  size       = each.value.size
  node_count = 1
  tags       = [each.key]

  labels = {
    env = each.key
  }

  taint {
    effect = "NoSchedule"
    key    = "env"
    value  = each.key
  }
}
