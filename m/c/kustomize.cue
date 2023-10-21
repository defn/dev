package c

import (
	core "k8s.io/api/core/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"

	"strings"
)

infra_name:        string
infra_alt_name:    string
infra_account_id:  string
infra_k3s_version: string

infra_base: {
	domain_zone: string
	domain_name: string
	domain_slug: string

	secrets_region:   string
	issuer:           string
	cloudflare_email: string
}

infra_vclusters: [...string]

infra: {
	[NAME=string]: infra_base & {
		if strings.HasPrefix(NAME, "vc") {
			cluster_name: "\(parent.cluster_name)-\(NAME)"
			name_suffix:  "-\(NAME)."
			bootstrap: [string]: #BootstrapConfig

			vcluster: vc_machine: cluster_name
		}
	}

	parent: vclusters: [
		for v in infra_vclusters {
			"\(v)"
		},
	]

	"\(infra_name)": {
		cluster_name: infra_name
		bootstrap: [string]: #BootstrapConfig
		vclusters: [...string]
	}

	for i, v in parent.vclusters {
		"\(infra[v].cluster_name)": infra[v]
	}

	parent: infra[infra_name]

	"\(parent.cluster_name)-cluster": parent

	manual: parent

	"\(parent.cluster_name)-manual": manual
}

env: (#Transform & {
	transformer: #TransformK3S

	inputs: "\(infra.parent.cluster_name)-manual": {
		bootstrap: {
			"cert-manager-crds": [1, ""]
			"linkerd-crds": [1, ""]
			"cilium-bootstrap": [1, ""]
		}
	}
}).outputs

kustomize: [string]: cluster: #Cluster | *infra[infra_name]

env: (#Transform & {
	transformer: #TransformK3S

	inputs: "\(infra.parent.cluster_name)-cluster": {
		bootstrap: infra.parent.bootstrap & {
			// bootstrapped
			"cilium": [100, ""]
			"argo-cd": [100, ""]

			for v in infra.parent.vclusters {
				// vclusters
				"\(infra[v].cluster_name)-vcluster": [30, ""]

				// vcluster workloads
				"\(infra[v].cluster_name)-env": [101, ""]
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		for i, v in infra.parent.vclusters {
			"\(infra[v].cluster_name)-vcluster": infra[v].vcluster
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

	resource: "clusterrole-background-controller-node": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: "kyverno:background-controller:node"
		metadata: labels: {
			"app.kubernetes.io/component": "background-controller"
			"app.kubernetes.io/instance":  "kyverno"
			"app.kubernetes.io/part-of":   "kyverno"
		}
		rules: [{
			apiGroups: [""]
			resources: ["nodes"]
			verbs: [ "update", "patch"]
		}]
	}
}

// https://artifacthub.io/packages/helm/linkerd2/linkerd-crds
kustomize: "linkerd-crds": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "linkerd"

	helm: {
		release: "linkerd-crds"
		name:    "linkerd-crds"
		version: "1.8.0"
		repo:    "https://helm.linkerd.io/stable"
		values: {}
	}

	resource: "namespace-linkerd": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "linkerd"
			labels: {
				"linkerd.io/is-control-plane":          "true"
				"linkerd.io/control-plane-ns":          "linkerd"
				"config.linkerd.io/admission-webhooks": "disabled"
			}

			annotations: {
				"linkerd.io/inject": "disabled"
			}
		}
	}
}

// https://artifacthub.io/packages/helm/linkerd2/linkerd-control-plane
kustomize: "linkerd-control-plane": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "linkerd"

	helm: {
		release: "linkerd-control-plane"
		name:    "linkerd-control-plane"
		version: "1.15.0"
		repo:    "https://helm.linkerd.io/stable"
		values: {
			identity: externalCA: true
			identity: issuer: scheme: "kubernetes.io/tls"

			proxyInjector: externalSecret:    true
			profileValidator: externalSecret: true
			policyValidator: externalSecret:  true

			proxyInjector: injectCaFrom:    "linkerd/proxy_injector"
			profileValidator: injectCaFrom: "linkerd/profile_validator"
			policyValidator: injectCaFrom:  "linkerd/policy_validator"
		}
	}
}

// https://artifacthub.io/packages/helm/bitnami/external-dns
kustomize: "external-dns": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "external-dns"

	helm: {
		release: "external-dns"
		name:    "external-dns"
		version: "6.26.5"
		repo:    "https://charts.bitnami.com/bitnami"
		values: {
			logLevel: "debug"
			sources: [
				"service",
				"ingress",
			]
			publishInternalServices: true
			serviceTypeFilter: [
				"ClusterIP",
				"NodePort",
				"LoadBalancer",
				"ExternalName",
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
				extract: key: "\(cluster.cluster_alt_name)-cluster"
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
}

// https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets
kustomize: "external-secrets": #KustomizeHelm & {
	namespace: "external-secrets"

	helm: {
		release: "external-secrets"
		name:    "external-secrets"
		version: "0.9.6"
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
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(infra_account_id):role/\(infra_alt_name)-cluster"
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

kustomize: "karpenter": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "karpenter"

	helm: {
		release:   "karpenter"
		name:      "karpenter"
		namespace: "karpenter"
		version:   "v0.31.1"
		repo:      "oci://public.ecr.aws/karpenter"
		values: {
			controller: env: [{
				name: "AWS_REGION"
				value: "us-west-2"
			}]
		}
	}

	resource: "namespace-karpenter": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "karpenter"
		}
	}

	psm: "config-map-karpenter-global-settings": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name: "karpenter-global-settings"
namespace: "karpenter"
		}
		data: {
			"aws.clusterName":     cluster.cluster_name
			"aws.clusterEndpoint": "https://kubernetes.default.svc.cluster.local:443"
		}
	}

psm: "serviceaccount-karpenter": {
apiVersion: "v1"
kind:       "ServiceAccount"
metadata: {
name: "karpenter"
namespace: "karpenter"
annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(infra_account_id):role/\(infra_alt_name)-cluster"
}
}

	psm: "deployment-karpenter": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name: "karpenter"
namespace: "karpenter"
		}
		spec: replicas: 1
	}

	resource: "cluster-role-binding-admin": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "karpenter-admin"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "admin"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "karpenter"
			namespace: "karpenter"
		}]
	}

	resource: "cluster-role-binding-node": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "karpenter-node"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "system:node"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "karpenter"
			namespace: "karpenter"
		}]
	}

	resource: "cluster-role-binding-boot-strapper": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "karpenter-boot-strapper"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "system:boot-strapper"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "karpenter"
			namespace: "karpenter"
		}]
	}

	resource: "provisioner-default": {
		apiVersion: "karpenter.sh/v1alpha5"
		kind:       "Provisioner"
		metadata: name: "default"
		spec: {
			providerRef: name:      "default"
			consolidation: enabled: true
			startupTaints: [{
				key:    "node.cilium.io/agent-not-ready"
				value:  "true"
				effect: "NoExecute"
			}]
			requirements: [{
				key:      "karpenter.sh/capacity-type"
				operator: "In"
				values: ["spot"]
			}, {
				key:      "kubernetes.io/os"
				operator: "In"
				values: ["linux"]
			}, {
				key:      "kubernetes.io/arch"
				operator: "In"
				values: ["amd64"]
			}, {
				key:      "karpenter.k8s.aws/instance-category"
				operator: "In"
				values: [ "c", "m", "r"]
			}, {
				key:      "karpenter.k8s.aws/instance-generation"
				operator: "Gt"
				values: [ '2']
			}]
			limits: resources: cpu: '8'
		}
	}

	resource: "awsnodetemplate-default": {
		apiVersion: "karpenter.k8s.aws/v1alpha1"
		kind:       "AWSNodeTemplate"
		metadata: name: "default"
		spec: {
			amiFamily: "Custom"

			amiSelector: "karpenter.sh/discovery":           cluster.cluster_name
			subnetSelector: "karpenter.sh/discovery":        cluster.cluster_name
			securityGroupSelector: "karpenter.sh/discovery": cluster.cluster_name

			instanceProfile: infra_alt_name
			blockDeviceMappings: [{
				deviceName: "/dev/sda1"
				ebs: {
					volumeSize:          "40Gi"
					volumeType:          "gp3"
					encrypted:           true
					deleteOnTermination: true
				}
			}]
			userData: """
				MIME-Version: 1.0
				Content-Type: multipart/mixed; boundary="BOUNDARY"
				--BOUNDARY
				Content-Type: text/x-shellscript; charset="us-ascii"
				#!/bin/bash

				set -efu

				cat | sudo -u ubuntu bash <<'EOF'
				cd
				source .bash_profile

				infra_name=\(infra_name)
				sudo $(which tailscale) up --auth-key "$(cd m/pkg/chamber && nix develop --command chamber -b secretsmanager read --quiet ${infra_name} tailscale_authkey)"

				ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
				cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

				TOKEN="$(curl -sSL -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
				instance="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)"
				az="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)"
				container_ip="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4)"

				(cd m/pkg/k3sup && nix develop --command k3sup join --user ubuntu --server-host ${infra_name} --server-user ubuntu --k3s-extra-args "--kubelet-arg provider-id=aws:///${az}/${instance} --node-ip ${container_ip}")
				EOF

				--BOUNDARY

				"""
		}
	}
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

cert_manager_version: "1.13.1"

// https://artifacthub.io/packages/helm/cert-manager/cert-manager
kustomize: "cert-manager-crds": #Kustomize & {
	resource: "cert-manager-crds": {
		url: "https://github.com/cert-manager/cert-manager/releases/download/v\(cert_manager_version)/cert-manager.crds.yaml"
	}
}

kustomize: "cert-manager": #KustomizeHelm & {
	cluster: #Cluster

	helm: {
		release:   "cert-manager"
		name:      "cert-manager"
		namespace: "cert-manager"
		version:   cert_manager_version
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
		url: "https://github.com/cert-manager/cert-manager/releases/download/v\(cert_manager_version)/cert-manager.crds.yaml"
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

// https://artifacthub.io/packages/helm/cert-manager/trust-manager
kustomize: "trust-manager": #KustomizeHelm & {
	cluster: #Cluster

	helm: {
		release:   "trust-manager"
		name:      "trust-manager"
		namespace: "cert-manager"
		version:   "0.6.0"
		repo:      "https://charts.jetstack.io"
		values: {}
	}
}

// https://artifacthub.io/packages/helm/loft/vcluster
#TransformKustomizeVCluster: {
	from: {
		#Input
		vc_name:    string | *from.name
		vc_machine: string | *from.name

		type:        string
		k3s_version: string
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
		version: "0.16.4"
		repo:    "https://charts.loft.sh"

		values: {
			vcluster: image: _in.k3s_version

			fallbackHostDns: true
			multiNamespaceMode: enabled: false
			service: type:               "ClusterIP"

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
}

cilium_common: {
	namespace: "kube-system"

	helm: {
		release:   "cilium"
		name:      "cilium"
		"namespace": namespace
		version:   "1.14.3"
		repo:      "https://helm.cilium.io"
		values: {
			operator: replicas:       1
			envoy: enabled:           true
			nodePort: enabled: true
			cluster: {
				name: infra_cilium_name
				id: infra_cilium_id
			}
			clustermesh: {
				useAPIServer: true
				apiserver: {
					tls: auto: {
						method: "certmanager"
						certManagerIssuerRef: {
							group: "cert-manager.io"
							kind: "ClusterIssuer"
							name: "cilium-ca"
						}
					}
				}
			}
			encryption: {
				enabled: true
				type: "wireguard"
				nodeEncryption: true
			}
			hubble: {
				ui: enabled:    bool | *false
				relay: enabled: true
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

// https://artifacthub.io/packages/helm/cilium/cilium
kustomize: "cilium-bootstrap": #KustomizeHelm & {
	cluster: #Cluster

	cilium_common
}

kustomize: "cilium": #KustomizeHelm & {
	cluster: #Cluster

	cilium_common

	helm: {
		values: {
			hubble: ui: enabled: true
		}
	}

	resource: "ingress-hubble-ui": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "hubble-ui"
			annotations: {
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

// https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml
kustomize: "tailscale": #Kustomize & {
	cluster: #Cluster

	resource: "tailscale": {
		url: "https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml"
	}

	jsp: "secret-operator-oauth-remove": {
		target: {
			version:   "v1"
			kind:      "Secret"
			name:      "operator-oauth"
			namespace: "tailscale"
		}
		patches: [{
			op:    "replace"
			path:  "/metadata/name"
			value: "not-used"
		}]
	}

	jsp: "deployment-operator-increase-logging": {
		target: {
			kind:      "Deployment"
			name:      "operator"
			namespace: "tailscale"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/2/value"
			value: "dev"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/8/value"
			value: "true"
		}, {
			op:   "replace"
			path: "/spec/template/spec/containers/0/volumeMounts/0"
			value: {
				mountPath: "/not-used"
				name:      "not-used"
				readOnly:  true
			}
		}, {
			op:   "add"
			path: "/spec/template/spec/containers/0/volumeMounts/1"
			value: {
				mountPath: "/oauth"
				name:      "oauth"
				readOnly:  true
			}
		}, {
			op:   "replace"
			path: "/spec/template/spec/volumes/0"
			value: {
				name: "not-used"
				secret: secretName: "not-used"
			}
		}, {
			op:   "add"
			path: "/spec/template/spec/volumes/1"
			value: {
				name: "oauth"
				secret: secretName: "operator-oauth-custom"
			}
		}]
	}

	resource: "externalsecret-tailscale": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "operator-oauth-custom"
			namespace: "tailscale"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster.cluster_alt_name)-cluster"
			}]
			target: {
				name:           "operator-oauth-custom"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "clusterrole-tailscale-auth-proxy": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: "tailscale-auth-proxy"
		rules: [{
			apiGroups: [""]
			resources: ["users", "groups"]
			verbs: ["impersonate"]
		}]
	}

	resource: "clusterrolebinding-tailscale-auth-proxy": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "tailscale-auth-proxy"
		subjects: [{
			kind:      "ServiceAccount"
			name:      "operator"
			namespace: "tailscale"
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "tailscale-auth-proxy"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}

	resource: "clusterrolebinding-tailscale-admins": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "tailscale-admins"
		subjects: [{
			kind:     "Group"
			name:     "tag:k8s-admin"
			apiGroup: "rbac.authorization.k8s.io"
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "cluster-admin"
			apiGroup: "rbac.authorization.k8s.io"
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
				extract: key: "\(cluster.cluster_alt_name)-cluster"
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
			match: "Host(`traefik.\(cluster.domain_name)`) || Host(`traefik.tail3884f.ts.net`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
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

	psm: "service-traefik": {
		apiVersion: "v1"
		kind:       "Service"

		metadata: {
			name:      "traefik"
			namespace: "traefik"
			annotations: {
				"external-dns.alpha.kubernetes.io/internal-hostname": "*.\(cluster.domain_name), *.default.\(cluster.domain_name), *.coder.\(cluster.domain_name)"
			}
		}

		spec: {
			type: "ClusterIP"
		}
	}

	resource: "ingress-traefik": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name:      "traefik"
			namespace: "traefik"
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "traefik.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "traefik"
						port: number: 443
					}
				}]
			}]
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
				"*.coder.\(cluster.domain_name)",
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
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(infra_account_id):role/\(infra_alt_name)-cluster"
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
		version:   "2.3.2"
		repo:      "https://helm.coder.com/v2"
		values: {
			coder: {
				service: type: "ClusterIP"

				env: [{
					name:  "CODER_ACCESS_URL"
					value: "https://coder.\(cluster.domain_name)"
				}, {
					name:  "CODER_WILDCARD_ACCESS_URL"
					value: "*.coder.\(cluster.domain_name)"
				}, {
					name:  "CODER_REDIRECT_TO_ACCESS_URL"
					value: "false"
				}, {
					name:  "CODER_UPDATE_CHECK"
					value: "false"
				}, {
					name:  "CODER_TELEMETRY_ENABLE"
					value: "false"
				}, {
					name:  "CODER_TELEMETRY_TRACE"
					value: "false"
				}, {
					name:  "CODER_DERP_SERVER_ENABLE"
					value: "true"
				}, {
					name:  "CODER_DISABLE_PASSWORD_AUTH"
					value: "false"
				}, {
					name:  "CODER_STRICT_TRANSPORT_SECURITY"
					value: "60"
				}, {
					name:  "CODER_EXPERIMENTS"
					value: "dashboard_theme"
				}, {
					name:  "CODER_SCALETEST_JOB_TIMEOUT"
					value: "10m"
				}, {
					name:  "CODER_ENABLE_TERRAFORM_DEBUG_MODE"
					value: "true"
				}, {
					name:  "CODER_SECURE_AUTH_COOKIE"
					value: "true"
				}, {
					name:  "CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS"
					value: "true"
				}, {
					name:  "CODER_OAUTH2_GITHUB_ALLOWED_ORGS"
					value: "defn"
				}, {
					name:  "CODER_OAUTH2_GITHUB_ALLOWED_TEAMS"
					value: "defn/class"
				}, {
					// https://github.com/organizations/defn/settings/applications
					name: "CODER_OAUTH2_GITHUB_CLIENT_ID"
					valueFrom: secretKeyRef: {
						name: "coder"
						key:  "coder_oauth2_github_client_id"
					}
				}, {
					name: "CODER_OAUTH2_GITHUB_CLIENT_SECRET"
					valueFrom: secretKeyRef: {
						name: "coder"
						key:  "coder_oauth2_github_client_secret"
					}
				}, {
					name: "CODER_PG_CONNECTION_URL"
					valueFrom: secretKeyRef: {
						name: "coder"
						key:  "coder_pg_connection_url"
					}
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

	resource: "postgresql": {
		apiVersion: "acid.zalan.do/v1"
		kind:       "postgresql"
		metadata: {
			name: "coder-db"
		}
		spec: {
			teamId: "coder"
			volume: size: "10Gi"
			numberOfInstances: 1
			users: coder: [
				"superuser",
				"createdb",
			]
			databases: coder:    "coder"
			postgresql: version: "15"
		}
	}

	resource: "ingress-coder": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "coder"
			annotations: {
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

	resource: "ingressroute-coder-wildcard": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      "coder-wildcard"
			namespace: "coder"
		}
		spec: entryPoints: ["websecure"]
		spec: routes: [{
			match: "HostRegexp(`{subdomain:[a-z0-9-]+}.coder.\(cluster.domain_name)`)"
			kind:  "Rule"
			services: [{
				name:      "coder"
				namespace: "coder"
				kind:      "Service"
				port:      80
				scheme:    "http"
			}]
		}]
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
				extract: key: "\(cluster.cluster_alt_name)-cluster"
			}]
			target: {
				name:           "coder"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "cluster-role-binding-admin": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "coder"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "cluster-admin"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "coder"
			namespace: "coder"
		}]
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

// https://github.com/GalleyBytes/terraform-operator/releases
kustomize: "tfo": #Kustomize & {
	namespace: "tf-system"

	resource: "tfo": {
		url: "https://raw.githubusercontent.com/GalleyBytes/terraform-operator/master/deploy/bundles/v0.13.3/v0.13.3.yaml"
	}
}

// https://artifacthub.io/packages/helm/mojo2600/pihole
kustomize: "pihole": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "pihole"

	helm: {
		release:   "pihole"
		name:      "pihole"
		namespace: "pihole"
		version:   "2.18.0"
		repo:      "https://mojo2600.github.io/pihole-kubernetes"
		values: {
			podDnsConfig: enabled:          false
			persistentVolumeClaim: enabled: true
			serviceDns: type:               "ClusterIP"
			serviceDns: mixedService:       true
			serviceDhcp: enabled:           false
			serviceWeb: https: enabled: false
			DNS1: "10.43.0.10"
			DNS2: "10.43.0.10"
		}
	}

	resource: "namespace-pihole": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "pihole"
		}
	}

	resource: "ingress-pihole-web": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "pihole-web"
			annotations: {
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "pihole.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "pihole-web"
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
			name: "pihole-dns"
		}
		spec: clusterIP: "10.43.53.53"
	}
}

// https://artifacthub.io/packages/helm/argo/argo-events
kustomize: "argo-events": #KustomizeHelm & {
	namespace: "argo-events"

	helm: {
		release: "argo-events"
		name:    "argo-events"
		version: "2.4.1"
		repo:    "https://argoproj.github.io/argo-helm"
	}

	resource: "namespace-argo-events": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argo-events"
		}
	}
}

// https://artifacthub.io/packages/helm/argo/argo-workflows
kustomize: "argo-workflows": #KustomizeHelm & {
	helm: {
		release:   "argo-workflows"
		name:      "argo-workflows"
		namespace: "argo-workflows"
		version:   "0.36.1"
		repo:      "https://argoproj.github.io/argo-helm"
		values: {
			controller: workflowNamespaces: [
				"argo-workflows",
				"default",
			]
		}
	}

	resource: "namespace-argo-workflows": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argo-workflows"
		}
	}
}

#Pattern: [string]: {...}

// https://artifacthub.io/packages/helm/bitnami/mastodon
kustomize: "mastodon": #Pattern["mastodon"] & {
	namespace: "mastodon"
}

kustomize: "famfan": #Pattern["mastodon"] & {
	namespace: "famfan"
}

#Pattern: "mastodon": #KustomizeHelm & {
	cluster: #Cluster

	namespace: string

	helm: {
		release:     "mastodon"
		name:        "mastodon"
		"namespace": namespace
		version:     "3.0.5"
		repo:        "https://charts.bitnami.com/bitnami"
		values: {
			initJob: createAdmin: true
			adminUser:          "defn"
			adminEmail:         "iam@defn.sh"
			webDomain:          "\(namespace).\(cluster.domain_name)"
			useSecureWebSocket: true
			existingSecret:     "mastodon-default"
			smtp: existingSecret: "mastodon-smtp"
			redis: auth: existingSecret:      "mastodon-redis"
			postgresql: auth: existingSecret: "mastodon-postgresql"
			minio: auth: existingSecret:      "mastodon-minio"
		}
	}

	resource: "namespace": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: namespace
		}
	}

	psm: "service-mastodon-apache": {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name:        "mastodon-apache"
			"namespace": namespace
		}
		spec: {
			type:                  "ClusterIP"
			externalTrafficPolicy: null
		}
	}

	resource: "ingress-mastodon-apache": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "mastodon-apache"
			annotations: {
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "\(namespace).\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "mastodon-apache"
						port: number: 80
					}
				}]
			}]
		}
	}

	psm: "job-mastodon-init": {
		apiVersion: "batch/v1"
		kind:       "Job"
		metadata: {
			name:        "mastodon-init"
			"namespace": namespace
			annotations: {
				"argocd.argoproj.io/hook":               "Sync"
				"argocd.argoproj.io/sync-wave":          "0"
				"argocd.argoproj.io/hook-delete-policy": "BeforeHookCreation,HookSucceeded"
			}
		}
	}
	// k exec -ti -n mastodon deploy/mastodon-web -- bash -c '. /opt/bitnami/scripts/mastodon-env.sh; tootctl accounts  modify defn --reset-password'

	resource: "externalsecret-default": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: name: "mastodon-default"
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			target: {
				name:           "mastodon-default"
				creationPolicy: "Owner"
			}
			data: [{
				secretKey: "MASTODON_ADMIN_PASSWORD"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_admin_password"
			}, {
				secretKey: "OTP_SECRET"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_otp_secret"
			}, {
				secretKey: "SECRET_KEY_BASE"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_secret_key_base"
			}]
		}
	}

	resource: "externalsecret-smtp": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: name: "mastodon-smtp"
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			target: {
				name:           "mastodon-smtp"
				creationPolicy: "Owner"
			}
			data: [{
				secretKey: "login"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_smtp_login"
			}, {
				secretKey: "password"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_smtp_password"
			}]
		}
	}

	resource: "externalsecret-minio": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: name: "mastodon-minio"
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			target: {
				name:           "mastodon-minio"
				creationPolicy: "Owner"
			}
			data: [{
				secretKey: "root-password"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_minio_root_password"
			}, {
				secretKey: "root-user"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_minio_root_user"
			}]
		}
	}

	resource: "externalsecret-postgresql": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: name: "mastodon-postgresql"
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			target: {
				name:           "mastodon-postgresql"
				creationPolicy: "Owner"
			}
			data: [{
				secretKey: "password"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_postgresql_password"
			}, {
				secretKey: "postgres-password"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_postgresql_postgres_password"
			}]
		}
	}

	resource: "externalsecret-redis": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: name: "mastodon-redis"
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			target: {
				name:           "mastodon-redis"
				creationPolicy: "Owner"
			}
			data: [{
				secretKey: "redis-password"
				remoteRef: key:      "\(cluster.cluster_alt_name)-cluster"
				remoteRef: property: "\(namespace)_redis_password"
			}]
		}
	}
}

// https://artifacthub.io/packages/helm/headlamp/headlamp
kustomize: "headlamp": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "headlamp"

	helm: {
		release:   "headlamp"
		name:      "headlamp"
		namespace: "headlamp"
		version:   "0.16.0"
		repo:      "https://headlamp-k8s.github.io/headlamp"
		values: {
		}
	}

	resource: "namespace-headlamp": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "headlamp"
		}
	}

	resource: "ingress-headlamp": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "headlamp"
			annotations: {
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "tailscale"
			defaultBackend: service: {
				name: "headlamp"
				port: number: 80
			}
			tls: [{
				hosts: [
					"headlamp",
				]
			}]
		}
	}

	resource: "serviceaccount-headlamp-admin": {
		apiVersion: "v1"
		kind:       "ServiceAccount"
		metadata: {
			name: "headlamp-admin"
		}
	}

	resource: "cluster-role-binding-headlamp-admin": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "headlamp-admin-binding"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "cluster-admin"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "headlamp-admin"
			namespace: "headlamp"
		}]
	}
}

// https://artifacthub.io/packages/helm/dex/dex
kustomize: "dex": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "dex"

	helm: {
		release:   "dex"
		name:      "dex"
		namespace: "dex"
		version:   "0.15.3"
		repo:      "https://charts.dexidp.io"
		values: {
			config: {
				issuer: "https://dex.\(cluster.domain_name)"
				storage: type: "memory"
				enablePasswordDB: true

				connectors: [{
					type: "github"
					id:   "github"
					name: "GitHub"
					config: {
						clientID:     "$GITHUB_CLIENT_ID"
						clientSecret: "$GITHUB_CLIENT_SECRET"
						redirectURI:  "https://dex.dev.amanibhavam.defn.run/callback"

						orgs: [{
							name: "defn"
							teams: [
								"class",
							]
						}]

						teamNameField: "slug"
						loadAllGroups: false
						useLoginAsID:  false
					}
				}]
			}
		}
	}

	resource: "namespace-dex": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "dex"
		}
	}

	resource: "ingress-dex": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "dex"
			annotations: {
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "dex.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "dex"
						port: number: 5556
					}
				}]
			}]
		}
	}
}

kustomize: "postgres-operator": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "postgres-operator"

	helm: {
		release:   "postgres-operator"
		name:      "postgres-operator"
		namespace: "postgres-operator"
		version:   "1.10.1"
		repo:      "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
		values: {}
	}

	resource: "namespace": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "postgres-operator"
		}
	}
}
