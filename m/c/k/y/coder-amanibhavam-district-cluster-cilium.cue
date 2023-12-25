package y

res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": cilium: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "cilium"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-envoy": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "cilium-envoy"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-operator": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "cilium-operator"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "clustermesh-apiserver"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-relay": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "hubble-relay"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-ui": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "hubble-ui"
		namespace: "kube-system"
	}
}
res: role: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-config-agent": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name:      "cilium-config-agent"
		namespace: "kube-system"
	}
	rules: [{
		apiGroups: [""]
		resources: ["configmaps"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-district-cluster-cilium": cluster: cilium: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "cilium"
	}
	rules: [{
		apiGroups: ["networking.k8s.io"]
		resources: ["networkpolicies"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["discovery.k8s.io"]
		resources: ["endpointslices"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"namespaces",
			"services",
			"pods",
			"endpoints",
			"nodes",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: [
			"list",
			"watch",
			"get",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumloadbalancerippools",
			"ciliumbgppeeringpolicies",
			"ciliumbgpnodeconfigs",
			"ciliumbgpadvertisements",
			"ciliumbgppeerconfigs",
			"ciliumclusterwideenvoyconfigs",
			"ciliumclusterwidenetworkpolicies",
			"ciliumegressgatewaypolicies",
			"ciliumendpoints",
			"ciliumendpointslices",
			"ciliumenvoyconfigs",
			"ciliumidentities",
			"ciliumlocalredirectpolicies",
			"ciliumnetworkpolicies",
			"ciliumnodes",
			"ciliumnodeconfigs",
			"ciliumcidrgroups",
			"ciliuml2announcementpolicies",
			"ciliumpodippools",
		]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumidentities",
			"ciliumendpoints",
			"ciliumnodes",
		]
		verbs: ["create"]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumidentities"]
		verbs: ["update"]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumendpoints"]
		verbs: [
			"delete",
			"get",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumnodes",
			"ciliumnodes/status",
		]
		verbs: [
			"get",
			"update",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumnetworkpolicies/status",
			"ciliumclusterwidenetworkpolicies/status",
			"ciliumendpoints/status",
			"ciliumendpoints",
			"ciliuml2announcementpolicies/status",
			"ciliumbgpnodeconfigs/status",
		]
		verbs: ["patch"]
	}]
}
res: clusterrole: "coder-amanibhavam-district-cluster-cilium": cluster: "cilium-operator": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "cilium-operator"
	}
	rules: [{
		apiGroups: [""]
		resources: ["pods"]
		verbs: [
			"get",
			"list",
			"watch",
			"delete",
		]
	}, {
		apiGroups: [""]
		resources: ["nodes"]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"nodes",
			"nodes/status",
		]
		verbs: ["patch"]
	}, {
		apiGroups: ["discovery.k8s.io"]
		resources: ["endpointslices"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: ["services/status"]
		verbs: [
			"update",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: ["namespaces"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"services",
			"endpoints",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumnetworkpolicies",
			"ciliumclusterwidenetworkpolicies",
		]
		verbs: [
			"create",
			"update",
			"deletecollection",
			"patch",
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumnetworkpolicies/status",
			"ciliumclusterwidenetworkpolicies/status",
		]
		verbs: [
			"patch",
			"update",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumendpoints",
			"ciliumidentities",
		]
		verbs: [
			"delete",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumidentities"]
		verbs: ["update"]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumnodes"]
		verbs: [
			"create",
			"update",
			"get",
			"list",
			"watch",
			"delete",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumnodes/status"]
		verbs: ["update"]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumendpointslices",
			"ciliumenvoyconfigs",
			"ciliumbgppeerconfigs",
			"ciliumbgpadvertisements",
			"ciliumbgpnodeconfigs",
		]
		verbs: [
			"create",
			"update",
			"get",
			"list",
			"watch",
			"delete",
			"patch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: [
			"create",
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resourceNames: [
			"ciliumloadbalancerippools.cilium.io",
			"ciliumbgppeeringpolicies.cilium.io",
			"ciliumbgpclusterconfigs.cilium.io",
			"ciliumbgppeerconfigs.cilium.io",
			"ciliumbgpadvertisements.cilium.io",
			"ciliumbgpnodeconfigs.cilium.io",
			"ciliumbgpnodeconfigoverrides.cilium.io",
			"ciliumclusterwideenvoyconfigs.cilium.io",
			"ciliumclusterwidenetworkpolicies.cilium.io",
			"ciliumegressgatewaypolicies.cilium.io",
			"ciliumendpoints.cilium.io",
			"ciliumendpointslices.cilium.io",
			"ciliumenvoyconfigs.cilium.io",
			"ciliumexternalworkloads.cilium.io",
			"ciliumidentities.cilium.io",
			"ciliumlocalredirectpolicies.cilium.io",
			"ciliumnetworkpolicies.cilium.io",
			"ciliumnodes.cilium.io",
			"ciliumnodeconfigs.cilium.io",
			"ciliumcidrgroups.cilium.io",
			"ciliuml2announcementpolicies.cilium.io",
			"ciliumpodippools.cilium.io",
		]
		resources: ["customresourcedefinitions"]
		verbs: ["update"]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumloadbalancerippools",
			"ciliumpodippools",
			"ciliumbgpclusterconfigs",
			"ciliumbgpnodeconfigoverrides",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumpodippools"]
		verbs: ["create"]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["ciliumloadbalancerippools/status"]
		verbs: ["patch"]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: [
			"create",
			"get",
			"update",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-district-cluster-cilium": cluster: "clustermesh-apiserver": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "clustermesh-apiserver"
	}
	rules: [{
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumnodes",
			"ciliumendpoints",
			"ciliumidentities",
		]
		verbs: ["create"]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumexternalworkloads/status",
			"ciliumnodes",
			"ciliumidentities",
		]
		verbs: ["update"]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumendpoints",
			"ciliumendpoints/status",
		]
		verbs: ["patch"]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"ciliumidentities",
			"ciliumexternalworkloads",
			"ciliumendpoints",
			"ciliumnodes",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"endpoints",
			"namespaces",
			"services",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["discovery.k8s.io"]
		resources: ["endpointslices"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-district-cluster-cilium": cluster: "hubble-ui": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "hubble-ui"
	}
	rules: [{
		apiGroups: ["networking.k8s.io"]
		resources: ["networkpolicies"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"componentstatuses",
			"endpoints",
			"namespaces",
			"nodes",
			"pods",
			"services",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["*"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: rolebinding: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-config-agent": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name:      "cilium-config-agent"
		namespace: "kube-system"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "cilium-config-agent"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cilium"
		namespace: "kube-system"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-cilium": cluster: cilium: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "cilium"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cilium"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cilium"
		namespace: "kube-system"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-cilium": cluster: "cilium-operator": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "cilium-operator"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cilium-operator"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cilium-operator"
		namespace: "kube-system"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-cilium": cluster: "clustermesh-apiserver": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "clustermesh-apiserver"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "clustermesh-apiserver"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "clustermesh-apiserver"
		namespace: "kube-system"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-cilium": cluster: "hubble-ui": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
		name: "hubble-ui"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "hubble-ui"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "hubble-ui"
		namespace: "kube-system"
	}]
}
res: configmap: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-config": {
	apiVersion: "v1"
	data: {
		"agent-not-ready-taint-key":                      "node.cilium.io/agent-not-ready"
		"arping-refresh-period":                          "30s"
		"auto-direct-node-routes":                        "false"
		"bpf-lb-acceleration":                            "disabled"
		"bpf-lb-algorithm":                               "maglev"
		"bpf-lb-external-clusterip":                      "true"
		"bpf-lb-map-max":                                 "65536"
		"bpf-lb-sock":                                    "false"
		"bpf-map-dynamic-size-ratio":                     "0.0025"
		"bpf-policy-map-max":                             "16384"
		"bpf-root":                                       "/sys/fs/bpf"
		"cgroup-root":                                    "/run/cilium/cgroupv2"
		"cilium-endpoint-gc-interval":                    "5m0s"
		"cluster-id":                                     "250"
		"cluster-name":                                   "coder-amanibhavam-district"
		"cluster-pool-ipv4-cidr":                         "10.250.0.0/17"
		"cluster-pool-ipv4-mask-size":                    "24"
		"cni-exclusive":                                  "true"
		"cni-log-file":                                   "/var/run/cilium/cilium-cni.log"
		"custom-cni-conf":                                "false"
		debug:                                            "false"
		"egress-gateway-reconciliation-trigger-interval": "1s"
		"enable-auto-protect-node-port-range":            "true"
		"enable-bgp-control-plane":                       "false"
		"enable-bpf-clock-probe":                         "false"
		"enable-bpf-masquerade":                          "true"
		"enable-endpoint-health-checking":                "true"
		"enable-external-ips":                            "false"
		"enable-health-check-loadbalancer-ip":            "false"
		"enable-health-check-nodeport":                   "true"
		"enable-health-checking":                         "true"
		"enable-host-port":                               "false"
		"enable-hubble":                                  "true"
		"enable-ipv4":                                    "true"
		"enable-ipv4-big-tcp":                            "false"
		"enable-ipv4-masquerade":                         "true"
		"enable-ipv6":                                    "false"
		"enable-ipv6-big-tcp":                            "false"
		"enable-ipv6-masquerade":                         "true"
		"enable-k8s-networkpolicy":                       "true"
		"enable-k8s-terminating-endpoint":                "true"
		"enable-l2-neigh-discovery":                      "true"
		"enable-l7-proxy":                                "true"
		"enable-local-redirect-policy":                   "false"
		"enable-masquerade-to-route-source":              "false"
		"enable-metrics":                                 "true"
		"enable-node-port":                               "false"
		"enable-policy":                                  "default"
		"enable-remote-node-identity":                    "true"
		"enable-sctp":                                    "false"
		"enable-svc-source-range-check":                  "true"
		"enable-vtep":                                    "false"
		"enable-well-known-identities":                   "false"
		"enable-wireguard":                               "true"
		"enable-xt-socket-fallback":                      "true"
		"encrypt-node":                                   "true"
		"external-envoy-proxy":                           "true"
		"hubble-disable-tls":                             "false"
		"hubble-export-file-max-backups":                 "5"
		"hubble-export-file-max-size-mb":                 "10"
		"hubble-listen-address":                          ":4244"
		"hubble-socket-path":                             "/var/run/cilium/hubble.sock"
		"hubble-tls-cert-file":                           "/var/lib/cilium/tls/hubble/server.crt"
		"hubble-tls-client-ca-files":                     "/var/lib/cilium/tls/hubble/client-ca.crt"
		"hubble-tls-key-file":                            "/var/lib/cilium/tls/hubble/server.key"
		"identity-allocation-mode":                       "crd"
		"identity-gc-interval":                           "15m0s"
		"identity-heartbeat-timeout":                     "30m0s"
		"install-no-conntrack-iptables-rules":            "false"
		ipam:                                             "cluster-pool"
		"ipam-cilium-node-update-rate":                   "15s"
		"k8s-client-burst":                               "20"
		"k8s-client-qps":                                 "10"
		"kube-proxy-replacement":                         "false"
		"kube-proxy-replacement-healthz-bind-address":    ""
		"max-connected-clusters":                         "255"
		"mesh-auth-enabled":                              "true"
		"mesh-auth-gc-interval":                          "5m0s"
		"mesh-auth-queue-size":                           "1024"
		"mesh-auth-rotated-identities-queue-size":        "1024"
		"monitor-aggregation":                            "medium"
		"monitor-aggregation-flags":                      "all"
		"monitor-aggregation-interval":                   "5s"
		"node-port-bind-protection":                      "true"
		"nodes-gc-interval":                              "5m0s"
		"operator-api-serve-addr":                        "127.0.0.1:9234"
		"operator-prometheus-serve-addr":                 ":9963"
		"preallocate-bpf-maps":                           "false"
		procfs:                                           "/host/proc"
		"proxy-connect-timeout":                          "2"
		"proxy-max-connection-duration-seconds":          "0"
		"proxy-max-requests-per-connection":              "0"
		"remove-cilium-node-taints":                      "true"
		"routing-mode":                                   "tunnel"
		"service-no-backend-response":                    "reject"
		"set-cilium-is-up-condition":                     "true"
		"set-cilium-node-taints":                         "true"
		"sidecar-istio-proxy-image":                      "cilium/istio_proxy"
		"skip-cnp-status-startup-clean":                  "false"
		"synchronize-k8s-nodes":                          "true"
		"tofqdns-dns-reject-response-code":               "refused"
		"tofqdns-enable-dns-compression":                 "true"
		"tofqdns-endpoint-max-ip-per-hostname":           "50"
		"tofqdns-idle-connection-grace-period":           "0s"
		"tofqdns-max-deferred-connection-deletes":        "10000"
		"tofqdns-proxy-response-max-delay":               "100ms"
		"tunnel-protocol":                                "vxlan"
		"unmanaged-pod-watcher-interval":                 "15"
		"vtep-cidr":                                      ""
		"vtep-endpoint":                                  ""
		"vtep-mac":                                       ""
		"vtep-mask":                                      ""
		"wireguard-persistent-keepalive":                 "0s"
		"write-cni-conf-when-ready":                      "/host/etc/cni/net.d/05-cilium.conflist"
	}
	kind: "ConfigMap"
	metadata: {
		name:      "cilium-config"
		namespace: "kube-system"
	}
}
res: configmap: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-envoy-config": {
	apiVersion: "v1"
	data: "bootstrap-config.json": """
		{
		  \"node\": {
		    \"id\": \"host~127.0.0.1~no-id~localdomain\",
		    \"cluster\": \"ingress-cluster\"
		  },
		  \"staticResources\": {
		    \"listeners\": [
		      {
		        \"name\": \"envoy-prometheus-metrics-listener\",
		        \"address\": {
		          \"socket_address\": {
		            \"address\": \"0.0.0.0\",
		            \"port_value\": 9964
		          }
		        },
		        \"filter_chains\": [
		          {
		            \"filters\": [
		              {
		                \"name\": \"envoy.filters.network.http_connection_manager\",
		                \"typed_config\": {
		                  \"@type\": \"type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager\",
		                  \"stat_prefix\": \"envoy-prometheus-metrics-listener\",
		                  \"route_config\": {
		                    \"virtual_hosts\": [
		                      {
		                        \"name\": \"prometheus_metrics_route\",
		                        \"domains\": [
		                          \"*\"
		                        ],
		                        \"routes\": [
		                          {
		                            \"name\": \"prometheus_metrics_route\",
		                            \"match\": {
		                              \"prefix\": \"/metrics\"
		                            },
		                            \"route\": {
		                              \"cluster\": \"/envoy-admin\",
		                              \"prefix_rewrite\": \"/stats/prometheus\"
		                            }
		                          }
		                        ]
		                      }
		                    ]
		                  },
		                  \"http_filters\": [
		                    {
		                      \"name\": \"envoy.filters.http.router\",
		                      \"typed_config\": {
		                        \"@type\": \"type.googleapis.com/envoy.extensions.filters.http.router.v3.Router\"
		                      }
		                    }
		                  ],
		                  \"stream_idle_timeout\": \"0s\"
		                }
		              }
		            ]
		          }
		        ]
		      },
		      {
		        \"name\": \"envoy-health-listener\",
		        \"address\": {
		          \"socket_address\": {
		            \"address\": \"127.0.0.1\",
		            \"port_value\": 9878
		          }
		        },
		        \"filter_chains\": [
		          {
		            \"filters\": [
		              {
		                \"name\": \"envoy.filters.network.http_connection_manager\",
		                \"typed_config\": {
		                  \"@type\": \"type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager\",
		                  \"stat_prefix\": \"envoy-health-listener\",
		                  \"route_config\": {
		                    \"virtual_hosts\": [
		                      {
		                        \"name\": \"health\",
		                        \"domains\": [
		                          \"*\"
		                        ],
		                        \"routes\": [
		                          {
		                            \"name\": \"health\",
		                            \"match\": {
		                              \"prefix\": \"/healthz\"
		                            },
		                            \"route\": {
		                              \"cluster\": \"/envoy-admin\",
		                              \"prefix_rewrite\": \"/ready\"
		                            }
		                          }
		                        ]
		                      }
		                    ]
		                  },
		                  \"http_filters\": [
		                    {
		                      \"name\": \"envoy.filters.http.router\",
		                      \"typed_config\": {
		                        \"@type\": \"type.googleapis.com/envoy.extensions.filters.http.router.v3.Router\"
		                      }
		                    }
		                  ],
		                  \"stream_idle_timeout\": \"0s\"
		                }
		              }
		            ]
		          }
		        ]
		      }
		    ],
		    \"clusters\": [
		      {
		        \"name\": \"ingress-cluster\",
		        \"type\": \"ORIGINAL_DST\",
		        \"connectTimeout\": \"2s\",
		        \"lbPolicy\": \"CLUSTER_PROVIDED\",
		        \"typedExtensionProtocolOptions\": {
		          \"envoy.extensions.upstreams.http.v3.HttpProtocolOptions\": {
		            \"@type\": \"type.googleapis.com/envoy.extensions.upstreams.http.v3.HttpProtocolOptions\",
		            \"commonHttpProtocolOptions\": {
		              \"idleTimeout\": \"60s\",
		              \"maxConnectionDuration\": \"0s\",
		              \"maxRequestsPerConnection\": 0
		            },
		            \"useDownstreamProtocolConfig\": {}
		          }
		        },
		        \"cleanupInterval\": \"2.500s\"
		      },
		      {
		        \"name\": \"egress-cluster-tls\",
		        \"type\": \"ORIGINAL_DST\",
		        \"connectTimeout\": \"2s\",
		        \"lbPolicy\": \"CLUSTER_PROVIDED\",
		        \"typedExtensionProtocolOptions\": {
		          \"envoy.extensions.upstreams.http.v3.HttpProtocolOptions\": {
		            \"@type\": \"type.googleapis.com/envoy.extensions.upstreams.http.v3.HttpProtocolOptions\",
		            \"commonHttpProtocolOptions\": {
		              \"idleTimeout\": \"60s\",
		              \"maxConnectionDuration\": \"0s\",
		              \"maxRequestsPerConnection\": 0
		            },
		            \"upstreamHttpProtocolOptions\": {},
		            \"useDownstreamProtocolConfig\": {}
		          }
		        },
		        \"cleanupInterval\": \"2.500s\",
		        \"transportSocket\": {
		          \"name\": \"cilium.tls_wrapper\",
		          \"typedConfig\": {
		            \"@type\": \"type.googleapis.com/cilium.UpstreamTlsWrapperContext\"
		          }
		        }
		      },
		      {
		        \"name\": \"egress-cluster\",
		        \"type\": \"ORIGINAL_DST\",
		        \"connectTimeout\": \"2s\",
		        \"lbPolicy\": \"CLUSTER_PROVIDED\",
		        \"typedExtensionProtocolOptions\": {
		          \"envoy.extensions.upstreams.http.v3.HttpProtocolOptions\": {
		            \"@type\": \"type.googleapis.com/envoy.extensions.upstreams.http.v3.HttpProtocolOptions\",
		            \"commonHttpProtocolOptions\": {
		              \"idleTimeout\": \"60s\",
		              \"maxConnectionDuration\": \"0s\",
		              \"maxRequestsPerConnection\": 0
		            },
		            \"useDownstreamProtocolConfig\": {}
		          }
		        },
		        \"cleanupInterval\": \"2.500s\"
		      },
		      {
		        \"name\": \"ingress-cluster-tls\",
		        \"type\": \"ORIGINAL_DST\",
		        \"connectTimeout\": \"2s\",
		        \"lbPolicy\": \"CLUSTER_PROVIDED\",
		        \"typedExtensionProtocolOptions\": {
		          \"envoy.extensions.upstreams.http.v3.HttpProtocolOptions\": {
		            \"@type\": \"type.googleapis.com/envoy.extensions.upstreams.http.v3.HttpProtocolOptions\",
		            \"commonHttpProtocolOptions\": {
		              \"idleTimeout\": \"60s\",
		              \"maxConnectionDuration\": \"0s\",
		              \"maxRequestsPerConnection\": 0
		            },
		            \"upstreamHttpProtocolOptions\": {},
		            \"useDownstreamProtocolConfig\": {}
		          }
		        },
		        \"cleanupInterval\": \"2.500s\",
		        \"transportSocket\": {
		          \"name\": \"cilium.tls_wrapper\",
		          \"typedConfig\": {
		            \"@type\": \"type.googleapis.com/cilium.UpstreamTlsWrapperContext\"
		          }
		        }
		      },
		      {
		        \"name\": \"xds-grpc-cilium\",
		        \"type\": \"STATIC\",
		        \"connectTimeout\": \"2s\",
		        \"loadAssignment\": {
		          \"clusterName\": \"xds-grpc-cilium\",
		          \"endpoints\": [
		            {
		              \"lbEndpoints\": [
		                {
		                  \"endpoint\": {
		                    \"address\": {
		                      \"pipe\": {
		                        \"path\": \"/var/run/cilium/envoy/sockets/xds.sock\"
		                      }
		                    }
		                  }
		                }
		              ]
		            }
		          ]
		        },
		        \"typedExtensionProtocolOptions\": {
		          \"envoy.extensions.upstreams.http.v3.HttpProtocolOptions\": {
		            \"@type\": \"type.googleapis.com/envoy.extensions.upstreams.http.v3.HttpProtocolOptions\",
		            \"explicitHttpConfig\": {
		              \"http2ProtocolOptions\": {}
		            }
		          }
		        }
		      },
		      {
		        \"name\": \"/envoy-admin\",
		        \"type\": \"STATIC\",
		        \"connectTimeout\": \"2s\",
		        \"loadAssignment\": {
		          \"clusterName\": \"/envoy-admin\",
		          \"endpoints\": [
		            {
		              \"lbEndpoints\": [
		                {
		                  \"endpoint\": {
		                    \"address\": {
		                      \"pipe\": {
		                        \"path\": \"/var/run/cilium/envoy/sockets/admin.sock\"
		                      }
		                    }
		                  }
		                }
		              ]
		            }
		          ]
		        }
		      }
		    ]
		  },
		  \"dynamicResources\": {
		    \"ldsConfig\": {
		      \"apiConfigSource\": {
		        \"apiType\": \"GRPC\",
		        \"transportApiVersion\": \"V3\",
		        \"grpcServices\": [
		          {
		            \"envoyGrpc\": {
		              \"clusterName\": \"xds-grpc-cilium\"
		            }
		          }
		        ],
		        \"setNodeOnFirstMessageOnly\": true
		      },
		      \"resourceApiVersion\": \"V3\"
		    },
		    \"cdsConfig\": {
		      \"apiConfigSource\": {
		        \"apiType\": \"GRPC\",
		        \"transportApiVersion\": \"V3\",
		        \"grpcServices\": [
		          {
		            \"envoyGrpc\": {
		              \"clusterName\": \"xds-grpc-cilium\"
		            }
		          }
		        ],
		        \"setNodeOnFirstMessageOnly\": true
		      },
		      \"resourceApiVersion\": \"V3\"
		    }
		  },
		  \"bootstrapExtensions\": [
		    {
		      \"name\": \"envoy.bootstrap.internal_listener\",
		      \"typed_config\": {
		        \"@type\": \"type.googleapis.com/envoy.extensions.bootstrap.internal_listener.v3.InternalListener\"
		      }
		    }
		  ],
		  \"layeredRuntime\": {
		    \"layers\": [
		      {
		        \"name\": \"static_layer_0\",
		        \"staticLayer\": {
		          \"overload\": {
		            \"global_downstream_max_connections\": 50000
		          }
		        }
		      }
		    ]
		  },
		  \"admin\": {
		    \"address\": {
		      \"pipe\": {
		        \"path\": \"/var/run/cilium/envoy/sockets/admin.sock\"
		      }
		    }
		  }
		}

		"""

	kind: "ConfigMap"
	metadata: {
		name:      "cilium-envoy-config"
		namespace: "kube-system"
	}
}
res: configmap: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-relay-config": {
	apiVersion: "v1"
	data: "config.yaml": """
		cluster-name: coder-amanibhavam-district
		peer-service: \"hubble-peer.kube-system.svc.cluster.local:443\"
		listen-address: :4245
		gops: true
		gops-port: \"9893\"
		dial-timeout: 
		retry-timeout: 
		sort-buffer-len-max: 
		sort-buffer-drain-timeout: 
		tls-hubble-client-cert-file: /var/lib/hubble-relay/tls/client.crt
		tls-hubble-client-key-file: /var/lib/hubble-relay/tls/client.key
		tls-hubble-server-ca-files: /var/lib/hubble-relay/tls/hubble-server-ca.crt
		disable-server-tls: true

		"""

	kind: "ConfigMap"
	metadata: {
		name:      "hubble-relay-config"
		namespace: "kube-system"
	}
}
res: configmap: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-ui-nginx": {
	apiVersion: "v1"
	data: "nginx.conf": """
		server {
		    listen       8081;
		    listen       [::]:8081;
		    server_name  localhost;
		    root /app;
		    index index.html;
		    client_max_body_size 1G;

		    location / {
		        proxy_set_header Host $host;
		        proxy_set_header X-Real-IP $remote_addr;

		        # CORS
		        add_header Access-Control-Allow-Methods \"GET, POST, PUT, HEAD, DELETE, OPTIONS\";
		        add_header Access-Control-Allow-Origin *;
		        add_header Access-Control-Max-Age 1728000;
		        add_header Access-Control-Expose-Headers content-length,grpc-status,grpc-message;
		        add_header Access-Control-Allow-Headers range,keep-alive,user-agent,cache-control,content-type,content-transfer-encoding,x-accept-content-transfer-encoding,x-accept-response-streaming,x-user-agent,x-grpc-web,grpc-timeout;
		        if ($request_method = OPTIONS) {
		            return 204;
		        }
		        # /CORS

		        location /api {
		            proxy_http_version 1.1;
		            proxy_pass_request_headers on;
		            proxy_hide_header Access-Control-Allow-Origin;
		            proxy_pass http://127.0.0.1:8090;
		        }
		        location / {
		            # double `/index.html` is required here 
		            try_files $uri $uri/ /index.html /index.html;
		        }

		        # Liveness probe
		        location /healthz {
		            access_log off;
		            add_header Content-Type text/plain;
		            return 200 'ok';
		        }
		    }
		}
		"""

	kind: "ConfigMap"
	metadata: {
		name:      "hubble-ui-nginx"
		namespace: "kube-system"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-envoy": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: {
			"prometheus.io/port":   "9964"
			"prometheus.io/scrape": "true"
		}
		labels: {
			"app.kubernetes.io/name":    "cilium-envoy"
			"app.kubernetes.io/part-of": "cilium"
			"io.cilium/app":             "proxy"
			"k8s-app":                   "cilium-envoy"
		}
		name:      "cilium-envoy"
		namespace: "kube-system"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "envoy-metrics"
			port:       9964
			protocol:   "TCP"
			targetPort: "envoy-metrics"
		}]
		selector: "k8s-app": "cilium-envoy"
		type: "ClusterIP"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "clustermesh-apiserver"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "clustermesh-apiserver"
		}
		name:      "clustermesh-apiserver"
		namespace: "kube-system"
	}
	spec: {
		ports: [{
			port: 2379
		}]
		selector: "k8s-app": "clustermesh-apiserver"
		type: "LoadBalancer"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver-metrics": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "metrics"
			"app.kubernetes.io/name":      "clustermesh-apiserver"
			"app.kubernetes.io/part-of":   "cilium"
			"k8s-app":                     "clustermesh-apiserver"
		}
		name:      "clustermesh-apiserver-metrics"
		namespace: "kube-system"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "apiserv-metrics"
			port:       9962
			protocol:   "TCP"
			targetPort: "apiserv-metrics"
		}, {
			name:       "etcd-metrics"
			port:       9963
			protocol:   "TCP"
			targetPort: "etcd-metrics"
		}]
		selector: "k8s-app": "clustermesh-apiserver"
		type: "ClusterIP"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-peer": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "hubble-peer"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "cilium"
		}
		name:      "hubble-peer"
		namespace: "kube-system"
	}
	spec: {
		internalTrafficPolicy: "Local"
		ports: [{
			name:       "peer-service"
			port:       443
			protocol:   "TCP"
			targetPort: 4244
		}]
		selector: "k8s-app": "cilium"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-relay": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "hubble-relay"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "hubble-relay"
		}
		name:      "hubble-relay"
		namespace: "kube-system"
	}
	spec: {
		ports: [{
			port:       80
			protocol:   "TCP"
			targetPort: 4245
		}]
		selector: "k8s-app": "hubble-relay"
		type: "ClusterIP"
	}
}
res: service: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-ui": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "hubble-ui"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "hubble-ui"
		}
		name:      "hubble-ui"
		namespace: "kube-system"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			targetPort: 8081
		}]
		selector: "k8s-app": "hubble-ui"
		type: "ClusterIP"
	}
}
res: deployment: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-operator": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "cilium-operator"
			"app.kubernetes.io/part-of": "cilium"
			"io.cilium/app":             "operator"
			name:                        "cilium-operator"
		}
		name:      "cilium-operator"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"io.cilium/app": "operator"
			name:            "cilium-operator"
		}
		strategy: {
			rollingUpdate: {
				maxSurge:       "25%"
				maxUnavailable: "100%"
			}
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				annotations: {
					"prometheus.io/port":   "9963"
					"prometheus.io/scrape": "true"
				}
				labels: {
					"app.kubernetes.io/name":    "cilium-operator"
					"app.kubernetes.io/part-of": "cilium"
					"io.cilium/app":             "operator"
					name:                        "cilium-operator"
				}
			}
			spec: {
				affinity: podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "io.cilium/app": "operator"
					topologyKey: "kubernetes.io/hostname"
				}]
				automountServiceAccountToken: true
				containers: [{
					args: [
						"--config-dir=/tmp/cilium/config-map",
						"--debug=$(CILIUM_DEBUG)",
					]
					command: ["cilium-operator-generic"]
					env: [{
						name: "K8S_NODE_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "spec.nodeName"
						}
					}, {
						name: "CILIUM_K8S_NAMESPACE"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}, {
						name: "CILIUM_DEBUG"
						valueFrom: configMapKeyRef: {
							key:      "debug"
							name:     "cilium-config"
							optional: true
						}
					}]
					image:           "quay.io/cilium/operator-generic:v1.15.0-rc.0@sha256:cc0800697151d9a68c9547c66e9d5f4a67537efd369cb10caf19e79748b24b02"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9234
							scheme: "HTTP"
						}
						initialDelaySeconds: 60
						periodSeconds:       10
						timeoutSeconds:      3
					}
					name: "cilium-operator"
					ports: [{
						containerPort: 9963
						hostPort:      9963
						name:          "prometheus"
						protocol:      "TCP"
					}]
					readinessProbe: {
						failureThreshold: 5
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9234
							scheme: "HTTP"
						}
						initialDelaySeconds: 0
						periodSeconds:       5
						timeoutSeconds:      3
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/tmp/cilium/config-map"
						name:      "cilium-config-path"
						readOnly:  true
					}]
				}]
				hostNetwork: true
				nodeSelector: "kubernetes.io/os": "linux"
				priorityClassName:  "system-cluster-critical"
				restartPolicy:      "Always"
				serviceAccount:     "cilium-operator"
				serviceAccountName: "cilium-operator"
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					configMap: name: "cilium-config"
					name: "cilium-config-path"
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "clustermesh-apiserver"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "clustermesh-apiserver"
		}
		name:      "clustermesh-apiserver"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "k8s-app": "clustermesh-apiserver"
		strategy: {
			rollingUpdate: maxUnavailable: 1
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				labels: {
					"app.kubernetes.io/name":    "clustermesh-apiserver"
					"app.kubernetes.io/part-of": "cilium"
					"k8s-app":                   "clustermesh-apiserver"
				}
			}
			spec: {
				affinity: podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "k8s-app": "clustermesh-apiserver"
					topologyKey: "kubernetes.io/hostname"
				}]
				automountServiceAccountToken: true
				containers: [{
					args: [
						"--data-dir=/var/run/etcd",
						"--name=clustermesh-apiserver",
						"--client-cert-auth",
						"--trusted-ca-file=/var/lib/etcd-secrets/ca.crt",
						"--cert-file=/var/lib/etcd-secrets/tls.crt",
						"--key-file=/var/lib/etcd-secrets/tls.key",
						"--listen-client-urls=https://127.0.0.1:2379,https://[$(HOSTNAME_IP)]:2379",
						"--advertise-client-urls=https://[$(HOSTNAME_IP)]:2379",
						"--initial-cluster-token=clustermesh-apiserver",
						"--auto-compaction-retention=1",
						"--listen-metrics-urls=http://[$(HOSTNAME_IP)]:9963",
						"--metrics=basic",
					]
					command: ["/usr/bin/etcd"]
					env: [{
						name:  "ETCDCTL_API"
						value: "3"
					}, {
						name: "HOSTNAME_IP"
						valueFrom: fieldRef: fieldPath: "status.podIP"
					}]
					image:           "quay.io/cilium/clustermesh-apiserver:v1.15.0-rc.0@sha256:7a6be505270347b8e4076941b282ecd3c89cbdce68f50a3ba6e0bd5a60553c47"
					imagePullPolicy: "IfNotPresent"
					name:            "etcd"
					ports: [{
						containerPort: 2379
						name:          "etcd"
						protocol:      "TCP"
					}, {
						containerPort: 9963
						name:          "etcd-metrics"
						protocol:      "TCP"
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/var/lib/etcd-secrets"
						name:      "etcd-server-secrets"
						readOnly:  true
					}, {
						mountPath: "/var/run/etcd"
						name:      "etcd-data-dir"
					}]
				}, {
					args: [
						"clustermesh",
						"--cluster-name=$(CLUSTER_NAME)",
						"--cluster-id=$(CLUSTER_ID)",
						"--kvstore-opt",
						"etcd.config=/var/lib/cilium/etcd-config.yaml",
						"--max-connected-clusters=255",
						"--enable-external-workloads=false",
						"--prometheus-serve-addr=:9962",
						"--controller-group-metrics=all",
					]
					command: ["/usr/bin/clustermesh-apiserver"]
					env: [{
						name: "CLUSTER_NAME"
						valueFrom: configMapKeyRef: {
							key:  "cluster-name"
							name: "cilium-config"
						}
					}, {
						name: "CLUSTER_ID"
						valueFrom: configMapKeyRef: {
							key:      "cluster-id"
							name:     "cilium-config"
							optional: true
						}
					}, {
						name: "IDENTITY_ALLOCATION_MODE"
						valueFrom: configMapKeyRef: {
							key:  "identity-allocation-mode"
							name: "cilium-config"
						}
					}, {
						name: "ENABLE_K8S_ENDPOINT_SLICE"
						valueFrom: configMapKeyRef: {
							key:      "enable-k8s-endpoint-slice"
							name:     "cilium-config"
							optional: true
						}
					}]
					image:           "quay.io/cilium/clustermesh-apiserver:v1.15.0-rc.0@sha256:7a6be505270347b8e4076941b282ecd3c89cbdce68f50a3ba6e0bd5a60553c47"
					imagePullPolicy: "IfNotPresent"
					name:            "apiserver"
					ports: [{
						containerPort: 9962
						name:          "apiserv-metrics"
						protocol:      "TCP"
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/var/lib/cilium/etcd-secrets"
						name:      "etcd-admin-client"
						readOnly:  true
					}]
				}]
				initContainers: [{
					args: [
						"etcdinit",
						"--etcd-cluster-name=clustermesh-apiserver",
						"--etcd-initial-cluster-token=clustermesh-apiserver",
						"--etcd-data-dir=/var/run/etcd",
					]
					command: ["/usr/bin/clustermesh-apiserver"]
					env: [{
						name: "CILIUM_CLUSTER_NAME"
						valueFrom: configMapKeyRef: {
							key:  "cluster-name"
							name: "cilium-config"
						}
					}]
					image:                    "quay.io/cilium/clustermesh-apiserver:v1.15.0-rc.0@sha256:7a6be505270347b8e4076941b282ecd3c89cbdce68f50a3ba6e0bd5a60553c47"
					imagePullPolicy:          "IfNotPresent"
					name:                     "etcd-init"
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/var/run/etcd"
						name:      "etcd-data-dir"
					}]
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				priorityClassName:             "system-cluster-critical"
				restartPolicy:                 "Always"
				serviceAccount:                "clustermesh-apiserver"
				serviceAccountName:            "clustermesh-apiserver"
				terminationGracePeriodSeconds: 30
				volumes: [{
					name: "etcd-server-secrets"
					projected: {
						defaultMode: 256
						sources: [{
							secret: {
								items: [{
									key:  "tls.crt"
									path: "tls.crt"
								}, {
									key:  "tls.key"
									path: "tls.key"
								}, {
									key:  "ca.crt"
									path: "ca.crt"
								}]
								name: "clustermesh-apiserver-server-cert"
							}
						}]
					}
				}, {
					name: "etcd-admin-client"
					projected: {
						defaultMode: 256
						sources: [{
							secret: {
								items: [{
									key:  "tls.crt"
									path: "tls.crt"
								}, {
									key:  "tls.key"
									path: "tls.key"
								}, {
									key:  "ca.crt"
									path: "ca.crt"
								}]
								name: "clustermesh-apiserver-admin-cert"
							}
						}]
					}
				}, {
					emptyDir: {}
					name: "etcd-data-dir"
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-relay": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "hubble-relay"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "hubble-relay"
		}
		name:      "hubble-relay"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "k8s-app": "hubble-relay"
		strategy: {
			rollingUpdate: maxUnavailable: 1
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				labels: {
					"app.kubernetes.io/name":    "hubble-relay"
					"app.kubernetes.io/part-of": "cilium"
					"k8s-app":                   "hubble-relay"
				}
			}
			spec: {
				affinity: podAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "k8s-app": "cilium"
					topologyKey: "kubernetes.io/hostname"
				}]
				automountServiceAccountToken: false
				containers: [{
					args: ["serve"]
					command: ["hubble-relay"]
					image:           "quay.io/cilium/hubble-relay:v1.15.0-rc.0@sha256:eb89a6c12bef00f62f393630958f58d769f0add5ba6fa914180ec21d845034ae"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						grpc: port: 4222
						timeoutSeconds: 3
					}
					name: "hubble-relay"
					ports: [{
						containerPort: 4245
						name:          "grpc"
					}]
					readinessProbe: {
						grpc: port: 4222
						timeoutSeconds: 3
					}
					securityContext: {
						capabilities: drop: ["ALL"]
						runAsGroup:   65532
						runAsNonRoot: true
						runAsUser:    65532
					}
					startupProbe: {
						failureThreshold: 20
						grpc: port: 4222
						periodSeconds:  3
						timeoutSeconds: 3
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/etc/hubble-relay"
						name:      "config"
						readOnly:  true
					}, {
						mountPath: "/var/lib/hubble-relay/tls"
						name:      "tls"
						readOnly:  true
					}]
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				restartPolicy:     "Always"
				securityContext: fsGroup: 65532
				serviceAccount:                "hubble-relay"
				serviceAccountName:            "hubble-relay"
				terminationGracePeriodSeconds: 1
				volumes: [{
					configMap: {
						items: [{
							key:  "config.yaml"
							path: "config.yaml"
						}]
						name: "hubble-relay-config"
					}
					name: "config"
				}, {
					name: "tls"
					projected: {
						defaultMode: 256
						sources: [{
							secret: {
								items: [{
									key:  "tls.crt"
									path: "client.crt"
								}, {
									key:  "tls.key"
									path: "client.key"
								}, {
									key:  "ca.crt"
									path: "hubble-server-ca.crt"
								}]
								name: "hubble-relay-client-certs"
							}
						}]
					}
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-ui": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "hubble-ui"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "hubble-ui"
		}
		name:      "hubble-ui"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "k8s-app": "hubble-ui"
		strategy: {
			rollingUpdate: maxUnavailable: 1
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				labels: {
					"app.kubernetes.io/name":    "hubble-ui"
					"app.kubernetes.io/part-of": "cilium"
					"k8s-app":                   "hubble-ui"
				}
			}
			spec: {
				automountServiceAccountToken: true
				containers: [{
					image:           "quay.io/cilium/hubble-ui:v0.12.1@sha256:9e5f81ee747866480ea1ac4630eb6975ff9227f9782b7c93919c081c33f38267"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: httpGet: {
						path: "/healthz"
						port: 8081
					}
					name: "frontend"
					ports: [{
						containerPort: 8081
						name:          "http"
					}]
					readinessProbe: httpGet: {
						path: "/"
						port: 8081
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/etc/nginx/conf.d/default.conf"
						name:      "hubble-ui-nginx-conf"
						subPath:   "nginx.conf"
					}, {
						mountPath: "/tmp"
						name:      "tmp-dir"
					}]
				}, {
					env: [{
						name:  "EVENTS_SERVER_PORT"
						value: "8090"
					}, {
						name:  "FLOWS_API_ADDR"
						value: "hubble-relay:80"
					}]
					image:           "quay.io/cilium/hubble-ui-backend:v0.12.1@sha256:1f86f3400827a0451e6332262467f894eeb7caf0eb8779bd951e2caa9d027cbe"
					imagePullPolicy: "IfNotPresent"
					name:            "backend"
					ports: [{
						containerPort: 8090
						name:          "grpc"
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				serviceAccount:     "hubble-ui"
				serviceAccountName: "hubble-ui"
				volumes: [{
					configMap: {
						defaultMode: 420
						name:        "hubble-ui-nginx"
					}
					name: "hubble-ui-nginx-conf"
				}, {
					emptyDir: {}
					name: "tmp-dir"
				}]
			}
		}
	}
}
res: daemonset: "coder-amanibhavam-district-cluster-cilium": "kube-system": cilium: {
	apiVersion: "apps/v1"
	kind:       "DaemonSet"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "cilium-agent"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "cilium"
		}
		name:      "cilium"
		namespace: "kube-system"
	}
	spec: {
		selector: matchLabels: "k8s-app": "cilium"
		template: {
			metadata: {
				annotations: {
					"container.apparmor.security.beta.kubernetes.io/apply-sysctl-overwrites": "unconfined"
					"container.apparmor.security.beta.kubernetes.io/cilium-agent":            "unconfined"
					"container.apparmor.security.beta.kubernetes.io/clean-cilium-state":      "unconfined"
					"container.apparmor.security.beta.kubernetes.io/mount-cgroup":            "unconfined"
				}
				labels: {
					"app.kubernetes.io/name":    "cilium-agent"
					"app.kubernetes.io/part-of": "cilium"
					"k8s-app":                   "cilium"
				}
			}
			spec: {
				affinity: podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "k8s-app": "cilium"
					topologyKey: "kubernetes.io/hostname"
				}]
				automountServiceAccountToken: true
				containers: [{
					args: ["--config-dir=/tmp/cilium/config-map"]
					command: ["cilium-agent"]
					env: [{
						name: "K8S_NODE_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "spec.nodeName"
						}
					}, {
						name: "CILIUM_K8S_NAMESPACE"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}, {
						name:  "CILIUM_CLUSTERMESH_CONFIG"
						value: "/var/lib/cilium/clustermesh/"
					}, {
						name: "GOMEMLIMIT"
						valueFrom: resourceFieldRef: resource: "limits.memory"
					}]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					lifecycle: {
						postStart: exec: command: [
							"bash",
							"-c",
							"""
		set -o errexit
		set -o pipefail
		set -o nounset

		# When running in AWS ENI mode, it's likely that 'aws-node' has
		# had a chance to install SNAT iptables rules. These can result
		# in dropped traffic, so we should attempt to remove them.
		# We do it using a 'postStart' hook since this may need to run
		# for nodes which might have already been init'ed but may still
		# have dangling rules. This is safe because there are no
		# dependencies on anything that is part of the startup script
		# itself, and can be safely run multiple times per node (e.g. in
		# case of a restart).
		if [[ \"$(iptables-save | grep -E -c 'AWS-SNAT-CHAIN|AWS-CONNMARK-CHAIN')\" != \"0\" ]];
		then
		    echo 'Deleting iptables rules created by the AWS CNI VPC plugin'
		    iptables-save | grep -E -v 'AWS-SNAT-CHAIN|AWS-CONNMARK-CHAIN' | iptables-restore
		fi
		echo 'Done!'

		""",
						]

						preStop: exec: command: ["/cni-uninstall.sh"]
					}
					livenessProbe: {
						failureThreshold: 10
						httpGet: {
							host: "127.0.0.1"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
						}
						periodSeconds:    30
						successThreshold: 1
						timeoutSeconds:   5
					}
					name: "cilium-agent"
					readinessProbe: {
						failureThreshold: 3
						httpGet: {
							host: "127.0.0.1"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
						}
						periodSeconds:    30
						successThreshold: 1
						timeoutSeconds:   5
					}
					securityContext: {
						capabilities: {
							add: [
								"CHOWN",
								"KILL",
								"NET_ADMIN",
								"NET_RAW",
								"IPC_LOCK",
								"SYS_MODULE",
								"SYS_ADMIN",
								"SYS_RESOURCE",
								"DAC_OVERRIDE",
								"FOWNER",
								"SETGID",
								"SETUID",
							]
							drop: ["ALL"]
						}
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					startupProbe: {
						failureThreshold: 105
						httpGet: {
							host: "127.0.0.1"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
						}
						initialDelaySeconds: 5
						periodSeconds:       2
						successThreshold:    1
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/var/run/cilium/envoy/sockets"
						name:      "envoy-sockets"
						readOnly:  false
					}, {
						mountPath: "/host/proc/sys/net"
						name:      "host-proc-sys-net"
					}, {
						mountPath: "/host/proc/sys/kernel"
						name:      "host-proc-sys-kernel"
					}, {
						mountPath:        "/sys/fs/bpf"
						mountPropagation: "HostToContainer"
						name:             "bpf-maps"
					}, {
						mountPath: "/var/run/cilium"
						name:      "cilium-run"
					}, {
						mountPath: "/host/etc/cni/net.d"
						name:      "etc-cni-netd"
					}, {
						mountPath: "/var/lib/cilium/clustermesh"
						name:      "clustermesh-secrets"
						readOnly:  true
					}, {
						mountPath: "/lib/modules"
						name:      "lib-modules"
						readOnly:  true
					}, {
						mountPath: "/run/xtables.lock"
						name:      "xtables-lock"
					}, {
						mountPath: "/var/lib/cilium/tls/hubble"
						name:      "hubble-tls"
						readOnly:  true
					}, {
						mountPath: "/tmp"
						name:      "tmp"
					}]
				}]
				hostNetwork: true
				initContainers: [{
					command: [
						"cilium-dbg",
						"build-config",
					]
					env: [{
						name: "K8S_NODE_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "spec.nodeName"
						}
					}, {
						name: "CILIUM_K8S_NAMESPACE"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}]
					image:                    "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy:          "IfNotPresent"
					name:                     "config"
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/tmp"
						name:      "tmp"
					}]
				}, {
					command: [
						"sh",
						"-ec",
						"""
		cp /usr/bin/cilium-mount /hostbin/cilium-mount;
		nsenter --cgroup=/hostproc/1/ns/cgroup --mount=/hostproc/1/ns/mnt \"${BIN_PATH}/cilium-mount\" $CGROUP_ROOT;
		rm /hostbin/cilium-mount

		""",
					]

					env: [{
						name:  "CGROUP_ROOT"
						value: "/run/cilium/cgroupv2"
					}, {
						name:  "BIN_PATH"
						value: "/opt/cni/bin"
					}]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					name:            "mount-cgroup"
					securityContext: {
						capabilities: {
							add: [
								"SYS_ADMIN",
								"SYS_CHROOT",
								"SYS_PTRACE",
							]
							drop: ["ALL"]
						}
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/hostproc"
						name:      "hostproc"
					}, {
						mountPath: "/hostbin"
						name:      "cni-path"
					}]
				}, {
					command: [
						"sh",
						"-ec",
						"""
		cp /usr/bin/cilium-sysctlfix /hostbin/cilium-sysctlfix;
		nsenter --mount=/hostproc/1/ns/mnt \"${BIN_PATH}/cilium-sysctlfix\";
		rm /hostbin/cilium-sysctlfix

		""",
					]

					env: [{
						name:  "BIN_PATH"
						value: "/opt/cni/bin"
					}]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					name:            "apply-sysctl-overwrites"
					securityContext: {
						capabilities: {
							add: [
								"SYS_ADMIN",
								"SYS_CHROOT",
								"SYS_PTRACE",
							]
							drop: ["ALL"]
						}
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/hostproc"
						name:      "hostproc"
					}, {
						mountPath: "/hostbin"
						name:      "cni-path"
					}]
				}, {
					args: ["mount | grep \"/sys/fs/bpf type bpf\" || mount -t bpf bpf /sys/fs/bpf"]
					command: [
						"/bin/bash",
						"-c",
						"--",
					]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					name:            "mount-bpf-fs"
					securityContext: privileged: true
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath:        "/sys/fs/bpf"
						mountPropagation: "Bidirectional"
						name:             "bpf-maps"
					}]
				}, {
					command: ["/init-container.sh"]
					env: [{
						name: "CILIUM_ALL_STATE"
						valueFrom: configMapKeyRef: {
							key:      "clean-cilium-state"
							name:     "cilium-config"
							optional: true
						}
					}, {
						name: "CILIUM_BPF_STATE"
						valueFrom: configMapKeyRef: {
							key:      "clean-cilium-bpf-state"
							name:     "cilium-config"
							optional: true
						}
					}, {
						name: "WRITE_CNI_CONF_WHEN_READY"
						valueFrom: configMapKeyRef: {
							key:      "write-cni-conf-when-ready"
							name:     "cilium-config"
							optional: true
						}
					}]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					name:            "clean-cilium-state"
					securityContext: {
						capabilities: {
							add: [
								"NET_ADMIN",
								"SYS_MODULE",
								"SYS_ADMIN",
								"SYS_RESOURCE",
							]
							drop: ["ALL"]
						}
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/sys/fs/bpf"
						name:      "bpf-maps"
					}, {
						mountPath:        "/run/cilium/cgroupv2"
						mountPropagation: "HostToContainer"
						name:             "cilium-cgroup"
					}, {
						mountPath: "/var/run/cilium"
						name:      "cilium-run"
					}]
				}, {
					command: ["/install-plugin.sh"]
					image:           "quay.io/cilium/cilium:v1.15.0-rc.0@sha256:dfd696fb4325e996098607224cf379ccdbbe969634750fa10082e7ac31d0819a"
					imagePullPolicy: "IfNotPresent"
					name:            "install-cni-binaries"
					resources: requests: {
						cpu:    "100m"
						memory: "10Mi"
					}
					securityContext: {
						capabilities: drop: ["ALL"]
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/host/opt/cni/bin"
						name:      "cni-path"
					}]
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				priorityClassName:             "system-node-critical"
				restartPolicy:                 "Always"
				serviceAccount:                "cilium"
				serviceAccountName:            "cilium"
				terminationGracePeriodSeconds: 1
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					emptyDir: {}
					name: "tmp"
				}, {
					hostPath: {
						path: "/var/run/cilium"
						type: "DirectoryOrCreate"
					}
					name: "cilium-run"
				}, {
					hostPath: {
						path: "/sys/fs/bpf"
						type: "DirectoryOrCreate"
					}
					name: "bpf-maps"
				}, {
					hostPath: {
						path: "/proc"
						type: "Directory"
					}
					name: "hostproc"
				}, {
					hostPath: {
						path: "/run/cilium/cgroupv2"
						type: "DirectoryOrCreate"
					}
					name: "cilium-cgroup"
				}, {
					hostPath: {
						path: "/opt/cni/bin"
						type: "DirectoryOrCreate"
					}
					name: "cni-path"
				}, {
					hostPath: {
						path: "/etc/cni/net.d"
						type: "DirectoryOrCreate"
					}
					name: "etc-cni-netd"
				}, {
					hostPath: path: "/lib/modules"
					name: "lib-modules"
				}, {
					hostPath: {
						path: "/run/xtables.lock"
						type: "FileOrCreate"
					}
					name: "xtables-lock"
				}, {
					hostPath: {
						path: "/var/run/cilium/envoy/sockets"
						type: "DirectoryOrCreate"
					}
					name: "envoy-sockets"
				}, {
					name: "clustermesh-secrets"
					projected: {
						defaultMode: 256
						sources: [{
							secret: {
								name:     "cilium-clustermesh"
								optional: true
							}
						}, {
							secret: {
								items: [{
									key:  "tls.key"
									path: "common-etcd-client.key"
								}, {
									key:  "tls.crt"
									path: "common-etcd-client.crt"
								}, {
									key:  "ca.crt"
									path: "common-etcd-client-ca.crt"
								}]
								name:     "clustermesh-apiserver-remote-cert"
								optional: true
							}
						}]
					}
				}, {
					hostPath: {
						path: "/proc/sys/net"
						type: "Directory"
					}
					name: "host-proc-sys-net"
				}, {
					hostPath: {
						path: "/proc/sys/kernel"
						type: "Directory"
					}
					name: "host-proc-sys-kernel"
				}, {
					name: "hubble-tls"
					projected: {
						defaultMode: 256
						sources: [{
							secret: {
								items: [{
									key:  "tls.crt"
									path: "server.crt"
								}, {
									key:  "tls.key"
									path: "server.key"
								}, {
									key:  "ca.crt"
									path: "client-ca.crt"
								}]
								name:     "hubble-server-certs"
								optional: true
							}
						}]
					}
				}]
			}
		}
		updateStrategy: {
			rollingUpdate: maxUnavailable: 2
			type: "RollingUpdate"
		}
	}
}
res: daemonset: "coder-amanibhavam-district-cluster-cilium": "kube-system": "cilium-envoy": {
	apiVersion: "apps/v1"
	kind:       "DaemonSet"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "cilium-envoy"
			"app.kubernetes.io/part-of": "cilium"
			"k8s-app":                   "cilium-envoy"
			name:                        "cilium-envoy"
		}
		name:      "cilium-envoy"
		namespace: "kube-system"
	}
	spec: {
		selector: matchLabels: "k8s-app": "cilium-envoy"
		template: {
			metadata: {
				annotations: {
					"container.apparmor.security.beta.kubernetes.io/cilium-envoy": "unconfined"
					"prometheus.io/port":                                          "9964"
					"prometheus.io/scrape":                                        "true"
				}
				labels: {
					"app.kubernetes.io/name":    "cilium-envoy"
					"app.kubernetes.io/part-of": "cilium"
					"k8s-app":                   "cilium-envoy"
					name:                        "cilium-envoy"
				}
			}
			spec: {
				affinity: podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "k8s-app": "cilium-envoy"
					topologyKey: "kubernetes.io/hostname"
				}]
				automountServiceAccountToken: true
				containers: [{
					args: [
						"-c /var/run/cilium/envoy/bootstrap-config.json",
						"--base-id 0",
						"--log-level info",
						"--log-format [%Y-%m-%d %T.%e][%t][%l][%n] [%g:%#] %v",
					]
					command: ["/usr/bin/cilium-envoy-starter"]
					env: [{
						name: "K8S_NODE_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "spec.nodeName"
						}
					}, {
						name: "CILIUM_K8S_NAMESPACE"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}]
					image:           "quay.io/cilium/cilium-envoy:v1.27.2-f19708f3d0188fe39b7e024b4525b75a9eeee61f@sha256:80de27c1d16ab92923cc0cd1fff90f2e7047a9abf3906fda712268d9cbc5b950"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 10
						httpGet: {
							host:   "localhost"
							path:   "/healthz"
							port:   9878
							scheme: "HTTP"
						}
						periodSeconds:    30
						successThreshold: 1
						timeoutSeconds:   5
					}
					name: "cilium-envoy"
					ports: [{
						containerPort: 9964
						hostPort:      9964
						name:          "envoy-metrics"
						protocol:      "TCP"
					}]
					readinessProbe: {
						failureThreshold: 3
						httpGet: {
							host:   "localhost"
							path:   "/healthz"
							port:   9878
							scheme: "HTTP"
						}
						periodSeconds:    30
						successThreshold: 1
						timeoutSeconds:   5
					}
					securityContext: {
						capabilities: {
							add: [
								"NET_ADMIN",
								"SYS_ADMIN",
							]
							drop: ["ALL"]
						}
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
					}
					startupProbe: {
						failureThreshold: 105
						httpGet: {
							host:   "localhost"
							path:   "/healthz"
							port:   9878
							scheme: "HTTP"
						}
						initialDelaySeconds: 5
						periodSeconds:       2
						successThreshold:    1
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						mountPath: "/var/run/cilium/envoy/sockets"
						name:      "envoy-sockets"
						readOnly:  false
					}, {
						mountPath: "/var/run/cilium/envoy/artifacts"
						name:      "envoy-artifacts"
						readOnly:  true
					}, {
						mountPath: "/var/run/cilium/envoy/"
						name:      "envoy-config"
						readOnly:  true
					}, {
						mountPath:        "/sys/fs/bpf"
						mountPropagation: "HostToContainer"
						name:             "bpf-maps"
					}]
				}]
				hostNetwork: true
				nodeSelector: "kubernetes.io/os": "linux"
				priorityClassName:             "system-node-critical"
				restartPolicy:                 "Always"
				serviceAccount:                "cilium-envoy"
				serviceAccountName:            "cilium-envoy"
				terminationGracePeriodSeconds: 1
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					hostPath: {
						path: "/var/run/cilium/envoy/sockets"
						type: "DirectoryOrCreate"
					}
					name: "envoy-sockets"
				}, {
					hostPath: {
						path: "/var/run/cilium/envoy/artifacts"
						type: "DirectoryOrCreate"
					}
					name: "envoy-artifacts"
				}, {
					configMap: {
						defaultMode: 256
						items: [{
							key:  "bootstrap-config.json"
							path: "bootstrap-config.json"
						}]
						name: "cilium-envoy-config"
					}
					name: "envoy-config"
				}, {
					hostPath: {
						path: "/sys/fs/bpf"
						type: "DirectoryOrCreate"
					}
					name: "bpf-maps"
				}]
			}
		}
		updateStrategy: {
			rollingUpdate: maxUnavailable: 2
			type: "RollingUpdate"
		}
	}
}
res: certificate: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver-admin-cert": {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: {
		name:      "clustermesh-apiserver-admin-cert"
		namespace: "kube-system"
	}
	spec: {
		commonName: "admin-coder-amanibhavam-district"
		dnsNames: ["localhost"]
		duration: "26280h0m0s"
		issuerRef: {
			group: "cert-manager.io"
			kind:  "ClusterIssuer"
			name:  "cilium-ca"
		}
		secretName: "clustermesh-apiserver-admin-cert"
	}
}
res: certificate: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver-remote-cert": {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: {
		name:      "clustermesh-apiserver-remote-cert"
		namespace: "kube-system"
	}
	spec: {
		commonName: "remote"
		duration:   "26280h0m0s"
		issuerRef: {
			group: "cert-manager.io"
			kind:  "ClusterIssuer"
			name:  "cilium-ca"
		}
		secretName: "clustermesh-apiserver-remote-cert"
	}
}
res: certificate: "coder-amanibhavam-district-cluster-cilium": "kube-system": "clustermesh-apiserver-server-cert": {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: {
		name:      "clustermesh-apiserver-server-cert"
		namespace: "kube-system"
	}
	spec: {
		commonName: "clustermesh-apiserver.cilium.io"
		dnsNames: [
			"clustermesh-apiserver.cilium.io",
			"*.mesh.cilium.io",
			"clustermesh-apiserver.kube-system.svc",
		]
		duration: "26280h0m0s"
		ipAddresses: [
			"127.0.0.1",
			"::1",
		]
		issuerRef: {
			group: "cert-manager.io"
			kind:  "ClusterIssuer"
			name:  "cilium-ca"
		}
		secretName: "clustermesh-apiserver-server-cert"
	}
}
res: certificate: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-relay-client-certs": {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: {
		name:      "hubble-relay-client-certs"
		namespace: "kube-system"
	}
	spec: {
		commonName: "*.hubble-relay.cilium.io"
		dnsNames: ["*.hubble-relay.cilium.io"]
		duration: "26280h0m0s"
		issuerRef: {
			group: "cert-manager.io"
			kind:  "ClusterIssuer"
			name:  "cilium-ca"
		}
		privateKey: rotationPolicy: "Always"
		secretName: "hubble-relay-client-certs"
	}
}
res: certificate: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-server-certs": {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: {
		name:      "hubble-server-certs"
		namespace: "kube-system"
	}
	spec: {
		commonName: "*.coder-amanibhavam-district.hubble-grpc.cilium.io"
		dnsNames: ["*.coder-amanibhavam-district.hubble-grpc.cilium.io"]
		duration: "26280h0m0s"
		issuerRef: {
			group: "cert-manager.io"
			kind:  "ClusterIssuer"
			name:  "cilium-ca"
		}
		privateKey: rotationPolicy: "Always"
		secretName: "hubble-server-certs"
	}
}
res: ingress: "coder-amanibhavam-district-cluster-cilium": "kube-system": "hubble-ui": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			"traefik.ingress.kubernetes.io/router.tls":         "true"
		}
		name:      "hubble-ui"
		namespace: "kube-system"
	}
	spec: {
		ingressClassName: "traefik"
		rules: [{
			host: "hubble.district.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "hubble-ui"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}]
	}
}
