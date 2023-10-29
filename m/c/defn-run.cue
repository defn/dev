package c

teacher_handle: string
teacher_env:    string

teacher_bootstrap: {
	// essentials
	"kyverno": [100, "", "ServerSideApply=true"]
	"cert-manager": [100, ""]
	"trust-manager": [100, ""]

	// external secrets
	"pod-identity": [100, ""]
	"external-secrets": [100, ""]
	"secrets": [100, ""]

	// tailscale
	//"tailscale": [100, ""]

	// scaling
	"karpenter": [100, ""]

	// external dns, certs issuer
	"external-dns": [100, ""]
	"issuer": [100, ""]

	// traefik, functions
	"knative": [100, ""]
	"kourier": [100, ""]
	"traefik": [100, ""]
}

infra_account_id:       "510430971399"
infra_k3s_version:      "rancher/k3s:v1.27.5-k3s1"
infra_tailscale_domain: "tail3884f.ts.net"

infra_name: string | *"coder-\(teacher_handle)-\(teacher_env)"

infra_pod_cidr:     string
infra_service_cidr: string
infra_cilium_name:  string | *infra_name
infra_cilium_id:    int
infra_cilium_id:    >=0
infra_cilium_id:    <=255

infra_vclusters: []

infra_base: {
	domain_name: "\(teacher_env).\(teacher_handle).defn.run"
	domain_slug: "\(teacher_env)-\(teacher_handle)-defn-run"
}

infra_base: {
	domain_zone: "defn.run"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	cloudflare_email: "cloudflare@defn.us"
}

infra: (infra_name): bootstrap: {...} | *teacher_bootstrap
infra: (infra_name): bootstrap: infra_workloads

infra_workloads: {...}

discovery_url: string | *"https://\(infra_name).\(infra_tailscale_domain)"

kustomize: "hello": #Kustomize & {
	#app_ns: "default"
	#funcs: ["hello", "bye"]

	cluster: #Cluster

	resource: "ingressroute-\(cluster.domain_name)": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      cluster.domain_name
			namespace: #app_ns
		}
		spec: entryPoints: ["websecure"]
		spec: routes: [{
			match: "HostRegexp(`{subdomain:[a-z0-9-]+}.default.\(cluster.domain_name)`)"
			kind:  "Rule"
			services: [{
				name:      "kourier-internal"
				namespace: "kourier-system"
				kind:      "Service"
				port:      80
				scheme:    "http"
			}]
		}]
	}

	for f in #funcs {
		resource: "kservice-\(f)": {
			apiVersion: "serving.knative.dev/v1"
			kind:       "Service"
			metadata: {
				//labels: "networking.knative.dev/visibility": "cluster-local"
				name:      f
				namespace: #app_ns
			}
			spec: {
				template: spec: {
					containerConcurrency: 0
					containers: [{
						name:  "whoami"
						image: "containous/whoami:latest"
						ports: [{
							containerPort: 80
						}]
					}]
				}
				traffic: [{
					latestRevision: true
					percent:        100
				}]
			}
		}
	}
}
