locals {
  do = {
    region = "sfo3"
    image = "ubuntu-22-04-x64"
    droplet_size = "s-4vcpu-8gb"
    nix_size = data.coder_parameter.nix_volume_size.value
  }
}

resource "digitalocean_volume" "nix_volume" {
  count = local.do_count

  region                   = local.do.region
  name                     = "coder-${data.coder_workspace.me.id}-nix"
  size                     = local.do.nix_size
  initial_filesystem_type  = "ext4"
  initial_filesystem_label = "coder-nix"

  lifecycle {
    ignore_changes = all
  }
}

# trunk-ignore(checkov/CKV_DIO_2)
resource "digitalocean_droplet" "workspace" {
  count = local.do_count * data.coder_workspace.me.start_count

  name = local.coder_name

  region = local.do.region

  image = local.do.image
  size  = local.do.droplet_size

  volume_ids = [
    digitalocean_volume.nix_volume[count.index].id
  ]

  user_data = templatefile("${path.module}/do-cloud-config.yaml.tftpl", {
    nix_volume_label  = digitalocean_volume.nix_volume[count.index].initial_filesystem_label
    init_script       = base64encode(coder_agent.main.init_script)
    coder_agent_token = coder_agent.main.token
  })
}