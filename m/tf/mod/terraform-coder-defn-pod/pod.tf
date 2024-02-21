locals {
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = local.ns
  }
}

resource "helm_release" "main" {
  count      = data.coder_parameter.vcluster.value
  name       = "vcluster"
  namespace  = local.ns
  repository = "https://charts.loft.sh"
  chart      = "vcluster"
  version    = "0.19.1"

  set {
    name  = "sync.pods.ephemeralContainers"
    value = "true"
  }

  set {
    name  = "sync.persistentvolumes.enabled"
    value = "true"
  }

  set {
    name  = "sync.ingresses.enabled"
    value = "true"
  }

  set {
    name  = "sync.nodes.enabled"
    value = "true"
  }

  set {
    name  = "sync.serviceaccounts.enabled"
    value = "true"
  }

  set {
    name  = "fallbackHostDns"
    value = "true"
  }

  set {
    name  = "init.manifests"
    value = data.template_file.manifest.rendered
  }
}

data "template_file" "manifest" {
  template = file("manifest.tpl")

  vars = {
    ns = local.ns
    owner_email = data.coder_workspace.me.owner_email
    owner_id = data.coder_workspace.me.owner_id
    id = data.coder_workspace.me.id
    name = data.coder_workspace.me.name
    owner = data.coder_workspace.me.owner
    init_script = coder_agent.main.init_script
    token = coder_agent.main.token
    docker_image = data.coder_parameter.docker_image.value
  }
}
