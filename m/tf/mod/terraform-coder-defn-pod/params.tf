locals {
  pod_count = data.coder_parameter.provider.value == "pod" ? 1 : 0

}

data "coder_parameter" "nix_volume_size" {
  name         = "nix_volume_size"
  display_name = "nix volume size"
  description  = "The size of the nix volume to create for the workspace in GB"
  type         = "number"
  default      = "100"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  validation {
    min = 100
    max = 200
  }
}

data "coder_parameter" "workdir" {
  name         = "workdir"
  display_name = "Working directory"
  description  = "Working directory"
  type         = "string"
  default      = "/home/${local.username}/m"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
}

data "coder_parameter" "source_rev" {
  name         = "source_rev"
  display_name = "Source revision"
  description  = "Source revision"
  type         = "string"
  default      = "main"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
}

data "coder_parameter" "prefix" {
  name         = "prefix"
  display_name = "Workspace name prefix"
  description  = "Workspace name prefix"
  type         = "string"
  default      = "coder"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = false
}

data "coder_parameter" "provider" {
  name         = "provider"
  display_name = "Provider"
  description  = "The service provider to deploy the workspace in"
  icon         = "/emojis/1f30e.png"
  mutable      = true

  default = "pod"

  option {
    name  = "Kubernetes Pod"
    value = "pod"
  }
}

data "coder_parameter" "docker_image" {
  name         = "docker_image"
  display_name = "Docker image"
  description  = "The docker image to use for the workspace"
  default      = "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-buildkite-latest"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = true
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace"
  type         = "number"
  default      = "1"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  validation {
    min = 1
    max = 16
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory to allocate to the workspace in GB"
  type         = "number"
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
  validation {
    min = 1
    max = 64
  }
}

data "coder_parameter" "vcluster" {
  name         = "vcluster"
  display_name = "VCluster"
  description  = "Launch a vcluster"
  type         = "number"
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
  validation {
    min = 0
    max = 1
  }
}

