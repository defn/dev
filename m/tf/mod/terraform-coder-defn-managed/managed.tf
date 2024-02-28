provider "aws" {
  region = "us-west-2"
}

data "aws_ssm_document" "script" {
  name            = "AWS-RunRemoteScript"
  document_format = "YAML"
}

resource "aws_ssm_association" "script" {
  name             = "AWS-RunShellScript"
  association_name = "coder_agent_${base64encode(coder_agent.main.token)}"

  targets {
    key    = "InstanceIds"
    values = [data.coder_parameter.instance.value]
  }

  parameters = {
    commands = "( (echo cd ~ubuntu; echo export STARSHIP_NO=1; echo source .bash_profile; echo ${base64encode(coder_agent.main.init_script)} | base64 -d; echo) > /tmp/meh.sh; exec setsid sudo -H -u ubuntu env CODER_AGENT_TOKEN=${coder_agent.main.token} bash /tmp/meh.sh &) &"
  }
}
