package c

import (
	"encoding/yaml"
)

class: #Cluster

infra: {
	[NAME=string]: class

	"\(class.cluster_name)-cluster": {}
}

kustomize: [string]: cluster: class

env: (#Transform & {
	transformer: #TransformK3S

	inputs: "\(class.cluster_name)-cluster": {
		bootstrap:   class.bootstrap
		app_cluster: "coder-\(class.handle)-\(class.parent_env)-cluster"
		app_repo:    "coder-amanibhavam-district.tail3884f.ts.net:5000"
		app_type:    "chart"
		app_def:     "library/helm/coder-\(class.handle)-\(class.env)-cluster-env"
	}
}).outputs

kustomize: "coder-\(class.handle)-\(class.env)-cluster-env": #KustomizeHelm & {
	helm: {
		release: "bootstrap"
		name:    "any-resource"
		version: "0.1.0"
		repo:    "https://kiwigrid.github.io"
		values: {
			anyResources: {
				for _app_name, _app in bootstrap["coder-\(class.handle)-\(class.env)-cluster-env"].apps {
					(_app_name): yaml.Marshal(_app.application)
				}
			}
		}
	}
}

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

kustomize: "coredns": #Kustomize & {
	cluster: #Cluster

	resource: "configmap-coredns-custom": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "coredns-custom"
			namespace: "kube-system"
		}
		data: {
			"tailscale-dns.server": """
				ts.net:53 {
					forward . 100.100.100.100
				}
				"""
		}
	}
}

kustomize: "argo-cd": #Kustomize & {
	cluster: #Cluster

	namespace: "argocd"

	resource: "namespace-argocd": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argocd"
		}
	}

	resource: "argo-cd": {
		url: "https://raw.githubusercontent.com/argoproj/argo-cd/v2.10.0-rc4/manifests/install.yaml"
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
				if cluster.parent_env == cluster.env {
					host: "argocd.\(cluster.domain_name)"
				}
				if cluster.parent_env != cluster.env {
					host: "argocd-\(cluster.env).\(cluster.domain_name)"
				}
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

	psm: "configmap-argocd-cmd-params-cm": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "argocd-cmd-params-cm"
		data: {
			"server.insecure":   "true"
			"redis.compression": "none"
			"server.log.level":  "info"
			"exec.enabled":      "true"
		}
	}

	psm: "configmap-argocd-rbac-cm": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "argocd-rbac-cm"
		data: {
			"policy.default": ""
			"policy.csv": """
				g, defn:dev, role:admin
				"""
		}
	}

	resource: "externalsecret-dex-github-oidc": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name: "dex-github-oidc"
			labels: "app.kubernetes.io/part-of": "argocd"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			data: [{
				secretKey: "clientID"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "dex_github_client_id"
			}, {
				secretKey: "clientSecret"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "dex_github_client_secret"
			}]
		}
	}
	psm: "configmap-argocd-cm": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "argocd-cm"
		data: {
			"kustomize.buildOptions": "--enable-helm"

			"application.resourceTrackingMethod": "annotation"

			#connectors: connectors: [{
				type: "github"
				id:   "github"
				name: "GitHub"
				config: {
					clientID:     "$dex-github-oidc:clientID"
					clientSecret: "$dex-github-oidc:clientSecret"
					orgs: [{
						name: "defn"
						teams: ["dev"]
					}]
				}
			}]

			"admin.enabled": "false"

			"dex.config": yaml.Marshal(#connectors)

			if cluster.parent_env == cluster.env {
				url: "https://argocd.\(cluster.domain_name)"
			}
			if cluster.parent_env != cluster.env {
				url: "https://argocd-\(cluster.env).\(cluster.domain_name)"
			}

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
		version: "3.0.9"
		repo:    "https://kyverno.github.io/kyverno"
		values: {
			replicaCount: 1
		}
	}

	resource: "namespace-kyverno": {
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
			verbs: ["create", "update", "patch", "delete"]
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
			verbs: ["update", "patch"]
		}]
	}
}

// https://artifacthub.io/packages/helm/linkerd2/linkerd-crds
// https://artifacthub.io/packages/helm/linkerd2-edge/linkerd-crds
kustomize: "l5d-crds": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "linkerd"

	helm: {
		release: "l5d-crds"
		name:    "linkerd-crds"
		version: "1.9.3-edge"
		repo:    "https://helm.linkerd.io/edge"
		values: {}
	}

	resource: "namespace-linkerd": {
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
// https://artifacthub.io/packages/helm/linkerd2-edge/linkerd-control-plane
kustomize: "l5d-control": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "linkerd"

	helm: {
		release: "l5d-control"
		name:    "linkerd-control-plane"
		version: "1.18.9-edge"
		repo:    "https://helm.linkerd.io/edge"
		values: {
			heartbeatSchedule: "0 0 * * *"

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
		version: "6.33.0"
		repo:    "https://charts.bitnami.com/bitnami"
		values: {
			logLevel: "info"
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

	resource: "namespace-external-dns": {
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
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "external-dns"
				creationPolicy: "Owner"
			}
		}
	}
}

// https://github.com/knative-extensions/net-kourier/releases
kustomize: "kourier": #Kustomize & {
	cluster: #Cluster

	resource: "kourier": {
		url: "https://github.com/knative-extensions/net-kourier/releases/download/knative-v1.13.0/kourier.yaml"
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
		version: "0.9.13"
		repo:    "https://charts.external-secrets.io"
		values: {
			webhook: create:        false
			certController: create: false
		}
	}

	resource: "namespace-external-secrets": {
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
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(class.infra_account_id):role/\(class.cluster_name)-cluster"
		}
	}

	resource: "cluster-role-binding-delegator": {
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

// https://github.com/buildkite/agent-stack-k8s
kustomize: "buildkite": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "buildkite"

	helm: {
		release:   "buildkite"
		name:      "agent-stack-k8s"
		namespace: "buildkite"
		version:   "0.7.0"
		repo:      "oci://ghcr.io/buildkite/helm"
		values: {
			config: {
				org:            "defn"
				"cluster-uuid": "bd52647a-d3d5-4c15-9b3f-3b5f566ce6e3"
				debug:          true
				tags: ["queue=default"]
				image:           "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:buildkite"
				"max-in-flight": 0
			}
			agentStackSecret: "buildkite"
		}
	}

	resource: "namespace-buildkite": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "buildkite"
		}
	}

	resource: "externalsecret-buildkite": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "buildkite"
			namespace: "buildkite"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			data: [{
				secretKey: "BUILDKITE_TOKEN"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: secretKey
			}, {
				secretKey: "BUILDKITE_AGENT_TOKEN"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: secretKey
			}]
		}
	}
}

// https://github.com/aws/karpenter-provider-aws/releases
kustomize: "karpenter": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "karpenter"

	helm: {
		release:   "karpenter"
		name:      "karpenter"
		namespace: "karpenter"
		version:   "v0.34.0"
		repo:      "oci://public.ecr.aws/karpenter"
		values: {
			settings: {
				clusterName:     cluster.cluster_name
				clusterEndpoint: "https://kubernetes.default.svc.cluster.local:443"
			}
			controller: env: [{
				name:  "AWS_REGION"
				value: "us-west-2"
			}]
		}
	}

	resource: "namespace-karpenter": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "karpenter"
		}
	}

	psm: "serviceaccount-karpenter": {
		apiVersion: "v1"
		kind:       "ServiceAccount"
		metadata: {
			name:      "karpenter"
			namespace: "karpenter"
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(class.infra_account_id):role/\(class.cluster_name)-cluster"
		}
	}

	psm: "deployment-karpenter": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "karpenter"
			namespace: "karpenter"
		}
		spec: replicas: 1
	}

	resource: "cluster-role-binding-admin": {
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

	resource: "cluster-role-binding-node": {
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

	resource: "cluster-role-binding-boot-strapper": {
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

	#resource: "provisioner-default": {
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
				values: ["c", "m", "r"]
			}, {
				key:      "karpenter.k8s.aws/instance-generation"
				operator: "Gt"
				values: ['2']
			}]
			limits: resources: cpu: '8'
		}
	}

	#resource: "awsnodetemplate-default": {
		apiVersion: "karpenter.k8s.aws/v1alpha1"
		kind:       "AWSNodeTemplate"
		metadata: name: "default"
		spec: {
			amiFamily: "Custom"

			amiSelector: "karpenter.sh/discovery":           cluster.cluster_name
			subnetSelector: "karpenter.sh/discovery":        cluster.cluster_name
			securityGroupSelector: "karpenter.sh/discovery": cluster.cluster_name

			instanceProfile: class.cluster_name
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

				cluster_name=\(class.cluster_name)
				sudo $(which tailscale) up --auth-key "$(cd m/pkg/chamber && nix develop --command chamber -b secretsmanager read --quiet ${cluster_name} tailscale_authkey)"

				ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
				cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

				TOKEN="$(curl -sSL -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
				instance="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)"
				az="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)"
				container_ip="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4)"

				(cd m/pkg/k3sup && nix develop --command k3sup join --user ubuntu --server-host ${cluster_name} --server-user ubuntu --k3s-extra-args "--kubelet-arg provider-id=aws:///${az}/${instance} --node-ip ${container_ip}")
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
		url: "https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-core.yaml"
	}

	psm: "namespace-knative-serving": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "knative-serving"
		}
	}

	psm: "deployment-webhook": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "webhook"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-controller": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "controller"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-autoscaler": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "autoscaler"
			namespace: "knative-serving"
		}
	}

	psm: "deployment-activator": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "activator"
			namespace: "knative-serving"
		}
	}

	psm: "config-map-config-defaults": {
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

	psm: "config-map-config-domain": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-domain"
			namespace: "knative-serving"
		}
		data: (cluster.domain_name): ""
	}

	psm: "config-map-config-features": {
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

	psm: "config-map-config-network": {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "config-network"
			namespace: "knative-serving"
		}
		data: "ingress.class": "kourier.ingress.networking.knative.dev"
	}
}

cert_manager_version: "1.14.2"

// https://artifacthub.io/packages/helm/cert-manager/cert-manager
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

			dns01RecursiveNameservers:     "1.1.1.1:53"
			dns01RecursiveNameserversOnly: true
		}
	}

	resource: "cert-manager-crds": {
		url: "https://github.com/cert-manager/cert-manager/releases/download/v\(cert_manager_version)/cert-manager.crds.yaml"
	}

	resource: "namespace-cert-manager": {
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
		version:   "0.8.0"
		repo:      "https://charts.jetstack.io"
		values: {}
	}
}

// https://artifacthub.io/packages/helm/cilium/cilium
cilium_common: {
	helm: {
		release:   "cilium"
		name:      "cilium"
		namespace: "kube-system"
		version:   "1.15.1"
		repo:      "https://helm.cilium.io"
		values: {
			operator: {
				replicas:    1
				rollOutPods: true
			}

			ipam: operator: clusterPoolIPv4PodCIDRList: class.infra_pod_cidr

			kubeProxyReplacement: false
			//k8sServiceHost:       class.cluster_ip
			//k8sServicePort:       "6556"

			loadBalancer: algorithm: "maglev"
			socketLB: enabled:       true
			bpf: {
				lbExternalClusterIP: true
				masquerade:          true
			}

			nodePort: enabled:          true
			hostPort: enabled:          true
			hostFirewall: enabled:      true
			externalWorkloads: enabled: true
			externalIPs: enabled:       true

			ingressController: enabled: false

			rollOutCiliumPods: true

			cluster: {
				name: class.infra_cilium_name
				id:   class.infra_cilium_id
			}
			clustermesh: {
				useAPIServer: true
				apiserver: {
					service: type: "ClusterIP"
					tls: auto: {
						method: "certmanager"
						certManagerIssuerRef: {
							group: "cert-manager.io"
							kind:  "ClusterIssuer"
							name:  "cilium-ca"
						}
					}
				}
			}
			authentication: {
				mutual: spire: {
					enabled: false
					install: enabled: false
				}
			}
			encryption: {
				type:           "wireguard"
				enabled:        false
				nodeEncryption: false
			}
			envoy: {
				enabled:     true
				rollOutPods: true
			}
			hubble: {
				ui: {
					enabled:     bool | *false
					rollOutPods: true
				}
				relay: {
					enabled:     true
					rollOutPods: true
				}
				tls: auto: {
					enabled: true
					method:  "certmanager"
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
			name:      "hubble-ui"
			namespace: "kube-system"
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

// https://artifacthub.io/packages/helm/cilium/tetragon
kustomize: "tetragon": #KustomizeHelm & {
	helm: {
		release:   "tetragon"
		name:      "tetragon"
		namespace: "kube-system"
		version:   "1.0.2"
		repo:      "https://helm.cilium.io"
		values: {
		}
	}
}

// https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/deploy/manifests/operator.yaml
kustomize: "tailscale": #Kustomize & {
	cluster: #Cluster

	#version: "v1.60.0"

	resource: "tailscale-operator": {
		url: "https://raw.githubusercontent.com/tailscale/tailscale/\(#version)/cmd/k8s-operator/deploy/manifests/operator.yaml"
	}

	resource: "tailscale-rbac": {
		url: "https://raw.githubusercontent.com/tailscale/tailscale/\(#version)/cmd/k8s-operator/deploy/manifests/authproxy-rbac.yaml"
	}

	jsp: "deployment-operator-increase-logging": {
		target: {
			kind:      "Deployment"
			name:      "operator"
			namespace: "tailscale"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/1/value"
			value: "\(cluster.cluster_name)-proxy3"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/3/value"
			value: "dev"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/9/value"
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
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "operator-oauth-custom"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "clusterrolebinding-tailscale-admins": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "tailscale-admins-cluster-admin"
		subjects: [{
			kind:     "Group"
			name:     "tailscale-admins"
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

	resource: "externalsecret-zerossl-production": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "zerossl-production"
			namespace: "cert-manager"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "zerossl-production"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "externalsecret-letsencrypt-staging": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "letsencrypt-staging"
			namespace: "cert-manager"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "letsencrypt-staging"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "externalsecret-letsencrypt-production": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "letsencrypt-production"
			namespace: "cert-manager"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "letsencrypt-production"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "clusterpolicy-clusterissuer-zerossl-production": {
		#clusterissuer_name: "zerossl-production"
		apiVersion:          "kyverno.io/v1"
		kind:                "ClusterPolicy"
		metadata: name: "\(#clusterissuer_name)-clusterissuer"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-cluster-issuer"
				match: any: [{
					resources: {
						names: [
							#clusterissuer_name,
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
					name:        #clusterissuer_name
					data: metadata: annotations: {
						"argocd.argoproj.io/tracking-id":  "\(cluster.cluster_name)-cluster-issuer:kyverno.io/ClusterPolicy:/\(#clusterissuer_name)-clusterissuer"
						"argocd.argoproj.io/sync-options": "Prune=false"
					}
					data: spec: acme: {
						server: "https://acme.zerossl.com/v2/DV90"
						email:  "{{request.object.data.zerossl_email | base64_decode(@)}}"

						privateKeySecretRef: name: "\(#clusterissuer_name)-acme"

						externalAccountBinding: {
							keyID: "{{request.object.data.zerossl_eab_kid | base64_decode(@)}}"
							keySecretRef: {
								name: #clusterissuer_name
								key:  "zerossl_eab_hmac"
							}
						}

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: #clusterissuer_name
									key:  "cloudflare_api_token"
								}
							}
						}]
					}
				}
			}]
		}
	}

	resource: "clusterpolicy-clusterissuer-letsencrypt-staging": {
		#clusterissuer_name: "letsencrypt-staging"
		apiVersion:          "kyverno.io/v1"
		kind:                "ClusterPolicy"
		metadata: name: "\(#clusterissuer_name)-clusterissuer"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-cluster-issuer"
				match: any: [{
					resources: {
						names: [
							#clusterissuer_name,
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
					name:        #clusterissuer_name
					data: metadata: annotations: {
						"argocd.argoproj.io/tracking-id":  "\(cluster.cluster_name)-cluster-issuer:kyverno.io/ClusterPolicy:/\(#clusterissuer_name)-clusterissuer"
						"argocd.argoproj.io/sync-options": "Prune=false"
					}
					data: spec: acme: {
						server: "https://acme-staging-v02.api.letsencrypt.org/directory"
						email:  "{{request.object.data.zerossl_email | base64_decode(@)}}"

						privateKeySecretRef: name: "\(#clusterissuer_name)-acme"

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: #clusterissuer_name
									key:  "cloudflare_api_token"
								}
							}
						}]
					}
				}
			}]
		}
	}

	resource: "clusterpolicy-clusterissuer-letsencrypt-production": {
		#clusterissuer_name: "letsencrypt-production"
		apiVersion:          "kyverno.io/v1"
		kind:                "ClusterPolicy"
		metadata: name: "\(#clusterissuer_name)-clusterissuer"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-cluster-issuer"
				match: any: [{
					resources: {
						names: [
							#clusterissuer_name,
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
					name:        #clusterissuer_name
					data: metadata: annotations: {
						"argocd.argoproj.io/tracking-id":  "\(cluster.cluster_name)-cluster-issuer:kyverno.io/ClusterPolicy:/\(#clusterissuer_name)-clusterissuer"
						"argocd.argoproj.io/sync-options": "Prune=false"
					}
					data: spec: acme: {
						server: "https://acme-v02.api.letsencrypt.org/directory"
						email:  "{{request.object.data.zerossl_email | base64_decode(@)}}"

						privateKeySecretRef: name: "\(#clusterissuer_name)-acme"

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: #clusterissuer_name
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
		version:   "26.1.0"
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

	resource: "namespace-traefik": {
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
				"external-dns.alpha.kubernetes.io/target":            "100.113.64.80"
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
			annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::\(class.infra_account_id):role/\(class.cluster_name)-cluster"
		}
	}
}

// https://artifacthub.io/packages/helm/coder-v2/coder
resource: "coder-global": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "coder-global"
		annotations: "io.cilium/global-service": "true"
	}
	spec: {
		type: "ClusterIP"
		ports: [{
			name:       "http"
			port:       "80"
			protocol:   "TCP"
			targetPort: "http"
		}]
		selector: {
			"app.kubernetes.io/instance": "coder"
			"app.kubernetes.io/name":     "coder"
		}
	}
}

kustomize: "coder": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "coder"

	helm: {
		release:   "coder"
		name:      "coder"
		namespace: "coder"
		version:   "2.8.3"
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
						name: "coder.coder-db.connection-url"
						key:  "coder_pg_connection_url"
					}
				}]
			}
		}
	}

	resource: "namespace-coder": {
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

	resource: "clusterpolicy-create-secret-coder-connection-url": {
		apiVersion: "kyverno.io/v1"
		kind:       "ClusterPolicy"
		metadata: name: "coder-connection-url"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-secret-coder-connection-url"
				match: any: [{
					resources: {
						names: [
							"coder.coder-db.credentials.postgresql.acid.zalan.do",
						]
						kinds: [
							"Secret",
						]
						namespaces: [
							"coder",
						]
					}
				}]
				generate: {
					synchronize: true
					apiVersion:  "v1"
					kind:        "Secret"
					name:        "coder.coder-db.connection-url"
					namespace:   "coder"
					data: {
						type: "Opaque"
						stringData: {
							"coder_pg_connection_url": "postgresql://{{request.object.data.username | base64_decode(@)}}:{{request.object.data.password | base64_decode(@)}}@coder-db:5432/coder?sslmode=require"
						}
					}
				}
			}]
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
				extract: key: "\(cluster.cluster_name)-cluster"
			}]
			target: {
				name:           "coder"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "cluster-role-binding-admin": {
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

// emojivoto
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
		url: "https://raw.githubusercontent.com/GalleyBytes/terraform-operator/master/deploy/bundles/v0.16.0/v0.16.0.yaml"
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
		version:   "2.22.0"
		repo:      "https://mojo2600.github.io/pihole-kubernetes"
		values: {
			podDnsConfig: enabled:          false
			persistentVolumeClaim: enabled: true
			serviceDns: type:               "ClusterIP"
			serviceDns: mixedService:       true
			serviceDhcp: enabled:           false
			serviceWeb: https: enabled: false
			DNS1: "\(cluster.infra_cidr_16).128.10"
			DNS2: "\(cluster.infra_cidr_16).128.10"
		}
	}

	resource: "namespace-pihole": {
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
		spec: clusterIP: "\(cluster.infra_cidr_16).128.53"
	}
}

// https://artifacthub.io/packages/helm/argo/argo-events
kustomize: "argo-events": #KustomizeHelm & {
	namespace: "argo-events"

	helm: {
		release: "argo-events"
		name:    "argo-events"
		version: "2.4.3"
		repo:    "https://argoproj.github.io/argo-helm"
	}

	resource: "namespace-argo-events": {
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
		version:   "0.40.11"
		repo:      "https://argoproj.github.io/argo-helm"
		values: {
			controller: workflowNamespaces: [
				"argo-workflows",
				"default",
			]
		}
	}

	resource: "namespace-argo-workflows": {
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
		version:     "4.4.0"
		repo:        "https://charts.bitnami.com/bitnami"
		values: {
			initJob: createAdmin: true
			adminUser:            "defn"
			adminEmail:           "iam@defn.sh"
			webDomain:            "\(namespace).\(cluster.domain_name)"
			useSecureWebSocket:   true
			forceHttpsS3Protocol: true
			existingSecret:       "mastodon-default"
			smtp: existingSecret: "mastodon-smtp"
			redis: auth: existingSecret:      "mastodon-redis"
			postgresql: auth: existingSecret: "mastodon-postgresql"
			minio: auth: existingSecret:      "mastodon-minio"
		}
	}

	resource: "namespace": {
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
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_admin_password"
			}, {
				secretKey: "OTP_SECRET"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_otp_secret"
			}, {
				secretKey: "SECRET_KEY_BASE"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
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
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_smtp_login"
			}, {
				secretKey: "password"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_smtp_password"
			}, {
				secretKey: "server"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_smtp_server"
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
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_minio_root_password"
			}, {
				secretKey: "root-user"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
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
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
				remoteRef: property: "\(namespace)_postgresql_password"
			}, {
				secretKey: "postgres-password"
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
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
				remoteRef: key:      "\(cluster.cluster_name)-cluster"
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
		version:   "0.18.2"
		repo:      "https://headlamp-k8s.github.io/headlamp"
		values: {
		}
	}

	resource: "namespace-headlamp": {
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
			ingressClassName: "traefik"
			rules: [{
				host: "headlamp.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "headlamp"
						port: number: 80
					}
				}]
			}]
		}
	}

	#resource: "ingress-headlamp": {
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

	resource: "cluster-role-binding-headlamp-admin": {
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
		version:   "0.16.0"
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

	resource: "namespace-dex": {
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

	resource: "namespace": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "postgres-operator"
		}
	}
}

// https://artifacthub.io/packages/helm/harbor/harbor
#external_secrets_data: {
	input: {
		secret: string
		keys: [...string]
	}
	output: data: [
		for a in input.keys {
			{
				secretKey: a
				remoteRef: {
					key:      input.secret
					property: secretKey
					if property == "tls.crt" || property == "tls.key" {
						decodingStrategy: "Base64"
					}
				}
			}
		},
	]
}

kustomize: "harbor": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "harbor"

	helm: {
		release: "harbor"
		name:    "harbor"
		version: "1.14.0"
		repo:    "https://helm.goharbor.io"
		values: {
			expose: {
				ingress: hosts: core: "harbor.\(cluster.domain_name)"
				tls: {
					enabled:    true
					certSource: "none"
				}
			}
			externalURL: "https://\(expose.ingress.hosts.core)"

			existingSecretAdminPassword:    "external-harbor-admin"
			existingSecretAdminPasswordKey: "harbor_admin_password"

			trivy: enabled: true
		}
	}

	resource: "namespace-harbor": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "harbor"
		}
	}

	#secrets: ["core", "jobservice", "registry", "registry-htpasswd", "registryctl", "trivy", "database"]
	for s in #secrets {
		jsp: "secret-harbor-\(s)": {
			target: {
				kind: "Secret"
				name: "harbor-\(s)"
			}
			patches: [{
				op:    "replace"
				path:  "/metadata/name"
				value: "ignore-\(s)"
			}, {
				op:   "remove"
				path: "/data"
			}]
		}
	}

	jsp: "deployment-harbor-core": {
		target: {
			kind: "Deployment"
			name: "harbor-core"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret-jobservice"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/0/valueFrom/secretKeyRef/name"
			value: "external-harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/1/valueFrom/secretKeyRef/name"
			value: "external-harbor-jobservice"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/envFrom/1/secretRef/name"
			value: "external-harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/volumes/1/secret/secretName"
			value: "external-harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/volumes/2/secret/secretName"
			value: "external-harbor-core"
		}]
	}

	jsp: "deployment-harbor-port": {
		target: {
			kind: "Deployment"
			name: "harbor-port"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-port"
		}]
	}

	jsp: "deployment-harbor-jobservice": {
		target: {
			kind: "Deployment"
			name: "harbor-jobservice"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-jobservice"
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret-core"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/0/valueFrom/secretKeyRef/name"
			value: "external-harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/envFrom/1/secretRef/name"
			value: "external-harbor-jobservice"
		}]
	}

	jsp: "deployment-harbor-registry": {
		target: {
			version: "v1"
			kind:    "Deployment"
			name:    "harbor-registry"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-registry"
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret-core"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/metadata/annotations/checksum~1secret-jobservice"
			value: ""
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/envFrom/0/secretRef/name"
			value: "external-harbor-registry"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/1/env/0/valueFrom/secretKeyRef/name"
			value: "external-harbor-core"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/1/env/1/valueFrom/secretKeyRef/name"
			value: "external-harbor-jobservice"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/1/envFrom/1/secretRef/name"
			value: "external-harbor-registry"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/1/envFrom/2/secretRef/name"
			value: "external-harbor-registryctl"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/volumes/0/secret/secretName"
			value: "external-harbor-registry-htpasswd"
		}]
	}

	jsp: "statefulset-harbor-trivy": {
		target: {
			kind: "StatefulSet"
			name: "harbor-trivy"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-trivy"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/9/valueFrom/secretKeyRef/name"
			value: "external-harbor-trivy"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/17/valueFrom/secretKeyRef/name"
			value: "external-harbor-trivy"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/18/valueFrom/secretKeyRef/name"
			value: "external-harbor-trivy"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/env/19/valueFrom/secretKeyRef/name"
			value: "external-harbor-trivy"
		}]
	}

	jsp: "statefulset-harbor-database": {
		target: {
			kind: "StatefulSet"
			name: "harbor-database"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-database"
		}, {
			op:    "replace"
			path:  "/spec/template/spec/containers/0/envFrom/0/secretRef/name"
			value: "external-harbor-database"
		}]
	}

	jsp: "statefulset-harbor-redis": {
		target: {
			kind: "StatefulSet"
			name: "harbor-redis"
		}
		patches: [{
			op:    "replace"
			path:  "/spec/template/metadata/labels/name"
			value: "harbor-redis"
		}]
	}

	resource: "externalsecret-harbor-admin": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-admin"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-admin"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["harbor_admin_password", "harbor_postgres_password"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-core": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-core"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-core"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["CSRF_KEY", "POSTGRESQL_PASSWORD", "REGISTRY_CREDENTIAL_PASSWORD", "secret", "secretKey", "tls.crt", "tls.key"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-jobservice": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-jobservice"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-jobservice"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["JOBSERVICE_SECRET", "REGISTRY_CREDENTIAL_PASSWORD"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-registry": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-registry"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-registry"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["REGISTRY_HTTP_SECRET", "REGISTRY_REDIS_PASSWORD"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-registry-htpasswd": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-registry-htpasswd"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-registry-htpasswd"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["REGISTRY_HTPASSWD"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-registryctl": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-registryctl"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-registryctl"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"
			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["hello"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-trivy": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-trivy"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-trivy"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["gitHubToken", "redisURL"]
			}}).output
		}
	}

	resource: "externalsecret-harbor-database": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "harbor-database"
			namespace: "harbor"
		}
		spec: {
			target: {
				name:           "external-harbor-database"
				creationPolicy: "Owner"
			}

			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster.cluster_name
			}

			refreshInterval: "1h"

			(#external_secrets_data & {input: {
				secret: "\(cluster.cluster_name)-cluster"
				keys: ["POSTGRES_PASSWORD"]
			}}).output
		}
	}
}

// https://artifacthub.io/packages/helm/stakater/reloader
kustomize: "reloader": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "reloader"

	helm: {
		release:   "reloader"
		name:      "reloader"
		namespace: "reloader"
		version:   "1.0.67"
		repo:      "https://stakater.github.io/stakater-charts"
		values: {
		}
	}

	resource: "namespace-reloader": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "reloader"
		}
	}
}

// https://artifacthub.io/packages/helm/descheduler/descheduler
kustomize: "descheduler": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "descheduler"

	helm: {
		release:   "descheduler"
		name:      "descheduler"
		namespace: "descheduler"
		version:   "0.29.0"
		repo:      "https://kubernetes-sigs.github.io/descheduler"
		values: {
		}
	}

	resource: "namespace-descheduler": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "descheduler"
		}
	}
}

// https://artifacthub.io/packages/helm/aws/aws-node-termination-handler
kustomize: "aws-node-term": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "aws-node-termination-handler"

	helm: {
		release:   "aws-node-term"
		name:      "aws-node-termination-handler"
		namespace: "aws-node-termination-handler"
		version:   "0.21.0"
		repo:      "https://aws.github.io/eks-charts"
		values: {
		}
	}

	resource: "namespace-aws-node-termination-handler": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "aws-node-termination-handler"
		}
	}
}

#resource: "service-deathstar": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "deathstar"
		annotations: "io.cilium/global-service": "true"
	}
	spec: {
		type: "ClusterIP"
		ports: [{
			port: 80
		}]
		selector: {
			org:   "empire"
			class: "deathstar"
		}
	}
}

kustomize: "deathstar": #Kustomize & {
	cluster: #Cluster

	namespace: "default"

	resource: "service-deathstar": #resource["service-deathstar"]

	resource: "deployment-deathstar": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: name: "deathstar"
		spec: {
			selector: matchLabels: {
				name:  "deathstar"
				org:   "empire"
				class: "deathstar"
			}
			replicas: 3
			template: {
				metadata: labels: {
					name:  "deathstar"
					org:   "empire"
					class: "deathstar"
				}
				spec: containers: [{
					name:            "deathstar"
					image:           "docker.io/cilium/starwars:v1.0"
					imagePullPolicy: "IfNotPresent"
				}]
			}
		}
	}

	resource: "deployment-spaceship": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: name: "spaceship"
		spec: {
			selector: matchLabels: {
				name:  "spaceship"
				org:   "empire"
				class: "spaceship"
			}
			replicas: 4
			template: {
				metadata: labels: {
					name:  "spaceship"
					org:   "empire"
					class: "spaceship"
				}
				spec: containers: [{
					name:            "spaceship"
					image:           "docker.io/tgraf/netperf:v1.0"
					imagePullPolicy: "IfNotPresent"
				}]
			}
		}
	}

	resource: "ciliumnetworkpolicy-deathstar-blueprints": {
		apiVersion: "cilium.io/v2"
		kind:       "CiliumNetworkPolicy"
		metadata: name: "deathstar-blueprints"
		spec: {
			endpointSelector: matchLabels: {
				class: "deathstar"
				org:   "empire"
			}
			ingress: [{
				fromEndpoints: [{
					matchLabels: org: "alliance"
				}]
				toPorts: [{
					ports: [{
						port:     "80"
						protocol: "TCP"
					}]
					rules: http: [{
						method: "PUT"
						path:   "/v1/exhaust-port$"
						headers: ["X-Has-Force: True"]
					}]
				}]
			}, {
				fromEndpoints: [{
					matchLabels: org: "empire"
				}]
				toPorts: [{
					ports: [{
						port:     "80"
						protocol: "TCP"
					}]
					rules: http: [{
						method: "GET"
						path:   "/v1/"
					}]
				}]
			}, {
				fromEndpoints: [{
					matchLabels: app: "mirrord"
				}]
				toPorts: [{
					ports: [{
						port:     "80"
						protocol: "TCP"
					}]
					rules: http: [{
						method: "PUT"
						path:   "/v1/exhaust-port$"
						headers: ["X-Has-Mirrord: True"]
					}]
				}]
			}]
		}
	}
}

kustomize: "xwing": #Kustomize & {
	cluster: #Cluster

	namespace: "default"

	resource: "service-deathstar": #resource["service-deathstar"]

	resource: "deployment-xwing": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: name: "xwing"
		spec: {
			selector: matchLabels: {
				name:  "xwing"
				org:   "alliance"
				class: "spaceship"
			}
			replicas: 3
			template: {
				metadata: labels: {
					name:  "xwing"
					org:   "alliance"
					class: "spaceship"
				}
				spec: containers: [{
					name:            "spaceship"
					image:           "docker.io/tgraf/netperf:v1.0"
					imagePullPolicy: "IfNotPresent"
				}]
			}
		}
	}
}

// https://github.com/buildbuddy-io/buildbuddy-helm/tree/master/charts/buildbuddy
kustomize: "buildbuddy": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "ldbuddyreloader"

	helm: {
		release:   "buildbuddy"
		name:      "buildbuddy"
		namespace: "buildbuddy"
		version:   "0.0.199"
		repo:      "https://helm.buildbuddy.io"
		values: {
			mysql: {
				enabled:       true
				mysqlUser:     "admin"
				mysqlPassword: "admin"
			}

			config: app: {
				build_buddy_url: "https://buildbuddy.\(cluster.domain_name)"
				events_api_url:  "grpcs://buildbuddy.\(cluster.domain_name)"
				cache_api_url:   "grpcs://buildbuddy.\(cluster.domain_name)"
			}
		}
	}

	resource: "namespace-buildbuddy": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "buildbuddy"
		}
	}

	psm: "service-buildbuddy": {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name: "buildbuddy"
		}
		spec: type: "ClusterIP"
	}

	resource: "ingress-buildbuddy": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "buildbuddy"
			annotations: {
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "buildbuddy.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "buildbuddy"
						port: number: 80
					}
				}]
			}]
		}
	}
}

// https://artifacthub.io/packages/helm/crossplane/crossplane
kustomize: "crossplane": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "crossplane"

	helm: {
		release:   "crossplane"
		name:      "crossplane"
		namespace: "crossplane"
		version:   "1.15.0"
		repo:      "https://charts.crossplane.io/stable"
		values: {
		}
	}

	resource: "namespace-crossplane": {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "crossplane"
		}
	}
}

kustomize: "crossprovider": #Kustomize & {
	cluster: #Cluster

	namespace: "crossplane"

	resource: "provider-kubernetes": {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Provider"
		metadata: name: "provider-kubernetes"
		spec: {
			package: "xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.11.4"
			runtimeConfigRef: {
				apiVersion: "pkg.crossplane.io/v1beta1"
				kind:       "DeploymentRuntimeConfig"
				name:       "provider-kubernetes"
			}
		}
	}

	resource: "deployment-runtime-config-kubernetes": {
		apiVersion: "pkg.crossplane.io/v1beta1"
		kind:       "DeploymentRuntimeConfig"
		metadata: name: "provider-kubernetes"
		spec: serviceAccountTemplate: metadata: name: "provider-kubernetes"
	}
}

kustomize: "crosskubernetes": #Kustomize & {
	cluster: #Cluster

	namespace: "crossplane"
}

kustomize: "crossdemo": #Kustomize & {
	cluster: #Cluster

	namespace: "default"

	#name: "crossdemo"

	resource: "provider-config-crossdemo": {
		apiVersion: "kubernetes.crossplane.io/v1alpha1"
		kind:       "ProviderConfig"
		metadata: name: "provider-\(#name)"
		spec: credentials: source: "InjectedIdentity"
	}

	resource: "cluster-role-binding-crossdemo": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "provider-\(#name)"
		subjects: [{
			kind:        "ServiceAccount"
			name:        "provider-\(#name)"
			"namespace": "crossplane-system"
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "cluster-admin"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
	resource: foo: {
		apiVersion: "kubernetes.crossplane.io/v1alpha2"
		kind:       "Object"
		metadata: name: "foo"
		spec: {
			references: [{
				patchesFrom: {
					apiVersion: "v1"
					kind:       "ConfigMap"
					name:       "bar"
					namespace:  "default"
					fieldPath:  "data.sample-key"
				}
				toFieldPath: "data.sample-key"
			}, {
				patchesFrom: {
					apiVersion: "v1"
					kind:       "ConfigMap"
					name:       "bar"
					namespace:  "default"
					fieldPath:  "metadata.namespace"
				}
				toFieldPath: "metadata.namespace"
			}]
			forProvider: manifest: {
				apiVersion: "v1"
				kind:       "ConfigMap"
				data: "sample-key-foo": "foo"
				"metadata": annotations: {
					"argocd.argoproj.io/tracking-id":  "\(cluster.cluster_name)-cluster-crossdemo:/ConfigMap:dont-track/\(metadata.name)"
					"argocd.argoproj.io/sync-options": "Prune=false"
				}
			}
			providerConfigRef: name: "provider-\(#name)"
		}
	}

	resource: bar: {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:        "bar"
			"namespace": namespace
		}
		data: "sample-key": "bar"
	}
}
