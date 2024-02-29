locals {
  slug = base64encode(coder_agent.main.token)
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ssm_document" "script" {
  name            = "AWS-RunRemoteScript"
  document_format = "YAML"
}

resource "aws_ssm_association" "script" {
  name             = "AWS-RunShellScript"
  association_name = "coder_agent_${local.slug}"

  targets {
    key    = "InstanceIds"
    values = [data.coder_parameter.instance.value]
  }

  parameters = {
    commands = "( (echo sudo pkill -f -9 coder.agent '||' true; echo sudo pkill -f -9 coder-server '||' true; echo sudo pkill -9 -f ssm-document-worker '||' true; echo sudo pkill -9 -f awsrunShellScript '||' true; echo cd ~ubuntu; echo export STARSHIP_NO=1 CODER_AGENT_TOKEN=${coder_agent.main.token}; echo source .bash_profile; echo ${base64encode(coder_agent.main.init_script)} | base64 -d; echo) > /tmp/meh_${local.slug}.sh; exec setsid sudo -H -u ubuntu bash -x /tmp/meh_${local.slug}.sh >>/tmp/startup.log 2>&1 &) &"
  }
}
