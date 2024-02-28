provider "aws" {
  region = "us-west-2"
}

data "aws_ssm_document" "script" {
  name            = "AWS-RunRemoteScript"
  document_format = "YAML"
}

resource "aws_s3_object" "scripts" {
  key            = "coder_agent_${base64encode(coder_agent.main.token)}"
  bucket         = "defn-net-scripts"
  content_base64 = base64encode("echo ${base64encode(coder_agent.main.init_script)} | base64 -d | env CODER_AGENT_TOKEN=${coder_agent.main.token} bash -")
  acl            = "private"
}

resource "aws_ssm_association" "script" {
  name             = "AWS-RunShellScript"
  association_name = "coder_agent_${base64encode(coder_agent.main.token)}"

  targets {
    key    = "InstanceIds"
    values = [data.coder_parameter.instance.value]
  }

  parameters = {
    commands = "echo ${base64encode(coder_agent.main.init_script)} | base64 -d | env CODER_AGENT_TOKEN=${coder_agent.main.token} bash -"
  }

  depends_on = [
    aws_s3_object.scripts
  ]
}