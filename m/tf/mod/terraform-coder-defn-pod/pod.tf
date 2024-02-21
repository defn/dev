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
    name = "World"
  }
}
