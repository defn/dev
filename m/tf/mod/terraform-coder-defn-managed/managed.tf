resource "aws_ssm_document" "agent" {
  name          = "coder_agent"
  document_type = "Command"

  content = <<-DOC
  {
    "schemaVersion": "1.2",
    "description": "Coder Agent",
    "parameters": {
    },
    "runtimeConfig: {
      "aws:runShellScript": {
        "properties": [{
            "id": "0.aws:runShellScript",
            "runCommand": "echo ${base64encode(coder_agent.main.init_script)} | base64 -d | env CODER_AGENT_TOKEN=${coder_agent.main.token} bash -"
        }]
      }
    }
  }
  DOC
}

resource "aws_ssm_association" "agent" {
  name             = "agent"
  document_version = aws_ssm_document.agent.default_version
  targets {
    key    = "InstanceIds"
    values = [data.coder_parameter.instance.value]
  }
}
