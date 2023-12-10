package common

argocd: {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		namespace: "argocd"
		name:      chart.name
	}
	spec: {
		project: "default"
		destination: {
			name:      "in-cluster"
			namespace: metadata.name
		}
		source: {
			repoURL:        value.registry
			"chart":        "library/helm/\(chart.name)"
			targetRevision: chart.version
		}
		syncPolicy: automated: {
			prune:    true
			selfHeal: true
		}
	}
}
