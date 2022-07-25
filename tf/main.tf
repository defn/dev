provider "digitalocean" {}

data "digitalocean_ssh_key" "default" {
  name = "yubikey"
}

data "digitalocean_vpc" "region" {
  name = "default-${local.region}"
}

data "digitalocean_droplet_snapshot" "dev" {
  name_regex  = "^defn-dev"
  region      = local.region
  most_recent = true
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
      "96.78.173.0/24",
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

  inbound_rule {
    port_range = "all"
    protocol   = "tcp"
    source_addresses = [
      data.digitalocean_vpc.region.ip_range
    ]
  }

  inbound_rule {
    port_range = "all"
    protocol   = "udp"
    source_addresses = [
      data.digitalocean_vpc.region.ip_range
    ]
  }

  inbound_rule {
    protocol = "icmp"
    source_addresses = [
      data.digitalocean_vpc.region.ip_range
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

resource "digitalocean_volume" "dev" {
  for_each = local.volume

  region                  = local.region
  name                    = "${local.name}-${each.key}-01"
  size                    = each.value.volume_size
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume_attachment" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  droplet_id = digitalocean_droplet.dev[each.key].id
  volume_id  = digitalocean_volume.dev[each.key].id

  provisioner "remote-exec" {
    connection {
      type  = "ssh"
      agent = true
      user  = "app"
      host  = digitalocean_droplet.dev[each.key].ipv4_address
    }

    inline = [
      "set -x; cd && git fetch && git reset --hard origin/main"
    ]
  }

  provisioner "local-exec" {
    command = "ssh -o IdentityFile=/dev/null -o StrictHostKeyChecking=no root@${digitalocean_droplet.dev[each.key].ipv4_address} reboot || true"
  }
}

resource "digitalocean_droplet" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  image              = data.digitalocean_droplet_snapshot.dev.id
  name               = "${each.key}.${local.name}"
  region             = local.region
  size               = each.value.droplet_size
  ipv6               = true
  private_networking = true

  ssh_keys = [data.digitalocean_ssh_key.default.id]

  lifecycle {
    ignore_changes = [image]
  }
}
