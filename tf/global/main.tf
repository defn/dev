provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-global"
}

module "devpod" {
  source = "../m/devpod"
  envs   = local.envs
}
