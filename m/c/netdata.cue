package c

import (
	core "k8s.io/api/core/v1"
)

// https://artifacthub.io/packages/helm/netdata/netdata
kustomize: "netdata": #KustomizeHelm & {
	namespace: "netdata"

	helm: {
		release: "netdata"
		name:    "netdata"
		version: "3.7.68"
		repo:    "https://netdata.github.io/helmchart"
		values: {
		}
	}

	resource: "namespace-netdata": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "netdata"
		}
	}
}
