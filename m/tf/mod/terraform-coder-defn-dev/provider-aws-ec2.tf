locals {
  aws = {
    region            = "us-west-2"
    availability_zone = "us-west-2a"
    instance_type     = "m6id.xlarge"
    root_volume_size  = data.coder_parameter.nix_volume_size.value
  }

  owners     = ["self"]
  ami_filter = ["coder-*"]
}

provider "aws" {
  region = local.aws.region
}

data "aws_ami" "ubuntu" {
  count = local.aws_ec2_count

  most_recent = true

  owners = local.owners

  filter {
    name   = "name"
    values = local.ami_filter
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_iam_role" "dev" {
  count = local.aws_ec2_count

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
  count = local.aws_ec2_count

  role       = aws_iam_role.dev[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "dev" {
  count = local.aws_ec2_count

  name = local.coder_name
  role = aws_iam_role.dev[count.index].name
}

# trunk-ignore(checkov/CKV_AWS_148)
resource "aws_default_vpc" "default" {
  count = local.aws_ec2_count
}


resource "aws_security_group" "dev" {
  count = local.aws_ec2_count

  name        = local.coder_name
  description = local.coder_name

  vpc_id = aws_default_vpc.default[count.index].id

  egress {
    description = "allow vpc ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.32.0/20"]
  }

  egress {
    description = "allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "karpenter.sh/discovery" = "k3d-dfd"
  }
}

resource "aws_instance" "dev" {
  count = local.aws_ec2_count

  ami               = data.aws_ami.ubuntu[count.index].id
  availability_zone = local.aws.availability_zone
  instance_type     = local.aws.instance_type

  ebs_optimized = true
  monitoring    = false

  iam_instance_profile   = aws_iam_instance_profile.dev[count.index].name
  vpc_security_group_ids = [aws_security_group.dev[count.index].id]

  user_data = local.user_data

  root_block_device {
    volume_size           = local.aws.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
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

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

resource "aws_ec2_instance_state" "dev" {
  count = local.aws_ec2_count

  instance_id = aws_instance.dev[count.index].id
  state       = data.coder_workspace.me.transition == "start" ? "running" : "stopped"
}