provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "do-sfo3-remo"
}

module "devpod" {
  source = "../m/devpod"
  envs   = local.envs
}
