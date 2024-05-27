terraform {
  required_providers {
    aws = {
      version = "5.51.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/global/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-org"
  assume_role {
    role_arn = "arn:aws:iam::730917619329:role/chamber-ops-terraform"
  }
}

module "s3-chamber-org" {
  acl = "private"
  attributes = [
    "chamber-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-1"
  assume_role {
    role_arn = "arn:aws:iam::741346472057:role/chamber-ops-terraform"
  }
}

module "s3-chamber-1" {
  acl = "private"
  attributes = [
    "chamber-1",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-1
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-2"
  assume_role {
    role_arn = "arn:aws:iam::447993872368:role/chamber-ops-terraform"
  }
}

module "s3-chamber-2" {
  acl = "private"
  attributes = [
    "chamber-2",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-2
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-3"
  assume_role {
    role_arn = "arn:aws:iam::463050069968:role/chamber-ops-terraform"
  }
}

module "s3-chamber-3" {
  acl = "private"
  attributes = [
    "chamber-3",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-3
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-4"
  assume_role {
    role_arn = "arn:aws:iam::368890376620:role/chamber-ops-terraform"
  }
}

module "s3-chamber-4" {
  acl = "private"
  attributes = [
    "chamber-4",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-4
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-5"
  assume_role {
    role_arn = "arn:aws:iam::200733412967:role/chamber-ops-terraform"
  }
}

module "s3-chamber-5" {
  acl = "private"
  attributes = [
    "chamber-5",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-5
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-6"
  assume_role {
    role_arn = "arn:aws:iam::493089153027:role/chamber-ops-terraform"
  }
}

module "s3-chamber-6" {
  acl = "private"
  attributes = [
    "chamber-6",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-6
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-7"
  assume_role {
    role_arn = "arn:aws:iam::837425503386:role/chamber-ops-terraform"
  }
}

module "s3-chamber-7" {
  acl = "private"
  attributes = [
    "chamber-7",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-7
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-8"
  assume_role {
    role_arn = "arn:aws:iam::773314335856:role/chamber-ops-terraform"
  }
}

module "s3-chamber-8" {
  acl = "private"
  attributes = [
    "chamber-8",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-8
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-9"
  assume_role {
    role_arn = "arn:aws:iam::950940975070:role/chamber-ops-terraform"
  }
}

module "s3-chamber-9" {
  acl = "private"
  attributes = [
    "chamber-9",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-9
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-a"
  assume_role {
    role_arn = "arn:aws:iam::503577294851:role/chamber-ops-terraform"
  }
}

module "s3-chamber-a" {
  acl = "private"
  attributes = [
    "chamber-a",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-a
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-b"
  assume_role {
    role_arn = "arn:aws:iam::310940910494:role/chamber-ops-terraform"
  }
}

module "s3-chamber-b" {
  acl = "private"
  attributes = [
    "chamber-b",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-b
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-c"
  assume_role {
    role_arn = "arn:aws:iam::047633732615:role/chamber-ops-terraform"
  }
}

module "s3-chamber-c" {
  acl = "private"
  attributes = [
    "chamber-c",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-c
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-d"
  assume_role {
    role_arn = "arn:aws:iam::699441347021:role/chamber-ops-terraform"
  }
}

module "s3-chamber-d" {
  acl = "private"
  attributes = [
    "chamber-d",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-d
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-e"
  assume_role {
    role_arn = "arn:aws:iam::171831323337:role/chamber-ops-terraform"
  }
}

module "s3-chamber-e" {
  acl = "private"
  attributes = [
    "chamber-e",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-e
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-f"
  assume_role {
    role_arn = "arn:aws:iam::842022523232:role/chamber-ops-terraform"
  }
}

module "s3-chamber-f" {
  acl = "private"
  attributes = [
    "chamber-f",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-f
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-g"
  assume_role {
    role_arn = "arn:aws:iam::023867963778:role/chamber-ops-terraform"
  }
}

module "s3-chamber-g" {
  acl = "private"
  attributes = [
    "chamber-g",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-g
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-h"
  assume_role {
    role_arn = "arn:aws:iam::371020107387:role/chamber-ops-terraform"
  }
}

module "s3-chamber-h" {
  acl = "private"
  attributes = [
    "chamber-h",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-h
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-i"
  assume_role {
    role_arn = "arn:aws:iam::290132238209:role/chamber-ops-terraform"
  }
}

module "s3-chamber-i" {
  acl = "private"
  attributes = [
    "chamber-i",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-i
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-j"
  assume_role {
    role_arn = "arn:aws:iam::738433022197:role/chamber-ops-terraform"
  }
}

module "s3-chamber-j" {
  acl = "private"
  attributes = [
    "chamber-j",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-j
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-l"
  assume_role {
    role_arn = "arn:aws:iam::991300382347:role/chamber-ops-terraform"
  }
}

module "s3-chamber-l" {
  acl = "private"
  attributes = [
    "chamber-l",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-l
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-m"
  assume_role {
    role_arn = "arn:aws:iam::684895750259:role/chamber-ops-terraform"
  }
}

module "s3-chamber-m" {
  acl = "private"
  attributes = [
    "chamber-m",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-m
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-n"
  assume_role {
    role_arn = "arn:aws:iam::705881812506:role/chamber-ops-terraform"
  }
}

module "s3-chamber-n" {
  acl = "private"
  attributes = [
    "chamber-n",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-n
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-o"
  assume_role {
    role_arn = "arn:aws:iam::307136835824:role/chamber-ops-terraform"
  }
}

module "s3-chamber-o" {
  acl = "private"
  attributes = [
    "chamber-o",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-o
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-p"
  assume_role {
    role_arn = "arn:aws:iam::706168331526:role/chamber-ops-terraform"
  }
}

module "s3-chamber-p" {
  acl = "private"
  attributes = [
    "chamber-p",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-p
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-q"
  assume_role {
    role_arn = "arn:aws:iam::217047480856:role/chamber-ops-terraform"
  }
}

module "s3-chamber-q" {
  acl = "private"
  attributes = [
    "chamber-q",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-q
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-r"
  assume_role {
    role_arn = "arn:aws:iam::416221726155:role/chamber-ops-terraform"
  }
}

module "s3-chamber-r" {
  acl = "private"
  attributes = [
    "chamber-r",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-r
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-s"
  assume_role {
    role_arn = "arn:aws:iam::840650118369:role/chamber-ops-terraform"
  }
}

module "s3-chamber-s" {
  acl = "private"
  attributes = [
    "chamber-s",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-s
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-t"
  assume_role {
    role_arn = "arn:aws:iam::490895200523:role/chamber-ops-terraform"
  }
}

module "s3-chamber-t" {
  acl = "private"
  attributes = [
    "chamber-t",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-t
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-u"
  assume_role {
    role_arn = "arn:aws:iam::467995590869:role/chamber-ops-terraform"
  }
}

module "s3-chamber-u" {
  acl = "private"
  attributes = [
    "chamber-u",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-u
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-v"
  assume_role {
    role_arn = "arn:aws:iam::979368042862:role/chamber-ops-terraform"
  }
}

module "s3-chamber-v" {
  acl = "private"
  attributes = [
    "chamber-v",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-v
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-w"
  assume_role {
    role_arn = "arn:aws:iam::313387692116:role/chamber-ops-terraform"
  }
}

module "s3-chamber-w" {
  acl = "private"
  attributes = [
    "chamber-w",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-w
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-x"
  assume_role {
    role_arn = "arn:aws:iam::834936839208:role/chamber-ops-terraform"
  }
}

module "s3-chamber-x" {
  acl = "private"
  attributes = [
    "chamber-x",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-x
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-y"
  assume_role {
    role_arn = "arn:aws:iam::153556747817:role/chamber-ops-terraform"
  }
}

module "s3-chamber-y" {
  acl = "private"
  attributes = [
    "chamber-y",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-y
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "chamber-z"
  assume_role {
    role_arn = "arn:aws:iam::037804009879:role/chamber-ops-terraform"
  }
}

module "s3-chamber-z" {
  acl = "private"
  attributes = [
    "chamber-z",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-z
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "circus-org"
  assume_role {
    role_arn = "arn:aws:iam::036139182623:role/circus-ops-terraform"
  }
}

module "s3-circus-org" {
  acl = "private"
  attributes = [
    "circus-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "circus-net"
  assume_role {
    role_arn = "arn:aws:iam::002516226222:role/circus-ops-terraform"
  }
}

module "s3-circus-net" {
  acl = "private"
  attributes = [
    "circus-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "circus-log"
  assume_role {
    role_arn = "arn:aws:iam::707476523482:role/circus-ops-terraform"
  }
}

module "s3-circus-log" {
  acl = "private"
  attributes = [
    "circus-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "circus-lib"
  assume_role {
    role_arn = "arn:aws:iam::497790518354:role/circus-ops-terraform"
  }
}

module "s3-circus-lib" {
  acl = "private"
  attributes = [
    "circus-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "circus-ops"
  assume_role {
    role_arn = "arn:aws:iam::415618116579:role/circus-ops-terraform"
  }
}

module "s3-circus-ops" {
  acl = "private"
  attributes = [
    "circus-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-org"
  assume_role {
    role_arn = "arn:aws:iam::138291560003:role/coil-ops-terraform"
  }
}

module "s3-coil-org" {
  acl = "private"
  attributes = [
    "coil-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-net"
  assume_role {
    role_arn = "arn:aws:iam::278790191486:role/coil-ops-terraform"
  }
}

module "s3-coil-net" {
  acl = "private"
  attributes = [
    "coil-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-lib"
  assume_role {
    role_arn = "arn:aws:iam::160764896647:role/coil-ops-terraform"
  }
}

module "s3-coil-lib" {
  acl = "private"
  attributes = [
    "coil-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-hub"
  assume_role {
    role_arn = "arn:aws:iam::453991412409:role/coil-ops-terraform"
  }
}

module "s3-coil-hub" {
  acl = "private"
  attributes = [
    "coil-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "curl-org"
  assume_role {
    role_arn = "arn:aws:iam::424535767618:role/curl-ops-terraform"
  }
}

module "s3-curl-org" {
  acl = "private"
  attributes = [
    "curl-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "curl-net"
  assume_role {
    role_arn = "arn:aws:iam::101142583332:role/curl-ops-terraform"
  }
}

module "s3-curl-net" {
  acl = "private"
  attributes = [
    "curl-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "curl-lib"
  assume_role {
    role_arn = "arn:aws:iam::298406631539:role/curl-ops-terraform"
  }
}

module "s3-curl-lib" {
  acl = "private"
  attributes = [
    "curl-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "curl-hub"
  assume_role {
    role_arn = "arn:aws:iam::804430872255:role/curl-ops-terraform"
  }
}

module "s3-curl-hub" {
  acl = "private"
  attributes = [
    "curl-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "defn-org"
  assume_role {
    role_arn = "arn:aws:iam::510430971399:role/defn-ops-terraform"
  }
}

module "s3-defn-org" {
  acl = "private"
  attributes = [
    "defn-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.defn-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-org"
  assume_role {
    role_arn = "arn:aws:iam::328216504962:role/fogg-ops-terraform"
  }
}

module "s3-fogg-org" {
  acl = "private"
  attributes = [
    "fogg-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-net"
  assume_role {
    role_arn = "arn:aws:iam::060659916753:role/fogg-ops-terraform"
  }
}

module "s3-fogg-net" {
  acl = "private"
  attributes = [
    "fogg-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-log"
  assume_role {
    role_arn = "arn:aws:iam::844609041254:role/fogg-ops-terraform"
  }
}

module "s3-fogg-log" {
  acl = "private"
  attributes = [
    "fogg-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-lib"
  assume_role {
    role_arn = "arn:aws:iam::624713464251:role/fogg-ops-terraform"
  }
}

module "s3-fogg-lib" {
  acl = "private"
  attributes = [
    "fogg-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-ops"
  assume_role {
    role_arn = "arn:aws:iam::318746665903:role/fogg-ops-terraform"
  }
}

module "s3-fogg-ops" {
  acl = "private"
  attributes = [
    "fogg-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-ci"
  assume_role {
    role_arn = "arn:aws:iam::812459563189:role/fogg-ops-terraform"
  }
}

module "s3-fogg-ci" {
  acl = "private"
  attributes = [
    "fogg-ci",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-ci
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-hub"
  assume_role {
    role_arn = "arn:aws:iam::337248635000:role/fogg-ops-terraform"
  }
}

module "s3-fogg-hub" {
  acl = "private"
  attributes = [
    "fogg-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-cde"
  assume_role {
    role_arn = "arn:aws:iam::565963418226:role/fogg-ops-terraform"
  }
}

module "s3-fogg-cde" {
  acl = "private"
  attributes = [
    "fogg-cde",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-cde
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-dev"
  assume_role {
    role_arn = "arn:aws:iam::442766271046:role/fogg-ops-terraform"
  }
}

module "s3-fogg-dev" {
  acl = "private"
  attributes = [
    "fogg-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "fogg-pub"
  assume_role {
    role_arn = "arn:aws:iam::372333168887:role/fogg-ops-terraform"
  }
}

module "s3-fogg-pub" {
  acl = "private"
  attributes = [
    "fogg-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "gyre-org"
  assume_role {
    role_arn = "arn:aws:iam::065163301604:role/gyre-ops-terraform"
  }
}

module "s3-gyre-org" {
  acl = "private"
  attributes = [
    "gyre-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.gyre-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "gyre-ops"
  assume_role {
    role_arn = "arn:aws:iam::319951235442:role/gyre-ops-terraform"
  }
}

module "s3-gyre-ops" {
  acl = "private"
  attributes = [
    "gyre-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.gyre-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-org"
  assume_role {
    role_arn = "arn:aws:iam::816178966829:role/helix-ops-terraform"
  }
}

module "s3-helix-org" {
  acl = "private"
  attributes = [
    "helix-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-net"
  assume_role {
    role_arn = "arn:aws:iam::504722108514:role/helix-ops-terraform"
  }
}

module "s3-helix-net" {
  acl = "private"
  attributes = [
    "helix-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-log"
  assume_role {
    role_arn = "arn:aws:iam::664427926343:role/helix-ops-terraform"
  }
}

module "s3-helix-log" {
  acl = "private"
  attributes = [
    "helix-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-lib"
  assume_role {
    role_arn = "arn:aws:iam::377857698578:role/helix-ops-terraform"
  }
}

module "s3-helix-lib" {
  acl = "private"
  attributes = [
    "helix-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-ops"
  assume_role {
    role_arn = "arn:aws:iam::368812692254:role/helix-ops-terraform"
  }
}

module "s3-helix-ops" {
  acl = "private"
  attributes = [
    "helix-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-ci"
  assume_role {
    role_arn = "arn:aws:iam::018520313738:role/helix-ops-terraform"
  }
}

module "s3-helix-ci" {
  acl = "private"
  attributes = [
    "helix-ci",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-ci
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-hub"
  assume_role {
    role_arn = "arn:aws:iam::436043820387:role/helix-ops-terraform"
  }
}

module "s3-helix-hub" {
  acl = "private"
  attributes = [
    "helix-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-cde"
  assume_role {
    role_arn = "arn:aws:iam::724643698007:role/helix-ops-terraform"
  }
}

module "s3-helix-cde" {
  acl = "private"
  attributes = [
    "helix-cde",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-cde
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-dev"
  assume_role {
    role_arn = "arn:aws:iam::843784871878:role/helix-ops-terraform"
  }
}

module "s3-helix-dev" {
  acl = "private"
  attributes = [
    "helix-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "helix-pub"
  assume_role {
    role_arn = "arn:aws:iam::536806623881:role/helix-ops-terraform"
  }
}

module "s3-helix-pub" {
  acl = "private"
  attributes = [
    "helix-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-org"
  assume_role {
    role_arn = "arn:aws:iam::548373030883:role/imma-ops-terraform"
  }
}

module "s3-imma-org" {
  acl = "private"
  attributes = [
    "imma-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-net"
  assume_role {
    role_arn = "arn:aws:iam::246197522468:role/imma-ops-terraform"
  }
}

module "s3-imma-net" {
  acl = "private"
  attributes = [
    "imma-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-log"
  assume_role {
    role_arn = "arn:aws:iam::289716781198:role/imma-ops-terraform"
  }
}

module "s3-imma-log" {
  acl = "private"
  attributes = [
    "imma-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-lib"
  assume_role {
    role_arn = "arn:aws:iam::516851121506:role/imma-ops-terraform"
  }
}

module "s3-imma-lib" {
  acl = "private"
  attributes = [
    "imma-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-dev"
  assume_role {
    role_arn = "arn:aws:iam::445584037541:role/imma-ops-terraform"
  }
}

module "s3-imma-dev" {
  acl = "private"
  attributes = [
    "imma-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "imma-pub"
  assume_role {
    role_arn = "arn:aws:iam::766142996227:role/imma-ops-terraform"
  }
}

module "s3-imma-pub" {
  acl = "private"
  attributes = [
    "imma-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "jianghu-org"
  assume_role {
    role_arn = "arn:aws:iam::657613322961:role/jianghu-ops-terraform"
  }
}

module "s3-jianghu-org" {
  acl = "private"
  attributes = [
    "jianghu-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "jianghu-net"
  assume_role {
    role_arn = "arn:aws:iam::025636091251:role/jianghu-ops-terraform"
  }
}

module "s3-jianghu-net" {
  acl = "private"
  attributes = [
    "jianghu-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "jianghu-log"
  assume_role {
    role_arn = "arn:aws:iam::298431841138:role/jianghu-ops-terraform"
  }
}

module "s3-jianghu-log" {
  acl = "private"
  attributes = [
    "jianghu-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-org"
  assume_role {
    role_arn = "arn:aws:iam::232091571197:role/spiral-ops-terraform"
  }
}

module "s3-spiral-org" {
  acl = "private"
  attributes = [
    "spiral-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-net"
  assume_role {
    role_arn = "arn:aws:iam::057533398557:role/spiral-ops-terraform"
  }
}

module "s3-spiral-net" {
  acl = "private"
  attributes = [
    "spiral-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-log"
  assume_role {
    role_arn = "arn:aws:iam::442333715734:role/spiral-ops-terraform"
  }
}

module "s3-spiral-log" {
  acl = "private"
  attributes = [
    "spiral-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-lib"
  assume_role {
    role_arn = "arn:aws:iam::073874947996:role/spiral-ops-terraform"
  }
}

module "s3-spiral-lib" {
  acl = "private"
  attributes = [
    "spiral-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-ops"
  assume_role {
    role_arn = "arn:aws:iam::601164058091:role/spiral-ops-terraform"
  }
}

module "s3-spiral-ops" {
  acl = "private"
  attributes = [
    "spiral-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-ci"
  assume_role {
    role_arn = "arn:aws:iam::371657257885:role/spiral-ops-terraform"
  }
}

module "s3-spiral-ci" {
  acl = "private"
  attributes = [
    "spiral-ci",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-ci
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-hub"
  assume_role {
    role_arn = "arn:aws:iam::216704421225:role/spiral-ops-terraform"
  }
}

module "s3-spiral-hub" {
  acl = "private"
  attributes = [
    "spiral-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-cde"
  assume_role {
    role_arn = "arn:aws:iam::398258703387:role/spiral-ops-terraform"
  }
}

module "s3-spiral-cde" {
  acl = "private"
  attributes = [
    "spiral-cde",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-cde
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-dev"
  assume_role {
    role_arn = "arn:aws:iam::308726031860:role/spiral-ops-terraform"
  }
}

module "s3-spiral-dev" {
  acl = "private"
  attributes = [
    "spiral-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "spiral-pub"
  assume_role {
    role_arn = "arn:aws:iam::130046154300:role/spiral-ops-terraform"
  }
}

module "s3-spiral-pub" {
  acl = "private"
  attributes = [
    "spiral-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-org"
  assume_role {
    role_arn = "arn:aws:iam::475528707847:role/vault-ops-terraform"
  }
}

module "s3-vault-org" {
  acl = "private"
  attributes = [
    "vault-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-net"
  assume_role {
    role_arn = "arn:aws:iam::915207860232:role/vault-ops-terraform"
  }
}

module "s3-vault-net" {
  acl = "private"
  attributes = [
    "vault-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-log"
  assume_role {
    role_arn = "arn:aws:iam::749185891195:role/vault-ops-terraform"
  }
}

module "s3-vault-log" {
  acl = "private"
  attributes = [
    "vault-log",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-lib"
  assume_role {
    role_arn = "arn:aws:iam::066356637485:role/vault-ops-terraform"
  }
}

module "s3-vault-lib" {
  acl = "private"
  attributes = [
    "vault-lib",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-ops"
  assume_role {
    role_arn = "arn:aws:iam::188066400611:role/vault-ops-terraform"
  }
}

module "s3-vault-ops" {
  acl = "private"
  attributes = [
    "vault-ops",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-ci"
  assume_role {
    role_arn = "arn:aws:iam::313228123503:role/vault-ops-terraform"
  }
}

module "s3-vault-ci" {
  acl = "private"
  attributes = [
    "vault-ci",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-ci
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-hub"
  assume_role {
    role_arn = "arn:aws:iam::539099112425:role/vault-ops-terraform"
  }
}

module "s3-vault-hub" {
  acl = "private"
  attributes = [
    "vault-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-cde"
  assume_role {
    role_arn = "arn:aws:iam::040769490632:role/vault-ops-terraform"
  }
}

module "s3-vault-cde" {
  acl = "private"
  attributes = [
    "vault-cde",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-cde
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-dev"
  assume_role {
    role_arn = "arn:aws:iam::497393606242:role/vault-ops-terraform"
  }
}

module "s3-vault-dev" {
  acl = "private"
  attributes = [
    "vault-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "vault-pub"
  assume_role {
    role_arn = "arn:aws:iam::851162413429:role/vault-ops-terraform"
  }
}

module "s3-vault-pub" {
  acl = "private"
  attributes = [
    "vault-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "whoa-org"
  assume_role {
    role_arn = "arn:aws:iam::389772512117:role/whoa-ops-terraform"
  }
}

module "s3-whoa-org" {
  acl = "private"
  attributes = [
    "whoa-org",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "whoa-net"
  assume_role {
    role_arn = "arn:aws:iam::464075062390:role/whoa-ops-terraform"
  }
}

module "s3-whoa-net" {
  acl = "private"
  attributes = [
    "whoa-net",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "whoa-hub"
  assume_role {
    role_arn = "arn:aws:iam::462478722501:role/whoa-ops-terraform"
  }
}

module "s3-whoa-hub" {
  acl = "private"
  attributes = [
    "whoa-hub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "whoa-dev"
  assume_role {
    role_arn = "arn:aws:iam::439761234835:role/whoa-ops-terraform"
  }
}

module "s3-whoa-dev" {
  acl = "private"
  attributes = [
    "whoa-dev",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "whoa-pub"
  assume_role {
    role_arn = "arn:aws:iam::204827926367:role/whoa-ops-terraform"
  }
}

module "s3-whoa-pub" {
  acl = "private"
  attributes = [
    "whoa-pub",
  ]
  enabled            = true
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./mod/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-pub
  }
}
