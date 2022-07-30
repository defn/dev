provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-remo-defn"
}

module "devpod" {
  source = "../../m/devpod"
  envs   = local.envs
}
