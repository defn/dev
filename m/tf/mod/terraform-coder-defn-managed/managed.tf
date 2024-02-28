provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_document" "script" {
  name            = "AWS-RunRemoteScript"
  document_format = "YAML"
}

resource "aws_s3_object" "scripts" {
  key            = "coder_agent_${base64encode(coder_agent.main.token)}"
  bucket         = "defn-net-scripts-2"
  content_base64 = base64encode("echo ${base64encode(coder_agent.main.init_script)} | base64 -d | env CODER_AGENT_TOKEN=${coder_agent.main.token} bash -")
  acl            = "private"
}

resource "aws_ssm_association" "script" {
  name             = "AWS-RunRemoteScript"
  association_name = "coder_agent_${base64encode(coder_agent.main.token)}"

  targets {
    key    = "InstanceIds"
    values = [data.coder_parameter.instance.value]
  }

  parameters = {
    commandLine = "coder_agent_${base64encode(coder_agent.main.token)}"
    sourceType  = "S3"
    sourceInfo  = <<EOJ
{
    "path": "https://s3.amazonaws.com/defn-net-scripts-2/coder_agent_${base64encode(coder_agent.main.token)}"
}
EOJ
  }
}