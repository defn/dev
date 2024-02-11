package c

kustomize: [string]: #KustomizeHelm | #Kustomize
kustomize: [NAME=string]: _name: NAME

#Helm: {
	release:   string
	name:      string
	version:   string
	repo:      string
	namespace: string | *""

	values: {...} | *{}
}

#Resource: {
	kind: string | *""

	...
}

#Cluster: {
	handle:            string
	env:               string
	parent_env:        string | *env
	infra_account_id:  string
	infra_k3s_version: string

	infra_tailscale_domain: string

	infra_cidr_16:      string
	infra_pod_cidr:     string
	infra_service_cidr: string
	infra_cidr_16:      string | *"10.\(infra_cilium_id)"
	infra_pod_cidr:     string | *"\(infra_cidr_16).0.0/17"
	infra_service_cidr: string | *"\(infra_cidr_16).128.0/17"

	infra_cilium_name: string
	infra_cilium_id:   int | *0
	infra_cilium_id:   >=0
	infra_cilium_id:   <=255

	cluster_name: string
	name_suffix:  string

	domain_zone: string
	domain_name: string
	domain_slug: string

	secrets_region:   string
	issuer:           string
	cloudflare_email: string

	cluster_name: string

	bootstrap: [string]: #BootstrapConfig

	discovery_url: string

	discovery: {
		issuer:                 string
		jwks_uri:               string
		authorization_endpoint: string
		response_types_supported: [...string]
		subject_types_supported: [...string]
		id_token_signing_alg_values_supported: [...string]
		claims_supported: [...string]
	}
}

#Kustomize: {
	_name: string
	app: (_name): {}

	namespace: string | *""
	let kns = namespace

	psm: {...} | *{}
	jsp: {...} | *{}

	resource: {...} | *{}
	resource: [string]: #Resource

	commonLabels: [string]:      string
	commonAnnotations: [string]: string

	cluster: #Cluster

	out: {
		if kns != "" {
			namespace: kns
		}

		patches: [
			for _psm_name, _psm in psm {
				path: "patch-\(_psm_name).yaml"
			},
		] + [
			for _jsp_name, _jsp in jsp {
				path:   "jsonp-\(_jsp_name).yaml"
				target: _jsp.target
			},
		]

		resources: [
			for _rname, _r in resource {
				if _r.kind == "" {
					_r.url
				}
				if _r.kind != "" {
					"resource-\(_rname).yaml"
				}
			},
		]

		helmCharts?: [...{...}]

		if commonLabels != _|_ {
			// TODO convert to labels:, which has a different structure
			"labels": [
				for k, v in commonLabels {
					includeSelectors: true
					pairs: (k): v
				},
			]
		}

		if commonAnnotations != _|_ {
			"commonAnnotations": commonAnnotations
		}
	}
}

#KustomizeHelm: ctx={
	#Kustomize

	helm: #Helm

	out: {
		helmCharts: [{
			releaseName: helm.release
			name:        helm.name
			if ctx.namespace != "" {
				namespace: ctx.namespace
			}
			if ctx.namespace == "" {
				if helm.namespace != "" {
					namespace: helm.namespace
				}
			}
			version:     helm.version
			repo:        helm.repo
			includeCRDs: true

			if helm.values != null {
				valuesInline: helm.values
			}
		}]
	}
}

#TransformKarpenterProvisioner: {
	from: {
		#Input
		instance_types: [...string]
	}

	to: #KarpenterProvisioner
}

#KarpenterProvisioner: {
	_in: #TransformKarpenterProvisioner.from

	apiVersion: "karpenter.sh/v1alpha5"
	kind:       "Provisioner"
	metadata: name: _in.name
	spec: {
		requirements: [{
			key:      "karpenter.sh/capacity-type"
			operator: "In"
			values: ["spot"]
		}, {
			key:      "kubernetes.io/arch"
			operator: "In"
			values: ["amd64"]
		}, {
			key:      "node.kubernetes.io/instance-type"
			operator: "In"
			values:   _in.instance_types
		}]
		limits: resources: cpu: "2"
		labels: env: _in.name
		taints: [{
			key:    "env"
			value:  _in.name
			effect: "NoSchedule"
		}]
		providerRef: name: "default"
		ttlSecondsAfterEmpty: 600
	}
}

#TransformChicken: {
	from: #Input

	to: #Chicken
}

#Chicken: #Kustomize & {
	_in: #TransformChicken.from

	resource: "pre-sync-hook-egg": {
		apiVersion: "tf.isaaguilar.com/v1alpha2"
		kind:       "Terraform"

		metadata: {
			name:      "\(_in.name)-egg"
			namespace: "default"
			annotations: "argocd.argoproj.io/hook":      "PreSync"
			annotations: "argocd.argoproj.io/sync-wave": "0"
		}

		spec: {
			terraformVersion: "1.0.0"
			terraformModule: source: "https://github.com/ppm.git//app/tf/m/egg?ref=main"

			taskOptions: [{
				for: ["*"]
				env: [{
					name:  "TF_VAR_egg"
					value: _in.name
				}]
			}]

			serviceAccount: "default"
			scmAuthMethods: []

			ignoreDelete:       true
			keepLatestPodsOnly: true

			backend: """
					terraform {
						backend "kubernetes" {
							in_cluster_config = true
							secret_suffix     = "\(_in.name)-egg"
							namespace         = "default"
						}
					}
					"""
		}
	}

	resource: "pre-sync-hook-hatch-egg": {
		apiVersion: "batch/v1"
		kind:       "Job"
		metadata: {
			name:      "hatch-\(_in.name)-egg"
			namespace: "default"
			annotations: "argocd.argoproj.io/hook":      "PreSync"
			annotations: "argocd.argoproj.io/sync-wave": "1"
		}

		spec: backoffLimit: 0
		spec: template: spec: {
			serviceAccountName: "default"
			containers: [{
				name:  "meh"
				image: "defn/dev:kubectl"
				command: ["bash", "-c"]
				args: ["""
						test "completed" == "$(kubectl get tf \(_in.name)-egg -o json | jq -r '.status.phase')"
						"""]
			}]
			restartPolicy: "Never"
		}
	}

	resource: "tfo-demo-\(_in.name)": {
		apiVersion: "tf.isaaguilar.com/v1alpha2"
		kind:       "Terraform"

		metadata: {
			name:      _in.name
			namespace: "default"
		}

		spec: {
			terraformVersion: "1.0.0"
			terraformModule: source: "https://github.com/defn/dev/m.git//tf/chicken?ref=main"

			taskOptions: [{
				for: ["*"]
				env: [{
					name:  "TF_VAR_chicken"
					value: _in.name
				}]
			}]

			//resourceDownloads: [{
			// address: ""
			// useAsVar: false
			//}]

			serviceAccount: "default"
			scmAuthMethods: []

			ignoreDelete:       true
			keepLatestPodsOnly: true

			outputsToOmit: ["0"]

			backend: """
					terraform {
					  backend "kubernetes" {
					    in_cluster_config = true
					    secret_suffix     = "\(_in.name)"
					    namespace         = "default"
					  }
					}
					"""
		}
	}
}
