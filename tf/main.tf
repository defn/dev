terraform {
  cloud {
    organization = "defn"

    workspaces {
      name = "dev"
    }
  }
}

provider "digitalocean" {}

data "digitalocean_ssh_key" "default" {
  name = "yubikey"
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

resource "digitalocean_volume" "dev" {
  for_each = local.volume

  region                  = local.region
  name                    = "${local.name}-${each.key}"
  size                    = each.value.volume_size
  initial_filesystem_type = "ext4"
}

resource "digitalocean_droplet" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  image  = data.digitalocean_droplet_snapshot.dev.id
  name   = "${local.name}-${each.key}"
  region = local.region
  size   = each.value.droplet_size
  ipv6   = true

  ssh_keys = [data.digitalocean_ssh_key.default.id]

  lifecycle {
    ignore_changes = [image]
  }
}

resource "digitalocean_volume_attachment" "dev" {
  for_each = local.want == 0 ? {} : local.droplet

  droplet_id = digitalocean_droplet.dev[each.key].id
  volume_id  = digitalocean_volume.dev[each.key].id

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
      "set -x; chown -R ubuntu:ubuntu /mnt"
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
