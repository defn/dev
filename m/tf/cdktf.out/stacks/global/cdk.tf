terraform {
  required_providers {
    aws = {
      version = "5.34.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "defn-org/global/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "gyre-org"
  assume_role {
    role_arn = "arn:aws:iam::065163301604:role/dfn-defn-terraform"
  }
}
module "s3-gyre-org" {
  acl = "private"
  attributes = [
    "gyre-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.gyre-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "gyre-ops"
  assume_role {
    role_arn = "arn:aws:iam::319951235442:role/dfn-defn-terraform"
  }
}
module "s3-gyre-ops" {
  acl = "private"
  attributes = [
    "gyre-ops",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.gyre-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-org"
  assume_role {
    role_arn = "arn:aws:iam::138291560003:role/dfn-defn-terraform"
  }
}
module "s3-coil-org" {
  acl = "private"
  attributes = [
    "coil-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-net"
  assume_role {
    role_arn = "arn:aws:iam::278790191486:role/dfn-defn-terraform"
  }
}
module "s3-coil-net" {
  acl = "private"
  attributes = [
    "coil-net",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-lib"
  assume_role {
    role_arn = "arn:aws:iam::160764896647:role/dfn-defn-terraform"
  }
}
module "s3-coil-lib" {
  acl = "private"
  attributes = [
    "coil-lib",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias   = "coil-hub"
  assume_role {
    role_arn = "arn:aws:iam::453991412409:role/dfn-defn-terraform"
  }
}
module "s3-coil-hub" {
  acl = "private"
  attributes = [
    "coil-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.coil-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-org"
  assume_role {
    role_arn = "arn:aws:iam::475528707847:role/dfn-defn-terraform"
  }
}
module "s3-vault-org" {
  acl = "private"
  attributes = [
    "vault-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-transit"
  assume_role {
    role_arn = "arn:aws:iam::915207860232:role/dfn-defn-terraform"
  }
}
module "s3-vault-transit" {
  acl = "private"
  attributes = [
    "vault-transit",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-transit
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-audit"
  assume_role {
    role_arn = "arn:aws:iam::749185891195:role/dfn-defn-terraform"
  }
}
module "s3-vault-audit" {
  acl = "private"
  attributes = [
    "vault-audit",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-audit
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-vault0"
  assume_role {
    role_arn = "arn:aws:iam::313228123503:role/dfn-defn-terraform"
  }
}
module "s3-vault-vault0" {
  acl = "private"
  attributes = [
    "vault-vault0",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-vault0
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-vault1"
  assume_role {
    role_arn = "arn:aws:iam::040769490632:role/dfn-defn-terraform"
  }
}
module "s3-vault-vault1" {
  acl = "private"
  attributes = [
    "vault-vault1",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-vault1
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-ops"
  assume_role {
    role_arn = "arn:aws:iam::188066400611:role/dfn-defn-terraform"
  }
}
module "s3-vault-ops" {
  acl = "private"
  attributes = [
    "vault-ops",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-library"
  assume_role {
    role_arn = "arn:aws:iam::066356637485:role/dfn-defn-terraform"
  }
}
module "s3-vault-library" {
  acl = "private"
  attributes = [
    "vault-library",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-library
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-hub"
  assume_role {
    role_arn = "arn:aws:iam::539099112425:role/dfn-defn-terraform"
  }
}
module "s3-vault-hub" {
  acl = "private"
  attributes = [
    "vault-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-pub"
  assume_role {
    role_arn = "arn:aws:iam::851162413429:role/dfn-defn-terraform"
  }
}
module "s3-vault-pub" {
  acl = "private"
  attributes = [
    "vault-pub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "vault-dev"
  assume_role {
    role_arn = "arn:aws:iam::497393606242:role/dfn-defn-terraform"
  }
}
module "s3-vault-dev" {
  acl = "private"
  attributes = [
    "vault-dev",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.vault-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "whoa-org"
  assume_role {
    role_arn = "arn:aws:iam::389772512117:role/dfn-defn-terraform"
  }
}
module "s3-whoa-org" {
  acl = "private"
  attributes = [
    "whoa-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "whoa-prod"
  assume_role {
    role_arn = "arn:aws:iam::204827926367:role/dfn-defn-terraform"
  }
}
module "s3-whoa-prod" {
  acl = "private"
  attributes = [
    "whoa-prod",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-prod
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "whoa-secrets"
  assume_role {
    role_arn = "arn:aws:iam::464075062390:role/dfn-defn-terraform"
  }
}
module "s3-whoa-secrets" {
  acl = "private"
  attributes = [
    "whoa-secrets",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-secrets
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "whoa-dev"
  assume_role {
    role_arn = "arn:aws:iam::439761234835:role/dfn-defn-terraform"
  }
}
module "s3-whoa-dev" {
  acl = "private"
  attributes = [
    "whoa-dev",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "whoa-hub"
  assume_role {
    role_arn = "arn:aws:iam::462478722501:role/dfn-defn-terraform"
  }
}
module "s3-whoa-hub" {
  acl = "private"
  attributes = [
    "whoa-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.whoa-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-org"
  assume_role {
    role_arn = "arn:aws:iam::328216504962:role/dfn-defn-terraform"
  }
}
module "s3-fogg-org" {
  acl = "private"
  attributes = [
    "fogg-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-gateway"
  assume_role {
    role_arn = "arn:aws:iam::318746665903:role/dfn-defn-terraform"
  }
}
module "s3-fogg-gateway" {
  acl = "private"
  attributes = [
    "fogg-gateway",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-gateway
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-security"
  assume_role {
    role_arn = "arn:aws:iam::372333168887:role/dfn-defn-terraform"
  }
}
module "s3-fogg-security" {
  acl = "private"
  attributes = [
    "fogg-security",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-security
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-hub"
  assume_role {
    role_arn = "arn:aws:iam::337248635000:role/dfn-defn-terraform"
  }
}
module "s3-fogg-hub" {
  acl = "private"
  attributes = [
    "fogg-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-postx"
  assume_role {
    role_arn = "arn:aws:iam::565963418226:role/dfn-defn-terraform"
  }
}
module "s3-fogg-postx" {
  acl = "private"
  attributes = [
    "fogg-postx",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-postx
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-asset"
  assume_role {
    role_arn = "arn:aws:iam::060659916753:role/dfn-defn-terraform"
  }
}
module "s3-fogg-asset" {
  acl = "private"
  attributes = [
    "fogg-asset",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-asset
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-data"
  assume_role {
    role_arn = "arn:aws:iam::624713464251:role/dfn-defn-terraform"
  }
}
module "s3-fogg-data" {
  acl = "private"
  attributes = [
    "fogg-data",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-data
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-sandbox"
  assume_role {
    role_arn = "arn:aws:iam::442766271046:role/dfn-defn-terraform"
  }
}
module "s3-fogg-sandbox" {
  acl = "private"
  attributes = [
    "fogg-sandbox",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-sandbox
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-circus"
  assume_role {
    role_arn = "arn:aws:iam::844609041254:role/dfn-defn-terraform"
  }
}
module "s3-fogg-circus" {
  acl = "private"
  attributes = [
    "fogg-circus",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-circus
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "fogg-home"
  assume_role {
    role_arn = "arn:aws:iam::812459563189:role/dfn-defn-terraform"
  }
}
module "s3-fogg-home" {
  acl = "private"
  attributes = [
    "fogg-home",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.fogg-home
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "curl-org"
  assume_role {
    role_arn = "arn:aws:iam::424535767618:role/dfn-defn-terraform"
  }
}
module "s3-curl-org" {
  acl = "private"
  attributes = [
    "curl-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "curl-net"
  assume_role {
    role_arn = "arn:aws:iam::101142583332:role/dfn-defn-terraform"
  }
}
module "s3-curl-net" {
  acl = "private"
  attributes = [
    "curl-net",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "curl-lib"
  assume_role {
    role_arn = "arn:aws:iam::298406631539:role/dfn-defn-terraform"
  }
}
module "s3-curl-lib" {
  acl = "private"
  attributes = [
    "curl-lib",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "curl-hub"
  assume_role {
    role_arn = "arn:aws:iam::804430872255:role/dfn-defn-terraform"
  }
}
module "s3-curl-hub" {
  acl = "private"
  attributes = [
    "curl-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.curl-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-org"
  assume_role {
    role_arn = "arn:aws:iam::232091571197:role/dfn-defn-terraform"
  }
}
module "s3-spiral-org" {
  acl = "private"
  attributes = [
    "spiral-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-ops"
  assume_role {
    role_arn = "arn:aws:iam::601164058091:role/dfn-defn-terraform"
  }
}
module "s3-spiral-ops" {
  acl = "private"
  attributes = [
    "spiral-ops",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-sec"
  assume_role {
    role_arn = "arn:aws:iam::398258703387:role/dfn-defn-terraform"
  }
}
module "s3-spiral-sec" {
  acl = "private"
  attributes = [
    "spiral-sec",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-sec
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-net"
  assume_role {
    role_arn = "arn:aws:iam::057533398557:role/dfn-defn-terraform"
  }
}
module "s3-spiral-net" {
  acl = "private"
  attributes = [
    "spiral-net",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-log"
  assume_role {
    role_arn = "arn:aws:iam::442333715734:role/dfn-defn-terraform"
  }
}
module "s3-spiral-log" {
  acl = "private"
  attributes = [
    "spiral-log",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-lib"
  assume_role {
    role_arn = "arn:aws:iam::073874947996:role/dfn-defn-terraform"
  }
}
module "s3-spiral-lib" {
  acl = "private"
  attributes = [
    "spiral-lib",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-pub"
  assume_role {
    role_arn = "arn:aws:iam::371657257885:role/dfn-defn-terraform"
  }
}
module "s3-spiral-pub" {
  acl = "private"
  attributes = [
    "spiral-pub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-dmz"
  assume_role {
    role_arn = "arn:aws:iam::130046154300:role/dfn-defn-terraform"
  }
}
module "s3-spiral-dmz" {
  acl = "private"
  attributes = [
    "spiral-dmz",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-dmz
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-hub"
  assume_role {
    role_arn = "arn:aws:iam::216704421225:role/dfn-defn-terraform"
  }
}
module "s3-spiral-hub" {
  acl = "private"
  attributes = [
    "spiral-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "spiral-dev"
  assume_role {
    role_arn = "arn:aws:iam::308726031860:role/dfn-defn-terraform"
  }
}
module "s3-spiral-dev" {
  acl = "private"
  attributes = [
    "spiral-dev",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.spiral-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "circus-org"
  assume_role {
    role_arn = "arn:aws:iam::036139182623:role/dfn-defn-terraform"
  }
}
module "s3-circus-org" {
  acl = "private"
  attributes = [
    "circus-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "circus-audit"
  assume_role {
    role_arn = "arn:aws:iam::707476523482:role/dfn-defn-terraform"
  }
}
module "s3-circus-audit" {
  acl = "private"
  attributes = [
    "circus-audit",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-audit
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "circus-govcloud"
  assume_role {
    role_arn = "arn:aws:iam::497790518354:role/dfn-defn-terraform"
  }
}
module "s3-circus-govcloud" {
  acl = "private"
  attributes = [
    "circus-govcloud",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-govcloud
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "circus-ops"
  assume_role {
    role_arn = "arn:aws:iam::415618116579:role/dfn-defn-terraform"
  }
}
module "s3-circus-ops" {
  acl = "private"
  attributes = [
    "circus-ops",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "circus-transit"
  assume_role {
    role_arn = "arn:aws:iam::002516226222:role/dfn-defn-terraform"
  }
}
module "s3-circus-transit" {
  acl = "private"
  attributes = [
    "circus-transit",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.circus-transit
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-org"
  assume_role {
    role_arn = "arn:aws:iam::548373030883:role/dfn-defn-terraform"
  }
}
module "s3-imma-org" {
  acl = "private"
  attributes = [
    "imma-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-prod"
  assume_role {
    role_arn = "arn:aws:iam::766142996227:role/dfn-defn-terraform"
  }
}
module "s3-imma-prod" {
  acl = "private"
  attributes = [
    "imma-prod",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-prod
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-dev"
  assume_role {
    role_arn = "arn:aws:iam::445584037541:role/dfn-defn-terraform"
  }
}
module "s3-imma-dev" {
  acl = "private"
  attributes = [
    "imma-dev",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-tolan"
  assume_role {
    role_arn = "arn:aws:iam::516851121506:role/dfn-defn-terraform"
  }
}
module "s3-imma-tolan" {
  acl = "private"
  attributes = [
    "imma-tolan",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-tolan
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-dgwyn"
  assume_role {
    role_arn = "arn:aws:iam::289716781198:role/dfn-defn-terraform"
  }
}
module "s3-imma-dgwyn" {
  acl = "private"
  attributes = [
    "imma-dgwyn",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-dgwyn
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "imma-defn"
  assume_role {
    role_arn = "arn:aws:iam::246197522468:role/dfn-defn-terraform"
  }
}
module "s3-imma-defn" {
  acl = "private"
  attributes = [
    "imma-defn",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.imma-defn
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-org"
  assume_role {
    role_arn = "arn:aws:iam::816178966829:role/dfn-defn-terraform"
  }
}
module "s3-helix-org" {
  acl = "private"
  attributes = [
    "helix-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-ops"
  assume_role {
    role_arn = "arn:aws:iam::368812692254:role/dfn-defn-terraform"
  }
}
module "s3-helix-ops" {
  acl = "private"
  attributes = [
    "helix-ops",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-ops
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-sec"
  assume_role {
    role_arn = "arn:aws:iam::018520313738:role/dfn-defn-terraform"
  }
}
module "s3-helix-sec" {
  acl = "private"
  attributes = [
    "helix-sec",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-sec
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-net"
  assume_role {
    role_arn = "arn:aws:iam::504722108514:role/dfn-defn-terraform"
  }
}
module "s3-helix-net" {
  acl = "private"
  attributes = [
    "helix-net",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-net
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-log"
  assume_role {
    role_arn = "arn:aws:iam::664427926343:role/dfn-defn-terraform"
  }
}
module "s3-helix-log" {
  acl = "private"
  attributes = [
    "helix-log",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-log
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-lib"
  assume_role {
    role_arn = "arn:aws:iam::377857698578:role/dfn-defn-terraform"
  }
}
module "s3-helix-lib" {
  acl = "private"
  attributes = [
    "helix-lib",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-lib
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-pub"
  assume_role {
    role_arn = "arn:aws:iam::536806623881:role/dfn-defn-terraform"
  }
}
module "s3-helix-pub" {
  acl = "private"
  attributes = [
    "helix-pub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-pub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-dmz"
  assume_role {
    role_arn = "arn:aws:iam::724643698007:role/dfn-defn-terraform"
  }
}
module "s3-helix-dmz" {
  acl = "private"
  attributes = [
    "helix-dmz",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-dmz
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-hub"
  assume_role {
    role_arn = "arn:aws:iam::436043820387:role/dfn-defn-terraform"
  }
}
module "s3-helix-hub" {
  acl = "private"
  attributes = [
    "helix-hub",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-hub
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "helix-dev"
  assume_role {
    role_arn = "arn:aws:iam::843784871878:role/dfn-defn-terraform"
  }
}
module "s3-helix-dev" {
  acl = "private"
  attributes = [
    "helix-dev",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.helix-dev
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-org"
  assume_role {
    role_arn = "arn:aws:iam::730917619329:role/dfn-defn-terraform"
  }
}
module "s3-chamber-org" {
  acl = "private"
  attributes = [
    "chamber-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-1"
  assume_role {
    role_arn = "arn:aws:iam::741346472057:role/dfn-defn-terraform"
  }
}
module "s3-chamber-1" {
  acl = "private"
  attributes = [
    "chamber-1",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-1
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-2"
  assume_role {
    role_arn = "arn:aws:iam::447993872368:role/dfn-defn-terraform"
  }
}
module "s3-chamber-2" {
  acl = "private"
  attributes = [
    "chamber-2",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-2
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-3"
  assume_role {
    role_arn = "arn:aws:iam::463050069968:role/dfn-defn-terraform"
  }
}
module "s3-chamber-3" {
  acl = "private"
  attributes = [
    "chamber-3",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-3
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-4"
  assume_role {
    role_arn = "arn:aws:iam::368890376620:role/dfn-defn-terraform"
  }
}
module "s3-chamber-4" {
  acl = "private"
  attributes = [
    "chamber-4",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-4
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-5"
  assume_role {
    role_arn = "arn:aws:iam::200733412967:role/dfn-defn-terraform"
  }
}
module "s3-chamber-5" {
  acl = "private"
  attributes = [
    "chamber-5",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-5
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-6"
  assume_role {
    role_arn = "arn:aws:iam::493089153027:role/dfn-defn-terraform"
  }
}
module "s3-chamber-6" {
  acl = "private"
  attributes = [
    "chamber-6",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-6
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-7"
  assume_role {
    role_arn = "arn:aws:iam::837425503386:role/dfn-defn-terraform"
  }
}
module "s3-chamber-7" {
  acl = "private"
  attributes = [
    "chamber-7",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-7
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-8"
  assume_role {
    role_arn = "arn:aws:iam::773314335856:role/dfn-defn-terraform"
  }
}
module "s3-chamber-8" {
  acl = "private"
  attributes = [
    "chamber-8",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-8
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-9"
  assume_role {
    role_arn = "arn:aws:iam::950940975070:role/dfn-defn-terraform"
  }
}
module "s3-chamber-9" {
  acl = "private"
  attributes = [
    "chamber-9",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-9
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-a"
  assume_role {
    role_arn = "arn:aws:iam::503577294851:role/dfn-defn-terraform"
  }
}
module "s3-chamber-a" {
  acl = "private"
  attributes = [
    "chamber-a",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-a
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-b"
  assume_role {
    role_arn = "arn:aws:iam::310940910494:role/dfn-defn-terraform"
  }
}
module "s3-chamber-b" {
  acl = "private"
  attributes = [
    "chamber-b",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-b
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-c"
  assume_role {
    role_arn = "arn:aws:iam::047633732615:role/dfn-defn-terraform"
  }
}
module "s3-chamber-c" {
  acl = "private"
  attributes = [
    "chamber-c",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-c
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-d"
  assume_role {
    role_arn = "arn:aws:iam::699441347021:role/dfn-defn-terraform"
  }
}
module "s3-chamber-d" {
  acl = "private"
  attributes = [
    "chamber-d",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-d
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-e"
  assume_role {
    role_arn = "arn:aws:iam::171831323337:role/dfn-defn-terraform"
  }
}
module "s3-chamber-e" {
  acl = "private"
  attributes = [
    "chamber-e",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-e
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-f"
  assume_role {
    role_arn = "arn:aws:iam::842022523232:role/dfn-defn-terraform"
  }
}
module "s3-chamber-f" {
  acl = "private"
  attributes = [
    "chamber-f",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-f
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-g"
  assume_role {
    role_arn = "arn:aws:iam::023867963778:role/dfn-defn-terraform"
  }
}
module "s3-chamber-g" {
  acl = "private"
  attributes = [
    "chamber-g",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-g
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-h"
  assume_role {
    role_arn = "arn:aws:iam::371020107387:role/dfn-defn-terraform"
  }
}
module "s3-chamber-h" {
  acl = "private"
  attributes = [
    "chamber-h",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-h
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-i"
  assume_role {
    role_arn = "arn:aws:iam::290132238209:role/dfn-defn-terraform"
  }
}
module "s3-chamber-i" {
  acl = "private"
  attributes = [
    "chamber-i",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-i
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-j"
  assume_role {
    role_arn = "arn:aws:iam::738433022197:role/dfn-defn-terraform"
  }
}
module "s3-chamber-j" {
  acl = "private"
  attributes = [
    "chamber-j",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-j
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-l"
  assume_role {
    role_arn = "arn:aws:iam::991300382347:role/dfn-defn-terraform"
  }
}
module "s3-chamber-l" {
  acl = "private"
  attributes = [
    "chamber-l",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-l
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-m"
  assume_role {
    role_arn = "arn:aws:iam::684895750259:role/dfn-defn-terraform"
  }
}
module "s3-chamber-m" {
  acl = "private"
  attributes = [
    "chamber-m",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-m
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-n"
  assume_role {
    role_arn = "arn:aws:iam::705881812506:role/dfn-defn-terraform"
  }
}
module "s3-chamber-n" {
  acl = "private"
  attributes = [
    "chamber-n",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-n
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-o"
  assume_role {
    role_arn = "arn:aws:iam::307136835824:role/dfn-defn-terraform"
  }
}
module "s3-chamber-o" {
  acl = "private"
  attributes = [
    "chamber-o",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-o
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-p"
  assume_role {
    role_arn = "arn:aws:iam::706168331526:role/dfn-defn-terraform"
  }
}
module "s3-chamber-p" {
  acl = "private"
  attributes = [
    "chamber-p",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-p
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-q"
  assume_role {
    role_arn = "arn:aws:iam::217047480856:role/dfn-defn-terraform"
  }
}
module "s3-chamber-q" {
  acl = "private"
  attributes = [
    "chamber-q",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-q
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-r"
  assume_role {
    role_arn = "arn:aws:iam::416221726155:role/dfn-defn-terraform"
  }
}
module "s3-chamber-r" {
  acl = "private"
  attributes = [
    "chamber-r",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-r
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-s"
  assume_role {
    role_arn = "arn:aws:iam::840650118369:role/dfn-defn-terraform"
  }
}
module "s3-chamber-s" {
  acl = "private"
  attributes = [
    "chamber-s",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-s
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-t"
  assume_role {
    role_arn = "arn:aws:iam::490895200523:role/dfn-defn-terraform"
  }
}
module "s3-chamber-t" {
  acl = "private"
  attributes = [
    "chamber-t",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-t
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-u"
  assume_role {
    role_arn = "arn:aws:iam::467995590869:role/dfn-defn-terraform"
  }
}
module "s3-chamber-u" {
  acl = "private"
  attributes = [
    "chamber-u",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-u
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-v"
  assume_role {
    role_arn = "arn:aws:iam::979368042862:role/dfn-defn-terraform"
  }
}
module "s3-chamber-v" {
  acl = "private"
  attributes = [
    "chamber-v",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-v
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-w"
  assume_role {
    role_arn = "arn:aws:iam::313387692116:role/dfn-defn-terraform"
  }
}
module "s3-chamber-w" {
  acl = "private"
  attributes = [
    "chamber-w",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-w
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-x"
  assume_role {
    role_arn = "arn:aws:iam::834936839208:role/dfn-defn-terraform"
  }
}
module "s3-chamber-x" {
  acl = "private"
  attributes = [
    "chamber-x",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-x
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-y"
  assume_role {
    role_arn = "arn:aws:iam::153556747817:role/dfn-defn-terraform"
  }
}
module "s3-chamber-y" {
  acl = "private"
  attributes = [
    "chamber-y",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-y
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "chamber-z"
  assume_role {
    role_arn = "arn:aws:iam::037804009879:role/dfn-defn-terraform"
  }
}
module "s3-chamber-z" {
  acl = "private"
  attributes = [
    "chamber-z",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.chamber-z
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-2"
  alias   = "defn-org"
  assume_role {
    role_arn = "arn:aws:iam::510430971399:role/dfn-defn-terraform"
  }
}
module "s3-defn-org" {
  acl = "private"
  attributes = [
    "defn-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.defn-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-org"
  assume_role {
    role_arn = "arn:aws:iam::545070380609:role/dfn-defn-terraform"
  }
}
module "s3-immanent-org" {
  acl = "private"
  attributes = [
    "immanent-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-patterner"
  assume_role {
    role_arn = "arn:aws:iam::143220204648:role/dfn-defn-terraform"
  }
}
module "s3-immanent-patterner" {
  acl = "private"
  attributes = [
    "immanent-patterner",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-patterner
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-windkey"
  assume_role {
    role_arn = "arn:aws:iam::095764861781:role/dfn-defn-terraform"
  }
}
module "s3-immanent-windkey" {
  acl = "private"
  attributes = [
    "immanent-windkey",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-windkey
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-summoner"
  assume_role {
    role_arn = "arn:aws:iam::397411277587:role/dfn-defn-terraform"
  }
}
module "s3-immanent-summoner" {
  acl = "private"
  attributes = [
    "immanent-summoner",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-summoner
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-herbal"
  assume_role {
    role_arn = "arn:aws:iam::165452499696:role/dfn-defn-terraform"
  }
}
module "s3-immanent-herbal" {
  acl = "private"
  attributes = [
    "immanent-herbal",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-herbal
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-namer"
  assume_role {
    role_arn = "arn:aws:iam::856549015893:role/dfn-defn-terraform"
  }
}
module "s3-immanent-namer" {
  acl = "private"
  attributes = [
    "immanent-namer",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-namer
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-ged"
  assume_role {
    role_arn = "arn:aws:iam::640792184178:role/dfn-defn-terraform"
  }
}
module "s3-immanent-ged" {
  acl = "private"
  attributes = [
    "immanent-ged",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-ged
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-roke"
  assume_role {
    role_arn = "arn:aws:iam::892560628624:role/dfn-defn-terraform"
  }
}
module "s3-immanent-roke" {
  acl = "private"
  attributes = [
    "immanent-roke",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-roke
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-chanter"
  assume_role {
    role_arn = "arn:aws:iam::071244154667:role/dfn-defn-terraform"
  }
}
module "s3-immanent-chanter" {
  acl = "private"
  attributes = [
    "immanent-chanter",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-chanter
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-changer"
  assume_role {
    role_arn = "arn:aws:iam::003884504807:role/dfn-defn-terraform"
  }
}
module "s3-immanent-changer" {
  acl = "private"
  attributes = [
    "immanent-changer",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-changer
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-hand"
  assume_role {
    role_arn = "arn:aws:iam::826250190242:role/dfn-defn-terraform"
  }
}
module "s3-immanent-hand" {
  acl = "private"
  attributes = [
    "immanent-hand",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-hand
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "immanent-doorkeeper"
  assume_role {
    role_arn = "arn:aws:iam::013267321144:role/dfn-defn-terraform"
  }
}
module "s3-immanent-doorkeeper" {
  acl = "private"
  attributes = [
    "immanent-doorkeeper",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.immanent-doorkeeper
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "jianghu-org"
  assume_role {
    role_arn = "arn:aws:iam::657613322961:role/dfn-defn-terraform"
  }
}
module "s3-jianghu-org" {
  acl = "private"
  attributes = [
    "jianghu-org",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-org
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "jianghu-tahoe"
  assume_role {
    role_arn = "arn:aws:iam::025636091251:role/dfn-defn-terraform"
  }
}
module "s3-jianghu-tahoe" {
  acl = "private"
  attributes = [
    "jianghu-tahoe",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-tahoe
  }
}

provider "aws" {
  profile = "defn-org-sso"
  region  = "us-west-2"
  alias   = "jianghu-klamath"
  assume_role {
    role_arn = "arn:aws:iam::298431841138:role/dfn-defn-terraform"
  }
}
module "s3-jianghu-klamath" {
  acl = "private"
  attributes = [
    "jianghu-klamath",
  ]
  name               = "global"
  namespace          = "dfn"
  stage              = "defn"
  user_enabled       = false
  versioning_enabled = false
  source             = "./assets/__cdktf_module_asset_26CE565C/3B662577168AEE3844EE70D2853CDA26/terraform-aws-s3-bucket"
  providers = {
    aws = aws.jianghu-klamath
  }
}