package c

import (
	core "k8s.io/api/core/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"

	"strings"
)

infra_name: string

infra: {
	_base: {}

	[NAME=string]: _base & {
		if strings.HasPrefix(NAME, "vc") {
			cluster_name: "\(parent.cluster_name)-\(NAME)"
			name_suffix:  "-\(NAME)."
			bootstrap: [string]: #BootstrapConfig
		}
	}

	parent: {
		cluster_name: "k3d-\(infra_name)"
		vclusters: [...string]
		bootstrap: [string]: #BootstrapConfig
	}

	"\(infra_name)":                  parent
	"\(parent.cluster_name)-cluster": parent

	manual:                          parent
	"\(parent.cluster_name)-manual": manual

	for i, v in parent.vclusters {
		"\(v)": {}
		"\(infra[v].cluster_name)": infra[v]
	}
}

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(infra.parent.cluster_name)-manual": {
		bootstrap: {
			"cilium-bootstrap": [1, ""]
			"cert-manager-crds": [1, ""]
		}
	}
}).outputs

kustomize: [string]: cluster: #Cluster | *infra[infra_name]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(infra.parent.cluster_name)-cluster": {
		bootstrap: infra.parent.bootstrap & {
			for v in infra.parent.vclusters {
				// bootstrapped
				"cilium": [100, ""]
				"argo-cd": [100, ""]

				// vclusters
				"\(infra[v].cluster_name)-vcluster": [100, ""]
				"\(infra[v].cluster_name)-env": [101, ""]
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		for i, v in infra.parent.vclusters {
			"\(infra[v].cluster_name)-vcluster": {
				vc_index:   i
				vc_machine: infra[v].cluster_name
			}
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		for v in infra.parent.vclusters {
			"\(infra[v].cluster_name)": {
				instance_types: []
				parent:    env["\(infra.parent.cluster_name)-cluster"]
				bootstrap: infra[v].bootstrap
			}
		}
	}
}).outputs

kustomize: "secrets": #Kustomize & {
	cluster: #Cluster

	resource: "cluster-secret-store": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ClusterSecretStore"
		metadata: name: cluster.cluster_name
		spec: provider: aws: {
			service: "SecretsManager"
			region:  cluster.secrets_region
		}
	}
}

kustomize: "argo-cd": #Kustomize & {
	cluster: #Cluster

	namespace: "argocd"

	resource: "namespace-argocd": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argocd"
		}
	}

	resource: "argo-cd": {
		url: "https://raw.githubusercontent.com/argoproj/argo-cd/v2.8.2/manifests/install.yaml"
	}

	resource: "ingress-argo-cd": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "argo-cd"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "argocd.\(cluster.domain_name)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "argocd.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "argocd-server"
						port: number: 80
					}
				}]
			}]
		}
	}

	psm: "service-argocd-server": {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name: "argocd-server"
			annotations: {
				"traefik.ingress.kubernetes.io/service.serverstransport": "traefik-insecure@kubernetescrd"
			}
		}
	}

	psm: "configmap-argocd-cmd-params-cm": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "argocd-cmd-params-cm"
		data: {
			"server.insecure": "true"
		}
	}

	psm: "configmap-argocd-cm": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "argocd-cm"
		data: {
			"kustomize.buildOptions": "--enable-helm"

			"application.resourceTrackingMethod": "annotation"

			"resource.customizations.health.networking.k8s.io_Ingress": """
				hs = {}
				hs.status = "Healthy"
				return hs
				"""

			"resource.customizations.health.tf.isaaguilar.com_Terraform": """
				hs = {}
				hs.status = "Progressing"
				hs.message = ""
				if obj.status ~= nil then
				    if obj.status.phase ~= nil then
				          if obj.status.phase == "completed" then
				               hs.status = "Healthy"
				         end

				          if obj.status.stage ~= nil then
				            if obj.status.stage.reason ~= nil then
				                  hs.message = obj.status.stage.reason
				            end
				          end
				    end
				end
				return hs
				"""

			"resource.customizations.health.argoproj.io_Application": """
				hs = {}
				hs.status = "Progressing"
				hs.message = ""
				if obj.status ~= nil then
				    if obj.status.health ~= nil then
				    hs.status = obj.status.health.status
				    if obj.status.health.message ~= nil then
				        hs.message = obj.status.health.message
				    end
				    end
				end
				return hs
				"""

			"resource.customizations.ignoreDifferences.admissionregistration.k8s.io_MutatingWebhookConfiguration": """
				jsonPointers:
				  - /webhooks/0/clientConfig/caBundle
				  - /webhooks/0/rules

				"""

			"resource.customizations.ignoreDifferences.admissionregistration.k8s.io_ValidatingWebhookConfiguration": """
				jsonPointers:
				  - /webhooks/0/rules

				"""

			"resource.customizations.ignoreDifferences.apps_Deployment": """
				jsonPointers:
				  - /spec/template/spec/tolerations

				"""

			"resource.customizations.ignoreDifferences.kyverno.io_ClusterPolicy": """
				jqPathExpressions:
				  - .spec.rules[] | select(.name|test("autogen-."))

				"""
		}
	}
}

// https://artifacthub.io/packages/helm/kyverno/kyverno
kustomize: "kyverno": #KustomizeHelm & {
	namespace: "kyverno"

	helm: {
		release: "kyverno"
		name:    "kyverno"
		version: "3.0.5"
		repo:    "https://kyverno.github.io/kyverno"
		values: {
			replicaCount: 1
		}
	}

	resource: "namespace-kyverno": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "kyverno"
		}
	}

	resource: "clusterrole-background-controller-clusterissuers": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: "kyverno:background-controller:cert-manager"
		metadata: labels: {
			"app.kubernetes.io/component": "background-controller"
			"app.kubernetes.io/instance":  "kyverno"
			"app.kubernetes.io/part-of":   "kyverno"
		}
		rules: [{
			apiGroups: ["cert-manager.io"]
			resources: ["clusterissuers"]
			verbs: [ "create", "update", "patch", "delete"]
		}]
	}
}

// https://artifacthub.io/packages/helm/bitnami/external-dns
kustomize: "external-dns": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "external-dns"

	helm: {
		release: "external-dns"
		name:    "external-dns"
		version: "6.24.1"
		repo:    "https://charts.bitnami.com/bitnami"
		values: {
			logLevel: "debug"
			sources: [
				"service",
				"ingress",
			]
			provider: "cloudflare"
			cloudflare: {
				email:   cluster.cloudflare_email
				proxied: false
			}
			domainFilters: [
				cluster.domain_zone,
			]
		}
	}

	resource: "namespace-external-dns": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "external-dns"
		}
	}

	resource: "externalsecret-external-dns": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "external-dns"
			namespace: "external-dns"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: cluster.cluster_name
			}]
			target: {
				name:           "external-dns"
				creationPolicy: "Owner"
			}
		}
	}
}

// https://github.com/knative-sandbox/net-kourier/releases
kustomize: "kourier": #Kustomize & {
	cluster: #Cluster

	resource: "kourier": {
		url: "https://github.com/knative-sandbox/net-kourier/releases/download/knative-v1.11.1/kourier.yaml"
	}

	psm: "service-kourier-set-cluster-ip": {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name:      "kourier"
			namespace: "kourier-system"
		}
		spec: type: "ClusterIP"
	}

	resource: "ingress-default-wildcard": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name:      "default-wildcard"
			namespace: "kourier-system"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname": "*.default.\(cluster.domain_name)"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "wildcard.default.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "kourier-internal"
						port: number: 80
					}
				}]
			}]
		}
	}
}

// https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets
kustomize: "external-secrets": #KustomizeHelm & {
	namespace: "external-secrets"

	helm: {
		release: "external-secrets"
		name:    "external-secrets"
		version: "0.9.4"
		repo:    "https://charts.external-secrets.io"
		values: {
			webhook: create:        false
			certController: create: false
		}
	}

	resource: "namespace-external-secrets": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "external-secrets"
		}
	}

	psm: "serviceaccount-external-secrets": {
		apiVersion: "v1"
		kind:       "ServiceAccount"
		metadata: {
			name:      "external-secrets"
			namespace: "external-secrets"
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::510430971399:role/ro"
		}
	}

	resource: "cluster-role-binding-delegator": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "external-secrets-delegator"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "system:auth-delegator"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "external-secrets"
			namespace: "external-secrets"
		}]
	}
}

// https://artifacthub.io/packages/helm/jkroepke/amazon-eks-pod-identity-webhook
kustomize: "pod-identity": #KustomizeHelm & {
	namespace: "kube-system"

	helm: {
		release: "pod-identity"
		name:    "amazon-eks-pod-identity-webhook"
		version: "1.2.0"
		repo:    "https://jkroepke.github.io/helm-charts"
		values: {
			pki: certManager: certificate: duration:    "2160h0m0s"
			pki: certManager: certificate: renewBefore: "360h0m0s"
		}
	}
}

// gen_karpenter.sh
kustomize: "karpenter": #Kustomize & {
	namespace: "karpenter"

	resource: "karpenter": {
		url: "karpenter.yaml"
	}

	resource: "namespace-karpenter": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "karpenter"
		}
	}

	resource: (#Transform & {
		transformer: #TransformKarpenterProvisioner

		inputs: {
			for _env_name, _env in env {
				if (_env & #VCluster) != _|_ {
					if len(_env.instance_types) > 0 {
						"\(_env_name)": {}
					}
				}
			}

			[N=string]: {
				label:          "provisioner-\(N)"
				instance_types: env[N].instance_types
			}
		}
	}).outputs
}

// https://github.com/knative/serving/releases
kustomize: "knative": #Kustomize & {
	cluster: #Cluster

	resource: "knative-serving": {
		url: "https://github.com/knative/serving/releases/download/knative-v1.11.0/serving-core.yaml"
	}

	psm: "namespace-knative-serving": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "knative-serving"
		}
	}

	psm: "deployment-webhook": apps.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "webhook"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-controller": apps.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "controller"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-autoscaler": apps.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "autoscaler"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-activator": apps.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "activator"
			namespace: "knative-serving"
		}
	}

	psm: "config-map-config-defaults": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-defaults"
			namespace: "knative-serving"
		}
		data: {
			"revision-timeout-seconds":     "1800"
			"max-revision-timeout-seconds": "1800"
		}
	}

	psm: "config-map-config-domain": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-domain"
			namespace: "knative-serving"
		}
		data: "\(cluster.domain_name)": ""
	}

	psm: "config-map-config-features": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-features"
			namespace: "knative-serving"
		}
		data: {
			"kubernetes.podspec-affinity":    "enabled"
			"kubernetes.podspec-tolerations": "enabled"
		}
	}

	psm: "config-map-config-network": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-network"
			namespace: "knative-serving"
		}
		data: "ingress.class": "kourier.ingress.networking.knative.dev"
	}
}

// https://artifacthub.io/packages/helm/cert-manager/cert-manager
kustomize: "cert-manager-crds": #Kustomize & {
	resource: "cert-manager-crds": {
		url: "https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.crds.yaml"
	}
}

kustomize: "cert-manager": #KustomizeHelm & {
	cluster: #Cluster

	helm: {
		release:   "cert-manager"
		name:      "cert-manager"
		namespace: "cert-manager"
		version:   "1.12.3"
		repo:      "https://charts.jetstack.io"
		values: {
			ingressShim: {
				defaultIssuerName: cluster.issuer
				defaultIssuerKind: "ClusterIssuer"
			}

			global: logLevel: 4
		}
	}

	resource: "cert-manager-crds": {
		url: "https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.crds.yaml"
	}

	resource: "namespace-cert-manager": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: "cert-manager"
	}

	resource: "clusterissuer-cilium": {
		apiVersion: "cert-manager.io/v1"
		kind:       "ClusterIssuer"
		metadata: name: "cilium-ca"
		spec: ca: secretName: "cilium-ca"
	}
}

// https://artifacthub.io/packages/helm/loft/vcluster
#TransformKustomizeVCluster: {
	from: {
		#Input
		vc_name:    string | *from.name
		vc_machine: string | *from.name
		vc_index:   int | *0
		type:       string
	}

	to: #KustomizeVCluster
}

#KustomizeVCluster: {
	_in: #TransformKustomizeVCluster.from

	#KustomizeHelm

	namespace: _in.name

	helm: {
		release: "vcluster"
		name:    "vcluster"
		version: "0.15.7"
		repo:    "https://charts.loft.sh"

		values: {
			vcluster: image: "rancher/k3s:v1.26.7-k3s1"

			fallbackHostDns: true
			multiNamespaceMode: enabled: false
			service: type:               "LoadBalancer"

			sync: {
				pods: ephemeralContainers:  true
				persistentvolumes: enabled: true
				ingresses: enabled:         true
				nodes: enabled:             true
				serviceaccounts: enabled:   true
			}

			syncer: extraArgs: [
				"--tls-san=vcluster.\(_in.vc_name).svc.cluster.local",
				//"--enforce-toleration=env=\(_in.vc_name):NoSchedule",
			]

			//sync: nodes: nodeSelector: "env=\(_in.vc_machine)"

			//tolerations: [{
			//	key:      "env"
			//	value:    _in.vc_machine
			//	operator: "Equal"
			//}]

			//affinity: nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
			//	matchExpressions: [{
			//		key:      "env"
			//		operator: "In"
			//		values: [_in.vc_machine]
			//	}]
			//}]
		}
	}

	psm: "namespace-vcluster": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: _in.vc_name
			annotations: {
				"linkerd.io/inject": "disabled"
			}
		}
	}

	resource: "namespace-vcluster": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: _in.vc_name
		}
	}

	jsp: "service-vcluster-lb": {
		target: {
			group:     ""
			version:   "v1"
			kind:      "Service"
			name:      "vcluster-lb"
			namespace: _in.vc_name
		}

		patches: [{
			op:    "replace"
			path:  "/spec/ports/0/port"
			value: 8443 + _in.vc_index
		}]
	}
}

// https://artifacthub.io/packages/helm/cilium/cilium
kustomize: "cilium-bootstrap": #KustomizeHelm & {
	namespace: "kube-system"

	helm: {
		release:   "cilium"
		name:      "cilium"
		namespace: "kube-system"
		version:   "1.14.1"
		repo:      "https://helm.cilium.io"
		values: {
			operator: replicas: 1
			hubble: {
				relay: enabled: true
				ui: enabled:    false
				tls: auto: {
					method: "certmanager"
					certManagerIssuerRef: {
						name:  "cilium-ca"
						kind:  "ClusterIssuer"
						group: "cert-manager.io"
					}
				}
			}
		}
	}
}

kustomize: "cilium": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "kube-system"

	helm: {
		release:   "cilium"
		name:      "cilium"
		namespace: "kube-system"
		version:   "1.14.0"
		repo:      "https://helm.cilium.io"
		values: {
			operator: replicas: 1
			envoy: enabled:     true
			hubble: {
				relay: enabled: true
				ui: enabled:    true
				tls: auto: {
					method: "certmanager"
					certManagerIssuerRef: {
						name:  "cilium-ca"
						kind:  "ClusterIssuer"
						group: "cert-manager.io"
					}
				}
			}
		}
	}

	resource: "ingress-hubble-ui": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "hubble-ui"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "hubble.\(cluster.domain_name)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "hubble.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "hubble-ui"
						port: number: 80
					}
				}]
			}]
		}
	}
}

kustomize: "issuer": #Kustomize & {
	cluster: #Cluster

	resource: "externalsecret-\(cluster.issuer)": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      cluster.issuer
			namespace: "cert-manager"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: cluster.cluster_name
			}]
			target: {
				name:           cluster.issuer
				creationPolicy: "Owner"
			}
		}
	}

	resource: "clusterpolicy-clusterissuer-\(cluster.issuer)": {
		apiVersion: "kyverno.io/v1"
		kind:       "ClusterPolicy"
		metadata: name: "\(cluster.issuer)-clusterissuer"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-cluster-issuer"
				match: any: [{
					resources: {
						names: [
							cluster.issuer,
						]
						kinds: [
							"Secret",
						]
						namespaces: [
							"cert-manager",
						]
					}
				}]
				generate: {
					synchronize: true
					apiVersion:  "cert-manager.io/v1"
					kind:        "ClusterIssuer"
					name:        cluster.issuer
					data: spec: acme: {
						server: "https://acme.zerossl.com/v2/DV90"
						email:  "{{request.object.data.zerossl_email | base64_decode(@)}}"

						privateKeySecretRef: name: "\(cluster.issuer)-acme"

						externalAccountBinding: {
							keyID: "{{request.object.data.zerossl_eab_kid | base64_decode(@)}}"
							keySecretRef: {
								name: cluster.issuer
								key:  "zerossl_eab_hmac"
							}
						}

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: cluster.issuer
									key:  "cloudflare_api_token"
								}
							}
						}]
					}
				}
			}]
		}
	}
}

// https://doc.traefik.io/traefik/routing/providers/kubernetes-ingress/
// https://artifacthub.io/packages/helm/traefik/traefik
kustomize: "traefik": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "traefik"

	helm: {
		release:   "traefik"
		name:      "traefik"
		namespace: "traefik"
		version:   "24.0.0"
		repo:      "https://traefik.github.io/charts"
		values: {
			logs: general: level:  "DEBUG"
			logs: access: enabled: true
			providers: kubernetesIngress: {
				publishedService: enabled: true
				allowExternalNameServices: true
			}

			providers: kubernetesCRD: {
				allowExternalNameServices: true
				allowCrossNamespace:       true
			}
		}
	}

	resource: "namespace-traefik": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "traefik"
		}
	}

	resource: "tlsstore-traefik": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "TLSStore"
		metadata: {
			name:      "default"
			namespace: "traefik"
		}

		spec: defaultCertificate: secretName: "\(cluster.domain_slug)-wildcard"
	}

	resource: "serverstransport-insecure": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "ServersTransport"
		metadata: {
			name:      "insecure"
			namespace: "traefik"
		}
		spec: insecureSkipVerify: true
	}

	resource: "ingressroute-http-to-https": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      "traefik-http-to-https"
			namespace: "traefik"
		}
		spec: entryPoints: ["web"]
		spec: routes: [{
			match: "HostRegexp(`{subdomain:[a-z0-9-]+}.\(cluster.domain_name)`)"
			kind:  "Rule"
			services: [{
				name: "noop@internal"
				kind: "TraefikService"
			}]
			middlewares: [{
				name: "http-to-https"
			}]
		}]
	}

	psm: "ingressroute-traefik-dashboard": {
		apiVersion: "traefik.io/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      "traefik-dashboard"
			namespace: "traefik"
		}
		spec: entryPoints: ["websecure"]
		spec: routes: [{
			match: "Host(`traefik.\(cluster.domain_name)`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
			kind:  "Rule"
			services: [{
				name: "api@internal"
				kind: "TraefikService"
			}]
			middlewares: [{
				name: "http-to-https"
			}]
		}]
	}

	resource: "middleware-http-to-https": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "Middleware"
		metadata: name: "http-to-https"
		spec: redirectScheme: {
			scheme:    "https"
			permanent: false
		}
	}

	psm: "service-tailscale": {
		apiVersion: "v1"
		kind:       "Service"

		metadata: {
			name:      "traefik"
			namespace: "traefik"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname": "traefik.\(cluster.domain_name)"
			}
		}

		spec: {
			type: "LoadBalancer"
		}
	}

	resource: "certificate-\(cluster.domain_slug)-wildcard-traefik": {
		apiVersion: "cert-manager.io/v1"
		kind:       "Certificate"
		metadata: {
			name:      "\(cluster.domain_slug)-wildcard"
			namespace: "traefik"
		}
		spec: {
			secretName: "\(cluster.domain_slug)-wildcard"
			dnsNames: [
				"*.\(cluster.domain_name)",
				"*.default.\(cluster.domain_name)",
			]
			issuerRef: {
				name:  cluster.issuer
				kind:  "ClusterIssuer"
				group: "cert-manager.io"
			}
		}
	}
}

kustomize: "ubuntu": #Kustomize & {
	namespace: "default"

	resource: "deployment": {
		apiVersion: "batch/v1"
		kind:       "Job"
		metadata: name: "ubuntu"
		spec: {
			backoffLimit: 3
			template: {
				metadata: labels: app: "ubuntu"
				spec: {
					serviceAccountName: "ubuntu"
					restartPolicy:      "Never"
					//runtimeClassName: "sysbox-runc"
					containers: [{
						name:  "ubuntu"
						image: "amazon/aws-cli"
						args: ["sts", "get-caller-identity"]
					}]
				}
			}
		}
	}

	resource: "serviceaccount": {
		apiVersion: "v1"
		kind:       "ServiceAccount"
		metadata: {
			name: "ubuntu"
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::510430971399:role/ro"
		}
	}
}

// https://artifacthub.io/packages/helm/coder-v2/coder
kustomize: "coder": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "coder"

	helm: {
		release:   "coder"
		name:      "coder"
		namespace: "coder"
		version:   "2.1.3"
		repo:      "https://helm.coder.com/v2"
		values: {
			coder: {
				service: type: "ClusterIP"

				env: [{
					name:  "CODER_ACCESS_URL"
					value: "https://coder.\(cluster.domain_name)"
				}]
			}
		}
	}

	resource: "namespace-coder": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "coder"
		}
	}

	resource: "ingress-coder": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "coder"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "coder.\(cluster.domain_name)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "coder.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "coder"
						port: number: 80
					}
				}]
			}]
		}
	}

	resource: "externalsecret-coder": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "coder"
			namespace: "coder"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: cluster.cluster_name
			}]
			target: {
				name:           "coder"
				creationPolicy: "Owner"
			}
		}
	}
}

// linkerd emojivoto
kustomize: "emojivoto": #Kustomize & {
	cluster: #Cluster

	namespace: "emojivoto"

	resource: "emojivoto": {
		url: "https://run.linkerd.io/emojivoto.yml"
	}

	psm: "namespace-emojivoto": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "emojivoto"
			annotations: {
				"linkerd.io/inject": "enabled"
			}
		}
	}

	resource: "ingress-emojivoto": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "emojivoto"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "emojivoto\(cluster.name_suffix)\(cluster.domain_name)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "emojivoto\(cluster.name_suffix)\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "web-svc"
						port: number: 80
					}
				}]
			}]
		}
	}
}
