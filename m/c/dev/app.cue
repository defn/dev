package dev

version: string

chart: {
	apiVersion: "v2"
	type:       "application"
	name:       "dev"
	appVersion: "0.0.6"
	"version":  version
}

app: {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	metadata: {
		namespace: "argocd"
		name:      "dev"
	}
	spec: {
		project: "default"
		destination: name: "in-cluster"
		source: {
			repoURL:        "cache.defn.run:5000"
			chart:          "library/helm/dev"
			targetRevision: version
		}
		syncPolicy: automated: {
			prune:    true
			selfHeal: true
		}
	}
}

output: {
	"Chart.yaml": chart
	"app.yaml":   app
}
