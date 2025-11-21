terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket       = "dfn-defn-terraform-state"
    use_lockfile = true
    encrypt      = true
    key          = "stacks/output/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "defn-org"
  alias   = "defn-org"
  region  = "us-east-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/global/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "org_defn" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-defn/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_gyre" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-gyre/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_coil" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-coil/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_curl" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-curl/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_spiral" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-spiral/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_helix" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-helix/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_fogg" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-fogg/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_vault" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-vault/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_circus" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-circus/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_jianghu" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-jianghu/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_imma" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-imma/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_whoa" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-whoa/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_immanent" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-immanent/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "org_chamber" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/org-chamber/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "acc_defn_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-defn-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_gyre_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-gyre-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_gyre_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-gyre-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_coil_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-coil-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_coil_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-coil-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_coil_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-coil-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_coil_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-coil-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_curl_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-curl-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_curl_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-curl-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_curl_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-curl-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_curl_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-curl-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_ci" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-ci/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_prod" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_spiral_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-spiral-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_ci" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-ci/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_prod" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_helix_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-helix-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_ci" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-ci/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_prod" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_fogg_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-fogg-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_ci" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-ci/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_prod" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_vault_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-vault-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_circus_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-circus-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_circus_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-circus-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_circus_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-circus-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_circus_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-circus-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_circus_ops" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-circus-ops/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_jianghu_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-jianghu-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_jianghu_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-jianghu-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_jianghu_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-jianghu-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_lib" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-lib/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_log" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-log/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_imma_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-imma-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_whoa_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-whoa-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_whoa_dev" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-whoa-dev/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_whoa_hub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-whoa-hub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_whoa_net" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-whoa-net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_whoa_pub" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-whoa-pub/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_changer" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-changer/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_chanter" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-chanter/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_doorkeeper" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-doorkeeper/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_ged" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-ged/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_hand" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-hand/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_herbal" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-herbal/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_namer" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-namer/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_patterner" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-patterner/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_roke" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-roke/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_summoner" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-summoner/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_immanent_windkey" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-immanent-windkey/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_org" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-org/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_1" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-1/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_2" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-2/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_3" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-3/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_4" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-4/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_5" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-5/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_6" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-6/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_7" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-7/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_8" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-8/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_9" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-9/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_a" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-a/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_b" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-b/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_c" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-c/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_d" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-d/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_e" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-e/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_f" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-f/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_g" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-g/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_h" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-h/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_i" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-i/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_j" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-j/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_l" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-l/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_m" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-m/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_n" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-n/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_o" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-o/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_p" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-p/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_q" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-q/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_r" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-r/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_s" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-s/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_t" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-t/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_u" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-u/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_v" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-v/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_w" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-w/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_x" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-x/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_y" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-y/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "acc_chamber_z" {
  backend = "s3"
  config = {
    bucket = "dfn-defn-terraform-state"
    key    = "stacks/acc-chamber-z/terraform.tfstate"
    region = "us-east-1"
  }
}

output "all" {
  value = {
    "global" : data.terraform_remote_state.global.outputs
    "org-defn" : data.terraform_remote_state.org_defn.outputs
    "org-gyre" : data.terraform_remote_state.org_gyre.outputs
    "org-coil" : data.terraform_remote_state.org_coil.outputs
    "org-curl" : data.terraform_remote_state.org_curl.outputs
    "org-spiral" : data.terraform_remote_state.org_spiral.outputs
    "org-helix" : data.terraform_remote_state.org_helix.outputs
    "org-fogg" : data.terraform_remote_state.org_fogg.outputs
    "org-vault" : data.terraform_remote_state.org_vault.outputs
    "org-circus" : data.terraform_remote_state.org_circus.outputs
    "org-jianghu" : data.terraform_remote_state.org_jianghu.outputs
    "org-imma" : data.terraform_remote_state.org_imma.outputs
    "org-whoa" : data.terraform_remote_state.org_whoa.outputs
    "org-immanent" : data.terraform_remote_state.org_immanent.outputs
    "org-chamber" : data.terraform_remote_state.org_chamber.outputs
    "acc-defn-org" : data.terraform_remote_state.acc_defn_org.outputs
    "acc-gyre-org" : data.terraform_remote_state.acc_gyre_org.outputs
    "acc-gyre-ops" : data.terraform_remote_state.acc_gyre_ops.outputs
    "acc-coil-org" : data.terraform_remote_state.acc_coil_org.outputs
    "acc-coil-hub" : data.terraform_remote_state.acc_coil_hub.outputs
    "acc-coil-lib" : data.terraform_remote_state.acc_coil_lib.outputs
    "acc-coil-net" : data.terraform_remote_state.acc_coil_net.outputs
    "acc-curl-org" : data.terraform_remote_state.acc_curl_org.outputs
    "acc-curl-hub" : data.terraform_remote_state.acc_curl_hub.outputs
    "acc-curl-lib" : data.terraform_remote_state.acc_curl_lib.outputs
    "acc-curl-net" : data.terraform_remote_state.acc_curl_net.outputs
    "acc-spiral-org" : data.terraform_remote_state.acc_spiral_org.outputs
    "acc-spiral-ci" : data.terraform_remote_state.acc_spiral_ci.outputs
    "acc-spiral-dev" : data.terraform_remote_state.acc_spiral_dev.outputs
    "acc-spiral-hub" : data.terraform_remote_state.acc_spiral_hub.outputs
    "acc-spiral-lib" : data.terraform_remote_state.acc_spiral_lib.outputs
    "acc-spiral-log" : data.terraform_remote_state.acc_spiral_log.outputs
    "acc-spiral-net" : data.terraform_remote_state.acc_spiral_net.outputs
    "acc-spiral-ops" : data.terraform_remote_state.acc_spiral_ops.outputs
    "acc-spiral-prod" : data.terraform_remote_state.acc_spiral_prod.outputs
    "acc-spiral-pub" : data.terraform_remote_state.acc_spiral_pub.outputs
    "acc-helix-org" : data.terraform_remote_state.acc_helix_org.outputs
    "acc-helix-ci" : data.terraform_remote_state.acc_helix_ci.outputs
    "acc-helix-dev" : data.terraform_remote_state.acc_helix_dev.outputs
    "acc-helix-hub" : data.terraform_remote_state.acc_helix_hub.outputs
    "acc-helix-lib" : data.terraform_remote_state.acc_helix_lib.outputs
    "acc-helix-log" : data.terraform_remote_state.acc_helix_log.outputs
    "acc-helix-net" : data.terraform_remote_state.acc_helix_net.outputs
    "acc-helix-ops" : data.terraform_remote_state.acc_helix_ops.outputs
    "acc-helix-prod" : data.terraform_remote_state.acc_helix_prod.outputs
    "acc-helix-pub" : data.terraform_remote_state.acc_helix_pub.outputs
    "acc-fogg-org" : data.terraform_remote_state.acc_fogg_org.outputs
    "acc-fogg-ci" : data.terraform_remote_state.acc_fogg_ci.outputs
    "acc-fogg-dev" : data.terraform_remote_state.acc_fogg_dev.outputs
    "acc-fogg-hub" : data.terraform_remote_state.acc_fogg_hub.outputs
    "acc-fogg-lib" : data.terraform_remote_state.acc_fogg_lib.outputs
    "acc-fogg-log" : data.terraform_remote_state.acc_fogg_log.outputs
    "acc-fogg-net" : data.terraform_remote_state.acc_fogg_net.outputs
    "acc-fogg-ops" : data.terraform_remote_state.acc_fogg_ops.outputs
    "acc-fogg-prod" : data.terraform_remote_state.acc_fogg_prod.outputs
    "acc-fogg-pub" : data.terraform_remote_state.acc_fogg_pub.outputs
    "acc-vault-org" : data.terraform_remote_state.acc_vault_org.outputs
    "acc-vault-ci" : data.terraform_remote_state.acc_vault_ci.outputs
    "acc-vault-dev" : data.terraform_remote_state.acc_vault_dev.outputs
    "acc-vault-hub" : data.terraform_remote_state.acc_vault_hub.outputs
    "acc-vault-lib" : data.terraform_remote_state.acc_vault_lib.outputs
    "acc-vault-log" : data.terraform_remote_state.acc_vault_log.outputs
    "acc-vault-net" : data.terraform_remote_state.acc_vault_net.outputs
    "acc-vault-ops" : data.terraform_remote_state.acc_vault_ops.outputs
    "acc-vault-prod" : data.terraform_remote_state.acc_vault_prod.outputs
    "acc-vault-pub" : data.terraform_remote_state.acc_vault_pub.outputs
    "acc-circus-org" : data.terraform_remote_state.acc_circus_org.outputs
    "acc-circus-lib" : data.terraform_remote_state.acc_circus_lib.outputs
    "acc-circus-log" : data.terraform_remote_state.acc_circus_log.outputs
    "acc-circus-net" : data.terraform_remote_state.acc_circus_net.outputs
    "acc-circus-ops" : data.terraform_remote_state.acc_circus_ops.outputs
    "acc-jianghu-org" : data.terraform_remote_state.acc_jianghu_org.outputs
    "acc-jianghu-log" : data.terraform_remote_state.acc_jianghu_log.outputs
    "acc-jianghu-net" : data.terraform_remote_state.acc_jianghu_net.outputs
    "acc-imma-org" : data.terraform_remote_state.acc_imma_org.outputs
    "acc-imma-dev" : data.terraform_remote_state.acc_imma_dev.outputs
    "acc-imma-lib" : data.terraform_remote_state.acc_imma_lib.outputs
    "acc-imma-log" : data.terraform_remote_state.acc_imma_log.outputs
    "acc-imma-net" : data.terraform_remote_state.acc_imma_net.outputs
    "acc-imma-pub" : data.terraform_remote_state.acc_imma_pub.outputs
    "acc-whoa-org" : data.terraform_remote_state.acc_whoa_org.outputs
    "acc-whoa-dev" : data.terraform_remote_state.acc_whoa_dev.outputs
    "acc-whoa-hub" : data.terraform_remote_state.acc_whoa_hub.outputs
    "acc-whoa-net" : data.terraform_remote_state.acc_whoa_net.outputs
    "acc-whoa-pub" : data.terraform_remote_state.acc_whoa_pub.outputs
    "acc-immanent-org" : data.terraform_remote_state.acc_immanent_org.outputs
    "acc-immanent-changer" : data.terraform_remote_state.acc_immanent_changer.outputs
    "acc-immanent-chanter" : data.terraform_remote_state.acc_immanent_chanter.outputs
    "acc-immanent-doorkeeper" : data.terraform_remote_state.acc_immanent_doorkeeper.outputs
    "acc-immanent-ged" : data.terraform_remote_state.acc_immanent_ged.outputs
    "acc-immanent-hand" : data.terraform_remote_state.acc_immanent_hand.outputs
    "acc-immanent-herbal" : data.terraform_remote_state.acc_immanent_herbal.outputs
    "acc-immanent-namer" : data.terraform_remote_state.acc_immanent_namer.outputs
    "acc-immanent-patterner" : data.terraform_remote_state.acc_immanent_patterner.outputs
    "acc-immanent-roke" : data.terraform_remote_state.acc_immanent_roke.outputs
    "acc-immanent-summoner" : data.terraform_remote_state.acc_immanent_summoner.outputs
    "acc-immanent-windkey" : data.terraform_remote_state.acc_immanent_windkey.outputs
    "acc-chamber-org" : data.terraform_remote_state.acc_chamber_org.outputs
    "acc-chamber-1" : data.terraform_remote_state.acc_chamber_1.outputs
    "acc-chamber-2" : data.terraform_remote_state.acc_chamber_2.outputs
    "acc-chamber-3" : data.terraform_remote_state.acc_chamber_3.outputs
    "acc-chamber-4" : data.terraform_remote_state.acc_chamber_4.outputs
    "acc-chamber-5" : data.terraform_remote_state.acc_chamber_5.outputs
    "acc-chamber-6" : data.terraform_remote_state.acc_chamber_6.outputs
    "acc-chamber-7" : data.terraform_remote_state.acc_chamber_7.outputs
    "acc-chamber-8" : data.terraform_remote_state.acc_chamber_8.outputs
    "acc-chamber-9" : data.terraform_remote_state.acc_chamber_9.outputs
    "acc-chamber-a" : data.terraform_remote_state.acc_chamber_a.outputs
    "acc-chamber-b" : data.terraform_remote_state.acc_chamber_b.outputs
    "acc-chamber-c" : data.terraform_remote_state.acc_chamber_c.outputs
    "acc-chamber-d" : data.terraform_remote_state.acc_chamber_d.outputs
    "acc-chamber-e" : data.terraform_remote_state.acc_chamber_e.outputs
    "acc-chamber-f" : data.terraform_remote_state.acc_chamber_f.outputs
    "acc-chamber-g" : data.terraform_remote_state.acc_chamber_g.outputs
    "acc-chamber-h" : data.terraform_remote_state.acc_chamber_h.outputs
    "acc-chamber-i" : data.terraform_remote_state.acc_chamber_i.outputs
    "acc-chamber-j" : data.terraform_remote_state.acc_chamber_j.outputs
    "acc-chamber-l" : data.terraform_remote_state.acc_chamber_l.outputs
    "acc-chamber-m" : data.terraform_remote_state.acc_chamber_m.outputs
    "acc-chamber-n" : data.terraform_remote_state.acc_chamber_n.outputs
    "acc-chamber-o" : data.terraform_remote_state.acc_chamber_o.outputs
    "acc-chamber-p" : data.terraform_remote_state.acc_chamber_p.outputs
    "acc-chamber-q" : data.terraform_remote_state.acc_chamber_q.outputs
    "acc-chamber-r" : data.terraform_remote_state.acc_chamber_r.outputs
    "acc-chamber-s" : data.terraform_remote_state.acc_chamber_s.outputs
    "acc-chamber-t" : data.terraform_remote_state.acc_chamber_t.outputs
    "acc-chamber-u" : data.terraform_remote_state.acc_chamber_u.outputs
    "acc-chamber-v" : data.terraform_remote_state.acc_chamber_v.outputs
    "acc-chamber-w" : data.terraform_remote_state.acc_chamber_w.outputs
    "acc-chamber-x" : data.terraform_remote_state.acc_chamber_x.outputs
    "acc-chamber-y" : data.terraform_remote_state.acc_chamber_y.outputs
    "acc-chamber-z" : data.terraform_remote_state.acc_chamber_z.outputs
  }
}

