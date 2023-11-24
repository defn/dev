package dev

import (
	"encoding/yaml"
)

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
		name:      chart.name
	}
	spec: {
		project: "default"
		destination: name: "in-cluster"
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

output: {
	"Chart.yaml": """
        # managed by Cue
        \(yaml.Marshal(chart))
        """
	"app.yaml":   """
        # managed by Cue
        \(yaml.Marshal(app))
        """
}
