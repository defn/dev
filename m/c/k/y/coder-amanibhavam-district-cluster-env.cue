package y

res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-argo-cd": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-argo-cd"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-argo-cd"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.123"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-argo-events": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-argo-events"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-argo-events"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-argo-workflows": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-argo-workflows"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-argo-workflows"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.113"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-buildkite": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-buildkite"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-buildkite"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-cert-manager": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-cert-manager"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-cert-manager"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.106"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-cilium": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-cilium"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-cilium"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.108"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-coder": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-coder"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-coder"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.109"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-deathstar": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-deathstar"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-deathstar"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.3"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-descheduler": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-descheduler"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-descheduler"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-external-dns": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-external-dns"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-external-dns"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.109"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-external-secrets": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-external-secrets"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-external-secrets"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.105"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-harbor": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-harbor"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-harbor"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-headlamp": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-headlamp"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-headlamp"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-issuer": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-issuer"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-issuer"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.108"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-karpenter": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-karpenter"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-karpenter"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.108"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-kyverno": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-kyverno"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-kyverno"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.111"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: ["ServerSideApply=true"]
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-l5d-control": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-l5d-control"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-l5d-control"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.8"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-l5d-crds": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-l5d-crds"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-l5d-crds"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.3"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-pihole": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-pihole"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-pihole"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.105"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-pod-identity": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-pod-identity"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-pod-identity"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-postgres-operator": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-postgres-operator"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-postgres-operator"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-reloader": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-reloader"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-reloader"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.106"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-secrets": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-secrets"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-secrets"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-tailscale": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-tailscale"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-tailscale"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.8"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-tetragon": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-tetragon"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-tetragon"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.104"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-tfo": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-tfo"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-tfo"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-traefik": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-traefik"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-traefik"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.106"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
res: application: "coder-amanibhavam-district-cluster-env": argocd: "coder-amanibhavam-district-cluster-trust-manager": {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		annotations: "argocd.argoproj.io/sync-wave": "100"
		name:      "coder-amanibhavam-district-cluster-trust-manager"
		namespace: "argocd"
	}
	spec: {
		destination: name: "coder-amanibhavam-district-cluster"
		project: "default"
		source: {
			chart:          "library/helm/coder-amanibhavam-district-cluster-trust-manager"
			repoURL:        "cache.defn.run:5000"
			targetRevision: "0.0.103"
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: []
		}
	}
}
