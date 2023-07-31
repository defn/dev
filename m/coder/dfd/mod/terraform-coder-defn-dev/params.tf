locals {
  fly_count    = data.coder_parameter.provider.value == "fly" ? 1 : 0
  ec2_count    = data.coder_parameter.provider.value == "ec2" ? 1 : 0
  do_count     = data.coder_parameter.provider.value == "do" ? 1 : 0
  docker_count = data.coder_parameter.provider.value == "docker" ? 1 : 0
}

data "coder_parameter" "provider" {
  name         = "provider"
  display_name = "Provider"
  description  = "The service provider to deploy the workspace in"
  default      = "fly"
  icon         = "/emojis/1f30e.png"

  option {
    name  = "Fly"
    value = "fly"
  }

  option {
    name  = "Amazon Web Services"
    value = "ec2"
  }

  option {
    name  = "Digital Ocean"
    value = "do"
  }

  option {
    name  = "Docker"
    value = "docker"
  }
}

data "coder_parameter" "docker_image" {
  name         = "docker_image"
  display_name = "Docker image"
  description  = "The docker image to use for the workspace"
  default      = "quay.io/defn/dev:latest"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace"
  type         = "number"
  default      = "4"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  validation {
    min = 4
    max = 16
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory to allocate to the workspace in GB"
  type         = "number"
  default      = "8"
  icon         = "/icon/memory.svg"
  mutable      = true
  validation {
    min = 8
    max = 64
  }
}

data "coder_parameter" "nix_volume_size" {
  name         = "nix_volume_size"
  display_name = "nix volume size"
  description  = "The size of the nix volume to create for the workspace in GB"
  type         = "number"
  default      = "50"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  validation {
    min = 40
    max = 100
  }
}