provider "kubernetes" {}

resource "kubernetes_namespace" "chicken" {
  metadata {
    name = "chicken-${var.chicken}"
  }
}
