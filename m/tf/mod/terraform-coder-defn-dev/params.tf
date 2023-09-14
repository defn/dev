locals {
  aws_ec2_count = data.coder_parameter.provider.value == "aws-ec2" ? 1 : 0
}

data "coder_parameter" "provider" {
  name         = "provider"
  display_name = "Provider"
  description  = "The service provider to deploy the workspace in"
  default      = "aws-ec2"
  icon         = "/emojis/1f30e.png"
  mutable      = true

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
  default      = "m6id.xlarge"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"
  mutable      = true
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

data "coder_parameter" "nix_volume_size" {
  name         = "nix_volume_size"
  display_name = "nix volume size"
  description  = "The size of the nix volume to create for the workspace in GB"
  type         = "number"
  default      = "200"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  mutable      = true
  validation {
    min = 40
    max = 200
  }
}
