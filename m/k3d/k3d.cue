@experiment(aliasv2)
@experiment(explicitopen)

package k3d

kube: argocd: ConfigMap: "argocd-cmd-params-cm": data: "server.insecure": "true"
