data "coder_parameter" "droplet_image" {
  name         = "droplet_image"
  display_name = "Droplet image"
  description  = "Which Droplet image would you like to use?"
  default      = "ubuntu-22-04-x64"
  type         = "string"
  mutable      = false

  option {
    name  = "Ubuntu 22.04"
    value = "ubuntu-22-04-x64"
    icon  = "/icon/ubuntu.svg"
  }
}

data "coder_parameter" "droplet_size" {
  name         = "droplet_size"
  display_name = "Droplet size"
  description  = "Which Droplet configuration would you like to use?"
  default      = "s-2vcpu-4gb"
  type         = "string"
  icon         = "/icon/memory.svg"
  mutable      = true

  option {
    name  = "2 vCPU, 4 GB RAM"
    value = "s-2vcpu-4gb"
  }
  option {
    name  = "4 vCPU, 8 GB RAM"
    value = "s-4vcpu-8gb"
  }
}

data "coder_parameter" "home_volume_size" {
  name         = "home_volume_size"
  display_name = "Home volume size"
  description  = "How large would you like your home volume to be (in GB)?"
  type         = "number"
  default      = "20"
  mutable      = false

  validation {
    min = 10
    max = 100
  }
cccchkrfbbjcibfbfncrgvrtjrvjrdbdfktiurrdbk


data "coder_parameter" "nix_volume_size" {
  name         = "nix_volume_size"
  display_name = "nix volume size"
  description  = "How large would you like your nix volume to be (in GB)?"
  type         = "number"
  default      = "20"
  mutable      = false

  validation {
    min = 20
    max = 100
  }
}

data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "This is the region where your workspace will be created."
  icon         = "/emojis/1f30e.png"
  type         = "string"
  default      = "sfo3"
  mutable      = false

  option {
    name  = "New York 1"
    value = "nyc1"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "New York 2"
    value = "nyc2"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "New York 3"
    value = "nyc3"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "San Francisco 1"
    value = "sfo1"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "San Francisco 2"
    value = "sfo2"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "San Francisco 3"
    value = "sfo3"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
}
