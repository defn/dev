provider "aws" {
  region = data.coder_parameter.region.value
}

locals {
  coder_name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "dev" {
  name = local.coder_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dev" {
  role       = aws_iam_role.dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "dev" {
  name = local.coder_name
  role = aws_iam_role.dev.name
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "dev" {
  name        = local.coder_name
  description = local.coder_name

  vpc_id = aws_default_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = "${data.coder_parameter.region.value}a"
  instance_type     = data.coder_parameter.instance_type.value

  ebs_optimized = true
  monitoring    = true

  iam_instance_profile   = aws_iam_instance_profile.dev.name
  vpc_security_group_ids = [aws_security_group.dev.id]

  user_data = data.coder_workspace.me.transition == "start" ? local.user_data_start : local.user_data_end

  root_block_device {
    volume_size = 50
    encrypted   = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    instance_metadata_tags      = "enabled"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name              = local.coder_name
    Coder_Provisioned = "true"
  }
}