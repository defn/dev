data "coder_parameter" "docker-image" {
  name         = "docker-image"
  display_name = "Docker image"
  description  = "The docker image to use for the workspace"
  default      = "codercom/code-server:latest"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace (1-8)"
  type         = "number"
  default      = "1"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  validation {
    min = 1
    max = 8
  }
}

data "coder_parameter" "cputype" {
  name         = "cputype"
  display_name = "CPU type"
  description  = "Which CPU type do you want?"
  default      = "shared"
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
  description  = "The amount of memory to allocate to the workspace in GB (up to 16GB)"
  type         = "number"
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true
  validation {
    min = data.coder_parameter.cputype.value == "performance" ? 2 : 1 # if the CPU type is performance, the minimum memory is 2GB
    max = 16
  }
}

data "coder_parameter" "volume-size" {
  name         = "volume-size"
  display_name = "Home volume size"
  description  = "The size of the volume to create for the workspace in GB (1-20)"
  type         = "number"
  default      = "1"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  validation {
    min = 1
    max = 20
  }
}

# You can see all available regions here: https://fly.io/docs/reference/regions/
data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "The region to deploy the workspace in"
  default      = "ams"
  icon         = "/emojis/1f30e.png"
  option {
    name  = "Amsterdam, Netherlands"
    value = "ams"
    icon  = "/emojis/1f1f3-1f1f1.png"
  }
  option {
    name  = "Frankfurt, Germany"
    value = "fra"
    icon  = "/emojis/1f1e9-1f1ea.png"
  }
  option {
    name  = "Paris, France"
    value = "cdg"
    icon  = "/emojis/1f1eb-1f1f7.png"
  }
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
    name  = "Hong Kong"
    value = "hkg"
    icon  = "/emojis/1f1ed-1f1f0.png"
  }
  option {
    name  = "Los Angeles, California (US)"
    value = "lax"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "London, United Kingdom"
    value = "lhr"
    icon  = "/emojis/1f1ec-1f1e7.png"
  }
  option {
    name  = "Chennai, India"
    value = "maa"
    icon  = "/emojis/1f1ee-1f1f3.png"
  }
  option {
    name  = "Tokyo, Japan"
    value = "nrt"
    icon  = "/emojis/1f1ef-1f1f5.png"
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
  option {
    name  = "Singapore"
    value = "sin"
    icon  = "/emojis/1f1f8-1f1ec.png"
  }
  option {
    name  = "Sydney, Australia"
    value = "syd"
    icon  = "/emojis/1f1e6-1f1fa.png"
  }
  option {
    name  = "Toronto, Canada"
    value = "yyz"
    icon  = "/emojis/1f1e8-1f1e6.png"
  }
}