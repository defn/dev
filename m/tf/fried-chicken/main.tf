provider "kubernetes" {}

resource "kubernetes_namespace" "bonchon" {
  metadata {
    name = "bonchon"
  }
}
