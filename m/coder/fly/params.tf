data "coder_parameter" "docker-image" {
  name         = "docker-image"
  display_name = "Docker image"
  description  = "The docker image to use for the workspace"
  default      = "quay.io/defn/dev:latest"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace (4-8)"
  type         = "number"
  default      = "4"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  validation {
    min = 4
    max = 16
  }
}

data "coder_parameter" "cputype" {
  name         = "cputype"
  display_name = "CPU type"
  description  = "Which CPU type do you want?"
  default      = "performance"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-1.svg"
  mutable      = true
  option {
    name  = "Shared"
    value = "shared"
  }
  option {
    name  = "Performance"
    value = "performance"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory to allocate to the workspace in GB (8-16)"
  type         = "number"
  default      = "8"
  icon         = "/icon/memory.svg"
  mutable      = true
  validation {
    min = 8
    max = 64
  }
}

data "coder_parameter" "volume-size" {
  name         = "volume-size"
  display_name = "Home volume size"
  description  = "The size of the volume to create for the workspace in GB (10-100)"
  type         = "number"
  default      = "40"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  validation {
    min = 10
    max = 100
  }
}

data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "The region to deploy the workspace in"
  default      = "lax"
  icon         = "/emojis/1f30e.png"

  option {
    name  = "Denver, Colorado (US)"
    value = "den"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "Dallas, Texas (US)"
    value = "dfw"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "Los Angeles, California (US)"
    value = "lax"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "Chicago, Illinois (US)"
    value = "ord"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "Seattle, Washington (US)"
    value = "sea"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
}