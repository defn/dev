package dev

app_ns: "dev"

app: {
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
			namespace: app_ns
		}
		source: {
			repoURL:        "cache.defn.run:5000"
			"chart":        "library/helm/\(chart.name)"
			targetRevision: chart.version
		}
		syncPolicy: automated: {
			prune:    true
			selfHeal: true
		}
	}
}
