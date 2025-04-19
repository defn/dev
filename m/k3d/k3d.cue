package k3d

kube: argocd: [string]: [string]: metadata: namespace:                    "argocd"
kube: argocd: ConfigMap: "argocd-cmd-params-cm": data: "server.insecure": "true"
