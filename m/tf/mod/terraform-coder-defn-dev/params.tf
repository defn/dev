variable "tsauthkey" {}

locals {
  aws_ec2_count = data.coder_parameter.provider.value == "aws-ec2" ? 1 : 0

  username = "ubuntu"

  coder_name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
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

  default = "aws-ec2"

  option {
    name  = "Amazon Web Services VM"
    value = "aws-ec2"
  }
}

data "coder_parameter" "instance_type" {
  name         = "instance_type"
  display_name = "CPU"
  description  = "The number of CPUs to allocate to the workspace"
  type         = "string"
  default      = "m6id.large"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
  option {
    name  = "2"
    value = "m6id.large"
  }
  option {
    name  = "4"
    value = "m6id.xlarge"
  }
  option {
    name  = "8"
    value = "m6id.2xlarge"
  }
  option {
    name  = "16"
    value = "m6id.4xlarge"
  }
}

