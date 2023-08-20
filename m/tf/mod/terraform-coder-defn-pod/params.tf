locals {
  pod_count = data.coder_parameter.provider.value == "pod" ? 1 : 0
}

data "coder_parameter" "provider" {
  name         = "provider"
  display_name = "Provider"
  description  = "The service provider to deploy the workspace in"
  default      = "pod"
  icon         = "/emojis/1f30e.png"
  mutable      = true

  option {
    name  = "Kubernetes Pod"
    value = "pod"
  }
}

data "coder_parameter" "docker_image" {
  name         = "docker_image"
  display_name = "Docker image"
  description  = "The docker image to use for the workspace"
  default      = "quay.io/defn/dev:latest"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = true
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
  default      = "60"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  validation {
    min = 40
    max = 100
  }
}