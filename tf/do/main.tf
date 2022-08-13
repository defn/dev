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
  version_prefix = local.version
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
      "0.0.0.0/0",
      "::/0",
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

resource "digitalocean_volume" "dev" {
  for_each = local.volume

  region                  = local.region
  name                    = "${local.name}-${each.key}"
  size                    = each.value.volume_size
  initial_filesystem_type = "ext4"
}

resource "digitalocean_droplet" "dev" {
  for_each = local.droplet

  image    = data.digitalocean_droplet_snapshot.dev.id
  name     = each.key
  region   = local.region
  size     = each.value.droplet_size
  ipv6     = true
  vpc_uuid = data.digitalocean_vpc.dev.id

  ssh_keys = [data.digitalocean_ssh_key.default.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    archive = local.archives[each.key],
    host    = each.value.host,
    ip      = each.value.ip
  })

  lifecycle {
    ignore_changes = [image]
  }
}

resource "digitalocean_kubernetes_cluster" "dev" {
  for_each = local.want == 0 ? toset([]) : toset(["1"])

  name    = local.name
  region  = local.region
  version = data.digitalocean_kubernetes_versions.dev.latest_version

  vpc_uuid = data.digitalocean_vpc.dev.id

  node_pool {
    name       = local.name
    size       = local.size
    node_count = 1

    labels = {
      env = local.name
    }
  }
}
