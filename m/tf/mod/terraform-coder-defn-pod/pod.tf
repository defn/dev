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
    value = <<-EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "${local.ns}"
  namespace: default
  annotations:
    com.coder.user.email: "${data.coder_workspace.me.owner_email}"
  labels:
    app.kubernetes.io/name: "${local.ns}"
    app.kubernetes.io/instance: "${local.ns}"
    app.kubernetes.io/part-of: "coder"
    com.coder.resource: "true"
    com.coder.workspace.id: "${data.coder_workspace.me.id}"
    com.coder.workspace.name: "${data.coder_workspace.me.name}"
    com.coder.user.id: "${data.coder_workspace.me.owner_id}"
    com.coder.user.username: "${data.coder_workspace.me.owner}"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: "${local.ns}"
  template:
    metadata:
      labels:
        app.kubernetes.io/name: "${local.ns}"
    spec:
      containers:
        - command:
            - bash
            - -c
            - "${coder_agent.main.init_script}"
          env:
            - name: CODER_PROC_MEMNICE_ENABLE
              value: "1"
            - name: CODER_AGENT_TOKEN
              value: "${coder_agent.main.token}"
          image: "${data.coder_parameter.docker_image.value}"
          imagePullPolicy: Always
          name: coder-agent
          securityContext:
            privileged: true
            runAsUser: 1000
      securityContext:
        fsGroup: 1000
        runAsUser: 1000
EOT
  }
}
