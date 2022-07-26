terraform {
  cloud {
    organization = "defn"

    workspaces {
      name = "dev"
    }
  }
}

provider "digitalocean" {}

data "digitalocean_vpc" "dev" {
  name = "default-${local.region}"
}

data "digitalocean_ssh_key" "default" {
  name = "yubikey"
}

data "digitalocean_droplet_snapshot" "dev" {
  name_regex  = "^defn-dev"
  region      = local.region
  most_recent = true
}

data "digitalocean_kubernetes_versions" "dev" {
  version_prefix = "1.22"
}

resource "digitalocean_project" "dev" {
  name = local.name
}

resource "digitalocean_project_resources" "dev" {
  project = digitalocean_project.dev.id
  resources = concat(
    [
      for e in digitalocean_droplet.dev : e.urn
    ],
    [
      for e in digitalocean_volume.dev : e.urn
    ]
  )
}

resource "digitalocean_firewall" "dev" {
  name = local.name

  droplet_ids = [
    for e in digitalocean_droplet.dev : e.id
  ]

  inbound_rule {
    port_range = "22"
    protocol   = "tcp"
    source_addresses = [
      "96.78.173.0/24"
    ]
  }

  inbound_rule {
    port_range = "41641"
    protocol   = "udp"
    source_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  inbound_rule {
    port_range = "6443"
    protocol   = "tcp"
    source_addresses = [
      "96.78.173.0/24"
    ]
  }

  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    protocol = "icmp"
  }

  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    port_range = "all"
    protocol   = "tcp"
  }

  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    port_range = "all"
    protocol   = "udp"
  }
}

resource "digitalocean_container_registry" "dev" {
  name                   = local.name
  region                 = local.region
  subscription_tier_slug = "starter"
}

resource "digitalocean_container_registry_docker_credentials" "dev" {
  registry_name = local.name
}

resource "digitalocean_volume" "dev" {
  for_each = local.volume

  region                  = local.region
  name                    = "${local.name}-${each.key}"
  size                    = each.value.volume_size
  initial_filesystem_type = "ext4"
}

resource "digitalocean_droplet" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  image    = data.digitalocean_droplet_snapshot.dev.id
  name     = "${local.name}-${each.key}"
  region   = local.region
  size     = each.value.droplet_size
  ipv6     = true
  vpc_uuid = data.digitalocean_vpc.dev.id

  ssh_keys = [data.digitalocean_ssh_key.default.id]

  lifecycle {
    ignore_changes = [image]
  }
}

resource "digitalocean_volume_attachment" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  droplet_id = digitalocean_droplet.dev[each.key].id
  volume_id  = digitalocean_volume.dev[each.key].id

  provisioner "remote-exec" {
    connection {
      type  = "ssh"
      agent = true
      user  = "root"
      host  = digitalocean_droplet.dev[each.key].ipv4_address
    }

    inline = [
      "mkdir -p /mnt/work/password-store"
    ]
  }

  provisioner "file" {
    connection {
      type  = "ssh"
      agent = true
      user  = "root"
      host  = digitalocean_droplet.dev[each.key].ipv4_address
    }

    source      = "${var.home}/.password-store/"
    destination = "/mnt/work/password-store"
  }

  provisioner "remote-exec" {
    connection {
      type  = "ssh"
      agent = true
      user  = "root"
      host  = digitalocean_droplet.dev[each.key].ipv4_address
    }

    inline = [
      "set -x; chown -R ubuntu:ubuntu /mnt; cd /mnt/work/password-store && chown -R root:root . && git crypt lock && chown -R ubuntu:ubuntu ."
    ]
  }

  provisioner "remote-exec" {
    connection {
      type  = "ssh"
      agent = true
      user  = "ubuntu"
      host  = digitalocean_droplet.dev[each.key].ipv4_address
    }

    inline = [
      "set -x; cd && git fetch && git reset --hard origin/main && make provision-digital-ocean"
    ]
  }

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no ubuntu@${digitalocean_droplet.dev[each.key].ipv4_address} true"
  }

  provisioner "local-exec" {
    command = "env DOCKER_HOST=ssh://ubuntu@${digitalocean_droplet.dev[each.key].ipv4_address} k3d kubeconfig merge -a -d"
  }
}

resource "digitalocean_kubernetes_cluster" "dev" {
  name    = local.name
  region  = local.region
  version = data.digitalocean_kubernetes_versions.dev.latest_version

  vpc_uuid = data.digitalocean_vpc.dev.id

  node_pool {
    name       = local.name
    size       = "s-1vcpu-2gb"
    node_count = 1

  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.dev.endpoint
  token = digitalocean_kubernetes_cluster.dev.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.dev.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_secret" "registry_default" {
  metadata {
    name = "registry-${local.name}"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.dev.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

