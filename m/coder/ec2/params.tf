data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "The region to deploy the workspace in."
  default      = "us-west-1"
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