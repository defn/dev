provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-imma"
}

module "devpod" {
  source = "../m/devpod"
  envs   = local.envs
}
