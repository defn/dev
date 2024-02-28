data "coder_parameter" "instance" {
  name         = "instance"
  display_name = "Managed Instance ID"
  description  = "Managed Instance ID"
  type         = "string"
  icon         = "/icon/memory.svg"
  mutable      = false
}

