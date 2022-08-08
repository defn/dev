provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "vcluster"
}

module "devpod" {
  source = "../m/devpod"
  envs   = local.envs
}
