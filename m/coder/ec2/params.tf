data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "The region to deploy the workspace in."
  default      = "us-west-2"
  mutable      = false

  option {
    name  = "US East (N. Virginia)"
    value = "us-east-1"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "US East (Ohio)"
    value = "us-east-2"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "US West (N. California)"
    value = "us-west-1"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }

  option {
    name  = "US West (Oregon)"
    value = "us-west-2"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
}

data "coder_parameter" "instance_type" {
  name         = "instance_type"
  display_name = "Instance type"
  description  = "What instance type should your workspace use?"
  default      = "t3.xlarge"
  mutable      = false

  option {
    name  = "4 vCPU, 16 GiB RAM"
    value = "t3.xlarge"
  }

  option {
    name  = "8 vCPU, 32 GiB RAM"
    value = "t3.2xlarge"
  }

  option {
    name  = "16 vCPU, 64 GiB RAM"
    value = "t3.4xlarge"
  }
}

data "coder_parameter" "root_volume_size" {
  name         = "volume_size"
  display_name = "root volume size"
  description  = "The size of the volume to create for the workspace in GB (10-100)"
  type         = "number"
  default      = "80"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  validation {
    min = 10
    max = 100
  }
}