package y

res: namespace: "k3d-dfd-cluster-mastodon": cluster: mastodon: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "mastodon"
}
res: serviceaccount: "k3d-dfd-cluster-mastodon": mastodon: mastodon: {
	apiVersion:                   "v1"
	automountServiceAccountToken: true
	kind:                         "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon"
		namespace: "mastodon"
	}
}
res: serviceaccount: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio": {
	apiVersion:                   "v1"
	automountServiceAccountToken: true
	kind:                         "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio"
		namespace: "mastodon"
	}
	secrets: [{
		name: "mastodon-minio"
	}]
}
res: serviceaccount: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis": {
	apiVersion:                   "v1"
	automountServiceAccountToken: true
	kind:                         "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-apache-mastodon-vhost": {
	apiVersion: "v1"
	data: "mastodon-vhost.conf": """
		<VirtualHost 127.0.0.1:8080 _default_:8080>
		  ServerName mastodon.dev.amanibhavam.defn.run
		  ServerAlias *
		  <Location \"/\">
		    ProxyPass http://mastodon-web:80/
		    ProxyPassReverse mastodon.dev.amanibhavam.defn.run
		    ProxyPreserveHost on
		    Order allow,deny
		    Allow from all
		  </Location>
		  <Location \"/api/v1/streaming\">
		    # Streaming uses normal API calls and websockets. We used this configuration
		    # based on https://stackoverflow.com/questions/27526281/websockets-and-apache-proxy-how-to-configure-mod-proxy-wstunnel
		    RewriteEngine On
		    RewriteCond %{HTTP:Upgrade} =websocket [NC]
		    RewriteRule /api/(.*)           ws://mastodon-streaming:80/api/$1 [P,L]
		    RewriteCond %{HTTP:Upgrade} !=websocket [NC]
		    RewriteRule /api/(.*)           http://mastodon-streaming:80/api/$1 [P,L]
		    ProxyPassReverse mastodon.dev.amanibhavam.defn.run
		    Order allow,deny
		    Allow from all
		  </Location>
		  <Location \"/s3storage\">
		    ProxyPass http://mastodon-minio:80/s3storage/
		    ProxyPassReverse mastodon.dev.amanibhavam.defn.run
		    Order allow,deny
		    Allow from all
		  </Location>
		</VirtualHost>
		"""

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-apache-mastodon-vhost"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-default": {
	apiVersion: "v1"
	data: {
		DB_HOST:                   "mastodon-postgresql"
		DB_NAME:                   "bitnami_mastodon"
		DB_PORT:                   "5432"
		DB_USER:                   "bn_mastodon"
		DEFAULT_LOCALE:            "en"
		ES_ENABLED:                "true"
		ES_HOST:                   "mastodon-elasticsearch"
		ES_PORT:                   "9200"
		LOCAL_DOMAIN:              ""
		LOCAL_HTTPS:               "true"
		MASTODON_ADMIN_EMAIL:      "iam@defn.sh"
		MASTODON_ADMIN_USERNAME:   "defn"
		NODE_ENV:                  "production"
		RAILS_ENV:                 "production"
		REDIS_HOST:                "mastodon-redis-master"
		REDIS_PORT:                "6379"
		S3_ALIAS_HOST:             "mastodon.dev.amanibhavam.defn.run/s3storage"
		S3_BUCKET:                 "s3storage"
		S3_ENABLED:                "true"
		S3_ENDPOINT:               "http://mastodon-minio"
		S3_HOSTNAME:               "mastodon-minio"
		S3_PROTOCOL:               "http"
		S3_REGION:                 "us-east-1"
		SMTP_AUTH_METHOD:          "plain"
		SMTP_CA_FILE:              "/etc/ssl/certs/ca-certificates.crt"
		SMTP_DELIVERY_METHOD:      "smtp"
		SMTP_DOMAIN:               ""
		SMTP_ENABLE_STARTTLS_AUTO: "true"
		SMTP_FROM_ADDRESS:         ""
		SMTP_OPENSSL_VERIFY_MODE:  "none"
		SMTP_PORT:                 "587"
		SMTP_REPLY_TO:             ""
		SMTP_SERVER:               ""
		SMTP_TLS:                  "false"
		STREAMING_API_BASE_URL:    "wss://mastodon.dev.amanibhavam.defn.run"
		WEB_DOMAIN:                "mastodon.dev.amanibhavam.defn.run"
	}
	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-default"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-init-scripts": {
	apiVersion: "v1"
	data: {
		"migrate-and-create-admin.sh": """
			#!/bin/bash

			set -o errexit
			set -o nounset
			set -o pipefail

			# Load libraries
			. /opt/bitnami/scripts/liblog.sh
			. /opt/bitnami/scripts/libos.sh
			. /opt/bitnami/scripts/libvalidations.sh
			. /opt/bitnami/scripts/libmastodon.sh

			# Load Mastodon environment variables
			. /opt/bitnami/scripts/mastodon-env.sh
			info \"Migrating database\"
			psql_connection_string=\"postgresql://${MASTODON_DATABASE_USERNAME}:${MASTODON_DATABASE_PASSWORD}@${MASTODON_DATABASE_HOST}:${MASTODON_DATABASE_PORT_NUMBER}/${MASTODON_DATABASE_NAME}\"
			mastodon_wait_for_postgresql_connection \"$psql_connection_string\"
			mastodon_rake_execute db:migrate
			elasticsearch_connection_string=\"http://${MASTODON_ELASTICSEARCH_HOST}:${MASTODON_ELASTICSEARCH_PORT_NUMBER}\"
			mastodon_wait_for_elasticsearch_connection \"$elasticsearch_connection_string\"
			info \"Migrating Elasticsearch\"
			mastodon_rake_execute chewy:upgrade
			mastodon_ensure_admin_user_exists
			"""

		"precompile-assets.sh": """
			#!/bin/bash

			set -o errexit
			set -o nounset
			set -o pipefail

			# Load libraries
			. /opt/bitnami/scripts/liblog.sh
			. /opt/bitnami/scripts/libos.sh
			. /opt/bitnami/scripts/libvalidations.sh
			. /opt/bitnami/scripts/libmastodon.sh

			# Load Mastodon environment variables
			. /opt/bitnami/scripts/mastodon-env.sh
			mastodon_wait_for_s3_connection \"$MASTODON_S3_HOSTNAME\" \"$MASTODON_S3_PORT_NUMBER\"
			info \"Precompiling assets\"
			mastodon_rake_execute assets:precompile
			"""
	}

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-init-scripts"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio-provisioning": {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "minio-provisioning"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio-provisioning"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-configuration": {
	apiVersion: "v1"
	data: {
		"master.conf": """
			dir /data
			# User-supplied master configuration:
			rename-command FLUSHDB \"\"
			rename-command FLUSHALL \"\"
			# End of master configuration
			"""

		"redis.conf": """
			# User-supplied common configuration:
			# Enable AOF https://redis.io/topics/persistence#append-only-file
			appendonly yes
			# Disable RDB persistence, AOF persistence already enabled.
			save \"\"
			# End of common configuration
			"""

		"replica.conf": """
			dir /data
			# User-supplied replica configuration:
			rename-command FLUSHDB \"\"
			rename-command FLUSHALL \"\"
			# End of replica configuration
			"""
	}

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-configuration"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-health": {
	apiVersion: "v1"
	data: {
		"ping_liveness_local.sh": """
			#!/bin/bash

			[[ -f $REDIS_PASSWORD_FILE ]] && export REDIS_PASSWORD=\"$(< \"${REDIS_PASSWORD_FILE}\")\"
			[[ -n \"$REDIS_PASSWORD\" ]] && export REDISCLI_AUTH=\"$REDIS_PASSWORD\"
			response=$(
			  timeout -s 15 $1 \\
			  redis-cli \\
			    -h localhost \\
			    -p $REDIS_PORT \\
			    ping
			)
			if [ \"$?\" -eq \"124\" ]; then
			  echo \"Timed out\"
			  exit 1
			fi
			responseFirstWord=$(echo $response | head -n1 | awk '{print $1;}')
			if [ \"$response\" != \"PONG\" ] && [ \"$responseFirstWord\" != \"LOADING\" ] && [ \"$responseFirstWord\" != \"MASTERDOWN\" ]; then
			  echo \"$response\"
			  exit 1
			fi
			"""

		"ping_liveness_local_and_master.sh": """
			script_dir=\"$(dirname \"$0\")\"
			exit_status=0
			\"$script_dir/ping_liveness_local.sh\" $1 || exit_status=$?
			\"$script_dir/ping_liveness_master.sh\" $1 || exit_status=$?
			exit $exit_status
			"""

		"ping_liveness_master.sh": """
			#!/bin/bash

			[[ -f $REDIS_MASTER_PASSWORD_FILE ]] && export REDIS_MASTER_PASSWORD=\"$(< \"${REDIS_MASTER_PASSWORD_FILE}\")\"
			[[ -n \"$REDIS_MASTER_PASSWORD\" ]] && export REDISCLI_AUTH=\"$REDIS_MASTER_PASSWORD\"
			response=$(
			  timeout -s 15 $1 \\
			  redis-cli \\
			    -h $REDIS_MASTER_HOST \\
			    -p $REDIS_MASTER_PORT_NUMBER \\
			    ping
			)
			if [ \"$?\" -eq \"124\" ]; then
			  echo \"Timed out\"
			  exit 1
			fi
			responseFirstWord=$(echo $response | head -n1 | awk '{print $1;}')
			if [ \"$response\" != \"PONG\" ] && [ \"$responseFirstWord\" != \"LOADING\" ]; then
			  echo \"$response\"
			  exit 1
			fi
			"""

		"ping_readiness_local.sh": """
			#!/bin/bash

			[[ -f $REDIS_PASSWORD_FILE ]] && export REDIS_PASSWORD=\"$(< \"${REDIS_PASSWORD_FILE}\")\"
			[[ -n \"$REDIS_PASSWORD\" ]] && export REDISCLI_AUTH=\"$REDIS_PASSWORD\"
			response=$(
			  timeout -s 15 $1 \\
			  redis-cli \\
			    -h localhost \\
			    -p $REDIS_PORT \\
			    ping
			)
			if [ \"$?\" -eq \"124\" ]; then
			  echo \"Timed out\"
			  exit 1
			fi
			if [ \"$response\" != \"PONG\" ]; then
			  echo \"$response\"
			  exit 1
			fi
			"""

		"ping_readiness_local_and_master.sh": """
			script_dir=\"$(dirname \"$0\")\"
			exit_status=0
			\"$script_dir/ping_readiness_local.sh\" $1 || exit_status=$?
			\"$script_dir/ping_readiness_master.sh\" $1 || exit_status=$?
			exit $exit_status
			"""

		"ping_readiness_master.sh": """
			#!/bin/bash

			[[ -f $REDIS_MASTER_PASSWORD_FILE ]] && export REDIS_MASTER_PASSWORD=\"$(< \"${REDIS_MASTER_PASSWORD_FILE}\")\"
			[[ -n \"$REDIS_MASTER_PASSWORD\" ]] && export REDISCLI_AUTH=\"$REDIS_MASTER_PASSWORD\"
			response=$(
			  timeout -s 15 $1 \\
			  redis-cli \\
			    -h $REDIS_MASTER_HOST \\
			    -p $REDIS_MASTER_PORT_NUMBER \\
			    ping
			)
			if [ \"$?\" -eq \"124\" ]; then
			  echo \"Timed out\"
			  exit 1
			fi
			if [ \"$response\" != \"PONG\" ]; then
			  echo \"$response\"
			  exit 1
			fi
			"""
	}

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-health"
		namespace: "mastodon"
	}
}
res: configmap: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-scripts": {
	apiVersion: "v1"
	data: "start-master.sh": """
		#!/bin/bash

		[[ -f $REDIS_PASSWORD_FILE ]] && export REDIS_PASSWORD=\"$(< \"${REDIS_PASSWORD_FILE}\")\"
		if [[ -f /opt/bitnami/redis/mounted-etc/master.conf ]];then
		    cp /opt/bitnami/redis/mounted-etc/master.conf /opt/bitnami/redis/etc/master.conf
		fi
		if [[ -f /opt/bitnami/redis/mounted-etc/redis.conf ]];then
		    cp /opt/bitnami/redis/mounted-etc/redis.conf /opt/bitnami/redis/etc/redis.conf
		fi
		ARGS=(\"--port\" \"${REDIS_PORT}\")
		ARGS+=(\"--requirepass\" \"${REDIS_PASSWORD}\")
		ARGS+=(\"--masterauth\" \"${REDIS_PASSWORD}\")
		ARGS+=(\"--include\" \"/opt/bitnami/redis/etc/redis.conf\")
		ARGS+=(\"--include\" \"/opt/bitnami/redis/etc/master.conf\")
		exec redis-server \"${ARGS[@]}\"

		"""

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-scripts"
		namespace: "mastodon"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-apache": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "apache"
			"app.kubernetes.io/version":    "2.4.57"
			"helm.sh/chart":                "apache-9.6.5"
		}
		name:      "mastodon-apache"
		namespace: "mastodon"
	}
	spec: {
		loadBalancerSourceRanges: []
		ports: [{
			name:       "http"
			port:       80
			targetPort: "http"
		}, {
			name:       "https"
			port:       443
			targetPort: "https"
		}]
		selector: {
			"app.kubernetes.io/instance": "mastodon"
			"app.kubernetes.io/name":     "apache"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "coordinating-only"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch"
		namespace: "mastodon"
	}
	spec: {
		ports: [{
			name:       "tcp-rest-api"
			port:       9200
			targetPort: "rest-api"
		}, {
			name:     "tcp-transport"
			port:     9300
		}]
		selector: {
			"app.kubernetes.io/component": "coordinating-only"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-coordinating-hl": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "coordinating-only"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-coordinating-hl"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-rest-api"
			port:       9200
			targetPort: "rest-api"
		}, {
			name:       "tcp-transport"
			port:       9300
			targetPort: "transport"
		}]
		publishNotReadyAddresses: true
		selector: {
			"app.kubernetes.io/component": "coordinating-only"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-data-hl": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "data"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-data-hl"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-rest-api"
			port:       9200
			targetPort: "rest-api"
		}, {
			name:       "tcp-transport"
			port:       9300
			targetPort: "transport"
		}]
		publishNotReadyAddresses: true
		selector: {
			"app.kubernetes.io/component": "data"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-ingest-hl": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "ingest"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-ingest-hl"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-rest-api"
			port:       9200
			targetPort: "rest-api"
		}, {
			name:       "tcp-transport"
			port:       9300
			targetPort: "transport"
		}]
		publishNotReadyAddresses: true
		selector: {
			"app.kubernetes.io/component": "ingest"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-master-hl": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "master"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-master-hl"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-rest-api"
			port:       9200
			targetPort: "rest-api"
		}, {
			name:       "tcp-transport"
			port:       9300
			targetPort: "transport"
		}]
		publishNotReadyAddresses: true
		selector: {
			"app.kubernetes.io/component": "master"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio"
		namespace: "mastodon"
	}
	spec: {
		ports: [{
			name:       "minio-api"
			port:       80
			targetPort: "minio-api"
		}, {
			name:       "minio-console"
			port:       9001
			targetPort: "minio-console"
		}]
		selector: {
			"app.kubernetes.io/instance": "mastodon"
			"app.kubernetes.io/name":     "minio"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-postgresql": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "primary"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "postgresql"
			"app.kubernetes.io/version":    "16.0.0"
			"helm.sh/chart":                "postgresql-13.0.0"
		}
		name:      "mastodon-postgresql"
		namespace: "mastodon"
	}
	spec: {
		ports: [{
			name:       "tcp-postgresql"
			port:       5432
			targetPort: "tcp-postgresql"
		}]
		selector: {
			"app.kubernetes.io/component": "primary"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "postgresql"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-postgresql-hl": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: "service.alpha.kubernetes.io/tolerate-unready-endpoints": "true"
		labels: {
			"app.kubernetes.io/component":  "primary"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "postgresql"
			"app.kubernetes.io/version":    "16.0.0"
			"helm.sh/chart":                "postgresql-13.0.0"
		}
		name:      "mastodon-postgresql-hl"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-postgresql"
			port:       5432
			targetPort: "tcp-postgresql"
		}]
		publishNotReadyAddresses: true
		selector: {
			"app.kubernetes.io/component": "primary"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "postgresql"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-headless": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-headless"
		namespace: "mastodon"
	}
	spec: {
		clusterIP: "None"
		ports: [{
			name:       "tcp-redis"
			port:       6379
			targetPort: "redis"
		}]
		selector: {
			"app.kubernetes.io/instance": "mastodon"
			"app.kubernetes.io/name":     "redis"
		}
		type: "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-master": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "master"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-master"
		namespace: "mastodon"
	}
	spec: {
		internalTrafficPolicy: "Cluster"
		ports: [{
			name:       "tcp-redis"
			port:       6379
			targetPort: "redis"
		}]
		selector: {
			"app.kubernetes.io/component": "master"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "redis"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-streaming": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "streaming"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-streaming"
		namespace: "mastodon"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			protocol:   "TCP"
			targetPort: "http"
		}]
		selector: {
			"app.kubernetes.io/component": "streaming"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "mastodon"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: service: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-web": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "web"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-web"
		namespace: "mastodon"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			protocol:   "TCP"
			targetPort: "http"
		}]
		selector: {
			"app.kubernetes.io/component": "web"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "mastodon"
		}
		sessionAffinity: "None"
		type:            "ClusterIP"
	}
}
res: persistentvolumeclaim: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio": {
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio"
		namespace: "mastodon"
	}
	spec: {
		accessModes: [
			"ReadWriteOnce",
		]
		resources: requests: storage: "8Gi"
	}
}
res: deployment: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-apache": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "apache"
			"app.kubernetes.io/version":    "2.4.57"
			"helm.sh/chart":                "apache-9.6.5"
		}
		name:      "mastodon-apache"
		namespace: "mastodon"
	}
	spec: {
		replicas:             1
		revisionHistoryLimit: 10
		selector: matchLabels: {
			"app.kubernetes.io/instance": "mastodon"
			"app.kubernetes.io/name":     "apache"
		}
		strategy: type: "RollingUpdate"
		template: {
			metadata: labels: {
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "apache"
				"app.kubernetes.io/version":    "2.4.57"
				"helm.sh/chart":                "apache-9.6.5"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/instance": "mastodon"
								"app.kubernetes.io/name":     "apache"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "APACHE_HTTP_PORT_NUMBER"
						value: "8080"
					}, {
						name:  "APACHE_HTTPS_PORT_NUMBER"
						value: "8443"
					}]
					image:           "docker.io/bitnami/apache:2.4.57-debian-11-r36"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/api/v1/streaming/health"
							port: "http"
						}
						initialDelaySeconds: 180
						periodSeconds:       20
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "apache"
					ports: [{
						containerPort: 8080
						name:          "http"
					}, {
						containerPort: 8443
						name:          "https"
					}]
					readinessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/api/v1/streaming/health"
							port: "http"
						}
						initialDelaySeconds: 30
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/vhosts"
						name:      "vhosts"
					}]
				}]
				hostAliases: [{
					hostnames: [
						"status.localhost",
					]
					ip: "127.0.0.1"
				}]
				priorityClassName: ""
				securityContext: fsGroup: 1001
				volumes: [{
					configMap: name: "mastodon-apache-mastodon-vhost"
					name: "vhosts"
				}]
			}
		}
	}
}
res: deployment: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio"
		namespace: "mastodon"
	}
	spec: {
		selector: matchLabels: {
			"app.kubernetes.io/instance": "mastodon"
			"app.kubernetes.io/name":     "minio"
		}
		strategy: type: "Recreate"
		template: {
			metadata: labels: {
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "minio"
				"app.kubernetes.io/version":    "2023.9.23"
				"helm.sh/chart":                "minio-12.8.9"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/instance": "mastodon"
								"app.kubernetes.io/name":     "minio"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MINIO_SCHEME"
						value: "http"
					}, {
						name:  "MINIO_FORCE_NEW_KEYS"
						value: "no"
					}, {
						name: "MINIO_ROOT_USER"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MINIO_ROOT_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}, {
						name:  "MINIO_DEFAULT_BUCKETS"
						value: "s3storage"
					}, {
						name:  "MINIO_BROWSER"
						value: "on"
					}, {
						name:  "MINIO_PROMETHEUS_AUTH_TYPE"
						value: "public"
					}, {
						name:  "MINIO_CONSOLE_PORT_NUMBER"
						value: "9001"
					}]
					image:           "docker.io/bitnami/minio:2023.9.23-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 5
						httpGet: {
							path:   "/minio/health/live"
							port:   "minio-api"
							scheme: "HTTP"
						}
						initialDelaySeconds: 5
						periodSeconds:       5
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "minio"
					ports: [{
						containerPort: 9000
						name:          "minio-api"
						protocol:      "TCP"
					}, {
						containerPort: 9001
						name:          "minio-console"
						protocol:      "TCP"
					}]
					readinessProbe: {
						failureThreshold:    5
						initialDelaySeconds: 5
						periodSeconds:       5
						successThreshold:    1
						tcpSocket: port: "minio-api"
						timeoutSeconds: 1
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/bitnami/minio/data"
						name:      "data"
					}]
				}]
				securityContext: fsGroup: 1001
				serviceAccountName: "mastodon-minio"
				volumes: [{
					name: "data"
					persistentVolumeClaim: claimName: "mastodon-minio"
				}]
			}
		}
	}
}
res: deployment: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-sidekiq": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "sidekiq"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-sidekiq"
		namespace: "mastodon"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/component": "sidekiq"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "mastodon"
		}
		strategy: type: "RollingUpdate"
		template: {
			metadata: labels: {
				"app.kubernetes.io/component":  "sidekiq"
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "mastodon"
				"app.kubernetes.io/version":    "4.2.0"
				"helm.sh/chart":                "mastodon-3.0.0"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/component": "sidekiq"
								"app.kubernetes.io/instance":  "mastodon"
								"app.kubernetes.io/name":      "mastodon"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					command: [
						"/opt/bitnami/scripts/mastodon/run.sh",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_MODE"
						value: "sidekiq"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name: "MASTODON_REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}, {
						name: "MASTODON_AWS_ACCESS_KEY_ID"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MASTODON_AWS_SECRET_ACCESS_KEY"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}, {
						name: "SMTP_LOGIN"
						valueFrom: secretKeyRef: {
							key:  "login"
							name: "mastodon-smtp"
						}
					}, {
						name: "SMTP_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-smtp"
						}
					}]
					envFrom: [{
						configMapRef: name: "mastodon-default"
					}, {
						secretRef: name: "mastodon-default"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/bin/sh",
							"-c",
							"pgrep -f ^sidekiq",
						]
						failureThreshold:    6
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "mastodon"
					readinessProbe: {
						exec: command: [
							"/bin/sh",
							"-c",
							"pgrep -f ^sidekiq",
						]
						failureThreshold:    6
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				initContainers: [{
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_web_connection \"http://${MASTODON_WEB_HOST}:${MASTODON_WEB_PORT}\"
		info \"Mastodon web is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_WEB_HOST"
						value: "mastodon-web"
					}, {
						name:  "MASTODON_WEB_PORT"
						value: "80"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-web"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}, {
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_s3_connection \"$MASTODON_S3_HOSTNAME\" \"$MASTODON_S3_PORT_NUMBER\"
		info \"S3 is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_S3_HOSTNAME"
						value: "mastodon-minio"
					}, {
						name:  "MASTODON_S3_PORT_NUMBER"
						value: "80"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-s3"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				securityContext: {
					fsGroup: 1001
					seccompProfile: type: "RuntimeDefault"
				}
				serviceAccountName: "mastodon"
			}
		}
	}
}
res: deployment: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-streaming": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "streaming"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-streaming"
		namespace: "mastodon"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/component": "streaming"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "mastodon"
		}
		strategy: type: "RollingUpdate"
		template: {
			metadata: labels: {
				"app.kubernetes.io/component":  "streaming"
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "mastodon"
				"app.kubernetes.io/version":    "4.2.0"
				"helm.sh/chart":                "mastodon-3.0.0"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/component": "streaming"
								"app.kubernetes.io/instance":  "mastodon"
								"app.kubernetes.io/name":      "mastodon"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					command: [
						"/opt/bitnami/scripts/mastodon/run.sh",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_MODE"
						value: "streaming"
					}, {
						name:  "MASTODON_STREAMING_PORT_NUMBER"
						value: "8080"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name: "MASTODON_REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}, {
						name: "MASTODON_AWS_ACCESS_KEY_ID"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MASTODON_AWS_SECRET_ACCESS_KEY"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}, {
						name: "SMTP_LOGIN"
						valueFrom: secretKeyRef: {
							key:  "login"
							name: "mastodon-smtp"
						}
					}, {
						name: "SMTP_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-smtp"
						}
					}]
					envFrom: [{
						configMapRef: name: "mastodon-default"
					}, {
						secretRef: name: "mastodon-default"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/api/v1/streaming/health"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "mastodon"
					ports: [{
						containerPort: 8080
						name:          "http"
					}]
					readinessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/api/v1/streaming/health"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				initContainers: [{
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_postgresql_connection \"postgresql://${MASTODON_DATABASE_USER}:${MASTODON_DATABASE_PASSWORD:-}@${MASTODON_DATABASE_HOST}:${MASTODON_DATABASE_PORT_NUMBER}/${MASTODON_DATABASE_NAME}\"
		info \"Database is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_DATABASE_HOST"
						value: "mastodon-postgresql"
					}, {
						name:  "MASTODON_DATABASE_PORT_NUMBER"
						value: "5432"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name:  "MASTODON_DATABASE_USER"
						value: "bn_mastodon"
					}, {
						name:  "MASTODON_DATABASE_NAME"
						value: "bitnami_mastodon"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-db"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}, {
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_web_connection \"http://${MASTODON_WEB_HOST}:${MASTODON_WEB_PORT}\"
		info \"Mastodon web is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_WEB_HOST"
						value: "mastodon-web"
					}, {
						name:  "MASTODON_WEB_PORT"
						value: "80"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-web"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				securityContext: {
					fsGroup: 1001
					seccompProfile: type: "RuntimeDefault"
				}
				serviceAccountName: "mastodon"
			}
		}
	}
}
res: deployment: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-web": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "web"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-web"
		namespace: "mastodon"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/component": "web"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "mastodon"
		}
		strategy: type: "RollingUpdate"
		template: {
			metadata: labels: {
				"app.kubernetes.io/component":  "web"
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "mastodon"
				"app.kubernetes.io/version":    "4.2.0"
				"helm.sh/chart":                "mastodon-3.0.0"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/component": "web"
								"app.kubernetes.io/instance":  "mastodon"
								"app.kubernetes.io/name":      "mastodon"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					command: [
						"/opt/bitnami/scripts/mastodon/run.sh",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_MODE"
						value: "web"
					}, {
						name:  "MASTODON_WEB_PORT_NUMBER"
						value: "3000"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name: "MASTODON_REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}, {
						name: "MASTODON_AWS_ACCESS_KEY_ID"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MASTODON_AWS_SECRET_ACCESS_KEY"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}, {
						name: "SMTP_LOGIN"
						valueFrom: secretKeyRef: {
							key:  "login"
							name: "mastodon-smtp"
						}
					}, {
						name: "SMTP_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-smtp"
						}
					}]
					envFrom: [{
						configMapRef: name: "mastodon-default"
					}, {
						secretRef: name: "mastodon-default"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/health"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "mastodon"
					ports: [{
						containerPort: 3000
						name:          "http"
					}]
					readinessProbe: {
						failureThreshold: 6
						httpGet: {
							path: "/health"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				initContainers: [{
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_postgresql_connection \"postgresql://${MASTODON_DATABASE_USER}:${MASTODON_DATABASE_PASSWORD:-}@${MASTODON_DATABASE_HOST}:${MASTODON_DATABASE_PORT_NUMBER}/${MASTODON_DATABASE_NAME}\"
		info \"Database is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_DATABASE_HOST"
						value: "mastodon-postgresql"
					}, {
						name:  "MASTODON_DATABASE_PORT_NUMBER"
						value: "5432"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name:  "MASTODON_DATABASE_USER"
						value: "bn_mastodon"
					}, {
						name:  "MASTODON_DATABASE_NAME"
						value: "bitnami_mastodon"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-db"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}, {
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_redis_connection \"redis://${MASTODON_REDIS_PASSWORD:-}@${MASTODON_REDIS_HOST}:${MASTODON_REDIS_PORT_NUMBER}\"
		info \"Redis(TM) is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_REDIS_HOST"
						value: "mastodon-redis-master"
					}, {
						name:  "MASTODON_REDIS_PORT_NUMBER"
						value: "6379"
					}, {
						name: "MASTODON_REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-redis"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}, {
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_elasticsearch_connection \"http://${MASTODON_ELASTICSEARCH_HOST}:${MASTODON_ELASTICSEARCH_PORT_NUMBER}\"
		info \"Mastodon web is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_ELASTICSEARCH_HOST"
						value: "mastodon-elasticsearch"
					}, {
						name:  "MASTODON_ELASTICSEARCH_PORT_NUMBER"
						value: "9200"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-elasticsearch"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}, {
					command: [
						"bash",
						"-ec",
						"""
		#!/bin/bash

		set -o errexit
		set -o nounset
		set -o pipefail

		. /opt/bitnami/scripts/liblog.sh
		. /opt/bitnami/scripts/libvalidations.sh
		. /opt/bitnami/scripts/libmastodon.sh
		. /opt/bitnami/scripts/mastodon-env.sh

		mastodon_wait_for_s3_connection \"$MASTODON_S3_HOSTNAME\" \"$MASTODON_S3_PORT_NUMBER\"
		info \"S3 is ready\"

		""",
					]

					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_S3_HOSTNAME"
						value: "mastodon-minio"
					}, {
						name:  "MASTODON_S3_PORT_NUMBER"
						value: "80"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-s3"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
				}]
				securityContext: {
					fsGroup: 1001
					seccompProfile: type: "RuntimeDefault"
				}
				serviceAccountName: "mastodon"
			}
		}
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-coordinating": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			app:                            "coordinating-only"
			"app.kubernetes.io/component":  "coordinating-only"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-coordinating"
		namespace: "mastodon"
	}
	spec: {
		podManagementPolicy: "Parallel"
		replicas:            1
		selector: matchLabels: {
			"app.kubernetes.io/component": "coordinating-only"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		serviceName: "mastodon-elasticsearch-coordinating-hl"
		template: {
			metadata: {
				labels: {
					app:                            "coordinating-only"
					"app.kubernetes.io/component":  "coordinating-only"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "elasticsearch"
					"app.kubernetes.io/version":    "8.10.2"
					"helm.sh/chart":                "elasticsearch-19.12.0"
				}
			}
			spec: {
				affinity: {
				}
				containers: [{
					env: [{
						name: "MY_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_NAME"
						value: "elastic"
					}, {
						name:  "ELASTICSEARCH_IS_DEDICATED_NODE"
						value: "yes"
					}, {
						name:  "ELASTICSEARCH_NODE_ROLES"
						value: ""
					}, {
						name:  "ELASTICSEARCH_TRANSPORT_PORT_NUMBER"
						value: "9300"
					}, {
						name:  "ELASTICSEARCH_HTTP_PORT_NUMBER"
						value: "9200"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_HOSTS"
						value: "mastodon-elasticsearch-master-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-coordinating-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-data-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-ingest-hl.mastodon.svc.cluster.local,"
					}, {
						name:  "ELASTICSEARCH_TOTAL_NODES"
						value: "2"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_MASTER_HOSTS"
						value: "mastodon-elasticsearch-master-0"
					}, {
						name:  "ELASTICSEARCH_MINIMUM_MASTER_NODES"
						value: "1"
					}, {
						name:  "ELASTICSEARCH_ADVERTISED_HOSTNAME"
						value: "$(MY_POD_NAME).mastodon-elasticsearch-coordinating-hl.mastodon.svc.cluster.local"
					}, {
						name:  "ELASTICSEARCH_HEAP_SIZE"
						value: "128m"
					}]
					image:           "docker.io/bitnami/elasticsearch:8.10.2-debian-11-r6"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 180
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "elasticsearch"
					ports: [{
						containerPort: 9200
						name:          "rest-api"
					}, {
						containerPort: 9300
						name:          "transport"
					}]
					readinessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 90
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {
							cpu:    "25m"
							memory: "256Mi"
						}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/bitnami/elasticsearch/data"
						name:      "data"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/bash",
						"-ec",
						"""
		CURRENT=`sysctl -n vm.max_map_count`;
		DESIRED=\"262144\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w vm.max_map_count=262144;
		fi;
		CURRENT=`sysctl -n fs.file-max`;
		DESIRED=\"65536\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w fs.file-max=65536;
		fi;

		""",
					]

					image:           "docker.io/bitnami/os-shell:11-debian-11-r77"
					imagePullPolicy: "IfNotPresent"
					name:            "sysctl"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						privileged: true
						runAsUser:  0
					}
				}]
				securityContext: fsGroup: 1001
				serviceAccountName: "default"
				volumes: [{
					emptyDir: {}
					name: "data"
				}]
			}
		}
		updateStrategy: type: "RollingUpdate"
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-data": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			app:                            "data"
			"app.kubernetes.io/component":  "data"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-data"
		namespace: "mastodon"
	}
	spec: {
		podManagementPolicy: "Parallel"
		replicas:            1
		selector: matchLabels: {
			"app.kubernetes.io/component": "data"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		serviceName: "mastodon-elasticsearch-data-hl"
		template: {
			metadata: {
				labels: {
					app:                            "data"
					"app.kubernetes.io/component":  "data"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "elasticsearch"
					"app.kubernetes.io/version":    "8.10.2"
					"helm.sh/chart":                "elasticsearch-19.12.0"
				}
			}
			spec: {
				affinity: {
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name: "MY_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name:  "ELASTICSEARCH_IS_DEDICATED_NODE"
						value: "yes"
					}, {
						name:  "ELASTICSEARCH_NODE_ROLES"
						value: "data"
					}, {
						name:  "ELASTICSEARCH_TRANSPORT_PORT_NUMBER"
						value: "9300"
					}, {
						name:  "ELASTICSEARCH_HTTP_PORT_NUMBER"
						value: "9200"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_NAME"
						value: "elastic"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_HOSTS"
						value: "mastodon-elasticsearch-master-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-coordinating-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-data-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-ingest-hl.mastodon.svc.cluster.local,"
					}, {
						name:  "ELASTICSEARCH_TOTAL_NODES"
						value: "2"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_MASTER_HOSTS"
						value: "mastodon-elasticsearch-master-0"
					}, {
						name:  "ELASTICSEARCH_MINIMUM_MASTER_NODES"
						value: "1"
					}, {
						name:  "ELASTICSEARCH_ADVERTISED_HOSTNAME"
						value: "$(MY_POD_NAME).mastodon-elasticsearch-data-hl.mastodon.svc.cluster.local"
					}, {
						name:  "ELASTICSEARCH_HEAP_SIZE"
						value: "1024m"
					}]
					image:           "docker.io/bitnami/elasticsearch:8.10.2-debian-11-r6"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 180
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "elasticsearch"
					ports: [{
						containerPort: 9200
						name:          "rest-api"
					}, {
						containerPort: 9300
						name:          "transport"
					}]
					readinessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 90
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {
							cpu:    "25m"
							memory: "2048Mi"
						}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/bitnami/elasticsearch/data"
						name:      "data"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/bash",
						"-ec",
						"""
		CURRENT=`sysctl -n vm.max_map_count`;
		DESIRED=\"262144\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w vm.max_map_count=262144;
		fi;
		CURRENT=`sysctl -n fs.file-max`;
		DESIRED=\"65536\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w fs.file-max=65536;
		fi;

		""",
					]

					image:           "docker.io/bitnami/os-shell:11-debian-11-r77"
					imagePullPolicy: "IfNotPresent"
					name:            "sysctl"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						privileged: true
						runAsUser:  0
					}
				}]
				securityContext: fsGroup: 1001
				serviceAccountName: "default"
			}
		}
		updateStrategy: type: "RollingUpdate"
		volumeClaimTemplates: [{
			metadata: name: "data"
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				resources: requests: storage: "8Gi"
			}
		}]
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-ingest": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			app:                            "ingest"
			"app.kubernetes.io/component":  "ingest"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-ingest"
		namespace: "mastodon"
	}
	spec: {
		podManagementPolicy: "Parallel"
		replicas:            1
		selector: matchLabels: {
			"app.kubernetes.io/component": "ingest"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		serviceName: "mastodon-elasticsearch-ingest-hl"
		template: {
			metadata: {
				labels: {
					app:                            "ingest"
					"app.kubernetes.io/component":  "ingest"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "elasticsearch"
					"app.kubernetes.io/version":    "8.10.2"
					"helm.sh/chart":                "elasticsearch-19.12.0"
				}
			}
			spec: {
				affinity: {
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name: "MY_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name:  "ELASTICSEARCH_IS_DEDICATED_NODE"
						value: "yes"
					}, {
						name:  "ELASTICSEARCH_NODE_ROLES"
						value: "ingest"
					}, {
						name:  "ELASTICSEARCH_TRANSPORT_PORT_NUMBER"
						value: "9300"
					}, {
						name:  "ELASTICSEARCH_HTTP_PORT_NUMBER"
						value: "9200"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_NAME"
						value: "elastic"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_HOSTS"
						value: "mastodon-elasticsearch-master-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-coordinating-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-data-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-ingest-hl.mastodon.svc.cluster.local,"
					}, {
						name:  "ELASTICSEARCH_TOTAL_NODES"
						value: "2"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_MASTER_HOSTS"
						value: "mastodon-elasticsearch-master-0"
					}, {
						name:  "ELASTICSEARCH_MINIMUM_MASTER_NODES"
						value: "1"
					}, {
						name:  "ELASTICSEARCH_ADVERTISED_HOSTNAME"
						value: "$(MY_POD_NAME).mastodon-elasticsearch-ingest-hl.mastodon.svc.cluster.local"
					}, {
						name:  "ELASTICSEARCH_HEAP_SIZE"
						value: "128m"
					}]
					image:           "docker.io/bitnami/elasticsearch:8.10.2-debian-11-r6"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 180
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "elasticsearch"
					ports: [{
						containerPort: 9200
						name:          "rest-api"
					}, {
						containerPort: 9300
						name:          "transport"
					}]
					readinessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 90
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {
							cpu:    "25m"
							memory: "256Mi"
						}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/bitnami/elasticsearch/data"
						name:      "data"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/bash",
						"-ec",
						"""
		CURRENT=`sysctl -n vm.max_map_count`;
		DESIRED=\"262144\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w vm.max_map_count=262144;
		fi;
		CURRENT=`sysctl -n fs.file-max`;
		DESIRED=\"65536\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w fs.file-max=65536;
		fi;

		""",
					]

					image:           "docker.io/bitnami/os-shell:11-debian-11-r77"
					imagePullPolicy: "IfNotPresent"
					name:            "sysctl"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						privileged: true
						runAsUser:  0
					}
				}]
				securityContext: fsGroup: 1001
				serviceAccountName: "default"
				volumes: [{
					emptyDir: {}
					name: "data"
				}]
			}
		}
		updateStrategy: type: "RollingUpdate"
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-elasticsearch-master": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			app:                            "master"
			"app.kubernetes.io/component":  "master"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "elasticsearch"
			"app.kubernetes.io/version":    "8.10.2"
			"helm.sh/chart":                "elasticsearch-19.12.0"
		}
		name:      "mastodon-elasticsearch-master"
		namespace: "mastodon"
	}
	spec: {
		podManagementPolicy: "Parallel"
		replicas:            1
		selector: matchLabels: {
			"app.kubernetes.io/component": "master"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "elasticsearch"
		}
		serviceName: "mastodon-elasticsearch-master-hl"
		template: {
			metadata: {
				labels: {
					app:                            "master"
					"app.kubernetes.io/component":  "master"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "elasticsearch"
					"app.kubernetes.io/version":    "8.10.2"
					"helm.sh/chart":                "elasticsearch-19.12.0"
				}
			}
			spec: {
				affinity: {
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name: "MY_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name:  "ELASTICSEARCH_IS_DEDICATED_NODE"
						value: "yes"
					}, {
						name:  "ELASTICSEARCH_NODE_ROLES"
						value: "master"
					}, {
						name:  "ELASTICSEARCH_TRANSPORT_PORT_NUMBER"
						value: "9300"
					}, {
						name:  "ELASTICSEARCH_HTTP_PORT_NUMBER"
						value: "9200"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_NAME"
						value: "elastic"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_HOSTS"
						value: "mastodon-elasticsearch-master-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-coordinating-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-data-hl.mastodon.svc.cluster.local,mastodon-elasticsearch-ingest-hl.mastodon.svc.cluster.local,"
					}, {
						name:  "ELASTICSEARCH_TOTAL_NODES"
						value: "2"
					}, {
						name:  "ELASTICSEARCH_CLUSTER_MASTER_HOSTS"
						value: "mastodon-elasticsearch-master-0"
					}, {
						name:  "ELASTICSEARCH_MINIMUM_MASTER_NODES"
						value: "1"
					}, {
						name:  "ELASTICSEARCH_ADVERTISED_HOSTNAME"
						value: "$(MY_POD_NAME).mastodon-elasticsearch-master-hl.mastodon.svc.cluster.local"
					}, {
						name:  "ELASTICSEARCH_HEAP_SIZE"
						value: "128m"
					}]
					image:           "docker.io/bitnami/elasticsearch:8.10.2-debian-11-r6"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 180
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "elasticsearch"
					ports: [{
						containerPort: 9200
						name:          "rest-api"
					}, {
						containerPort: 9300
						name:          "transport"
					}]
					readinessProbe: {
						exec: command: [
							"/opt/bitnami/scripts/elasticsearch/healthcheck.sh",
						]
						failureThreshold:    5
						initialDelaySeconds: 90
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/bitnami/elasticsearch/data"
						name:      "data"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/bash",
						"-ec",
						"""
		CURRENT=`sysctl -n vm.max_map_count`;
		DESIRED=\"262144\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w vm.max_map_count=262144;
		fi;
		CURRENT=`sysctl -n fs.file-max`;
		DESIRED=\"65536\";
		if [ \"$DESIRED\" -gt \"$CURRENT\" ]; then
		    sysctl -w fs.file-max=65536;
		fi;

		""",
					]

					image:           "docker.io/bitnami/os-shell:11-debian-11-r77"
					imagePullPolicy: "IfNotPresent"
					name:            "sysctl"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						privileged: true
						runAsUser:  0
					}
				}]
				securityContext: fsGroup: 1001
				serviceAccountName: "default"
			}
		}
		updateStrategy: type: "RollingUpdate"
		volumeClaimTemplates: [{
			metadata: name: "data"
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				resources: requests: storage: "8Gi"
			}
		}]
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-postgresql": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "primary"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "postgresql"
			"app.kubernetes.io/version":    "16.0.0"
			"helm.sh/chart":                "postgresql-13.0.0"
		}
		name:      "mastodon-postgresql"
		namespace: "mastodon"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/component": "primary"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "postgresql"
		}
		serviceName: "mastodon-postgresql-hl"
		template: {
			metadata: {
				labels: {
					"app.kubernetes.io/component":  "primary"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "postgresql"
					"app.kubernetes.io/version":    "16.0.0"
					"helm.sh/chart":                "postgresql-13.0.0"
				}
				name: "mastodon-postgresql"
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/component": "primary"
								"app.kubernetes.io/instance":  "mastodon"
								"app.kubernetes.io/name":      "postgresql"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				containers: [{
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "POSTGRESQL_PORT_NUMBER"
						value: "5432"
					}, {
						name:  "POSTGRESQL_VOLUME_DIR"
						value: "/bitnami/postgresql"
					}, {
						name:  "PGDATA"
						value: "/bitnami/postgresql/data"
					}, {
						name:  "POSTGRES_USER"
						value: "bn_mastodon"
					}, {
						name: "POSTGRES_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name: "POSTGRES_POSTGRES_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "postgres-password"
							name: "mastodon-postgresql"
						}
					}, {
						name:  "POSTGRES_DATABASE"
						value: "bitnami_mastodon"
					}, {
						name:  "POSTGRESQL_ENABLE_LDAP"
						value: "no"
					}, {
						name:  "POSTGRESQL_ENABLE_TLS"
						value: "no"
					}, {
						name:  "POSTGRESQL_LOG_HOSTNAME"
						value: "false"
					}, {
						name:  "POSTGRESQL_LOG_CONNECTIONS"
						value: "false"
					}, {
						name:  "POSTGRESQL_LOG_DISCONNECTIONS"
						value: "false"
					}, {
						name:  "POSTGRESQL_PGAUDIT_LOG_CATALOG"
						value: "off"
					}, {
						name:  "POSTGRESQL_CLIENT_MIN_MESSAGES"
						value: "error"
					}, {
						name:  "POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
						value: "pgaudit"
					}]
					image:           "docker.io/bitnami/postgresql:16.0.0-debian-11-r3"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"/bin/sh",
							"-c",
							"exec pg_isready -U \"bn_mastodon\" -d \"dbname=bitnami_mastodon\" -h 127.0.0.1 -p 5432",
						]

						failureThreshold:    6
						initialDelaySeconds: 30
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "postgresql"
					ports: [{
						containerPort: 5432
						name:          "tcp-postgresql"
					}]
					readinessProbe: {
						exec: command: [
							"/bin/sh",
							"-c",
							"-e",
							"""
		exec pg_isready -U \"bn_mastodon\" -d \"dbname=bitnami_mastodon\" -h 127.0.0.1 -p 5432
		[ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]

		""",
						]

						failureThreshold:    6
						initialDelaySeconds: 5
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					resources: {
						limits: {}
						requests: {
							cpu:    "250m"
							memory: "256Mi"
						}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						runAsGroup:   0
						runAsNonRoot: true
						runAsUser:    1001
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/dev/shm"
						name:      "dshm"
					}, {
						mountPath: "/bitnami/postgresql"
						name:      "data"
					}]
				}]
				hostIPC:     false
				hostNetwork: false
				securityContext: fsGroup: 1001
				serviceAccountName: "default"
				volumes: [{
					emptyDir: medium: "Memory"
					name: "dshm"
				}]
			}
		}
		updateStrategy: {
			rollingUpdate: {}
			type: "RollingUpdate"
		}
		volumeClaimTemplates: [{
			apiVersion: "v1"
			kind:       "PersistentVolumeClaim"
			metadata: name: "data"
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				resources: requests: storage: "8Gi"
			}
		}]
	}
}
res: statefulset: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis-master": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			"app.kubernetes.io/component":  "master"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "redis"
			"app.kubernetes.io/version":    "7.2.1"
			"helm.sh/chart":                "redis-18.1.0"
		}
		name:      "mastodon-redis-master"
		namespace: "mastodon"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/component": "master"
			"app.kubernetes.io/instance":  "mastodon"
			"app.kubernetes.io/name":      "redis"
		}
		serviceName: "mastodon-redis-headless"
		template: {
			metadata: {
				annotations: {
					"checksum/configmap": "86bcc953bb473748a3d3dc60b7c11f34e60c93519234d4c37f42e22ada559d47"
					"checksum/health":    "aff24913d801436ea469d8d374b2ddb3ec4c43ee7ab24663d5f8ff1a1b6991a9"
					"checksum/scripts":   "560c33ff34d845009b51830c332aa05fa211444d1877d3526d3599be7543aaa5"
					"checksum/secret":    "44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a"
				}
				labels: {
					"app.kubernetes.io/component":  "master"
					"app.kubernetes.io/instance":   "mastodon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "redis"
					"app.kubernetes.io/version":    "7.2.1"
					"helm.sh/chart":                "redis-18.1.0"
				}
			}
			spec: {
				affinity: {
					podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
						podAffinityTerm: {
							labelSelector: matchLabels: {
								"app.kubernetes.io/component": "master"
								"app.kubernetes.io/instance":  "mastodon"
								"app.kubernetes.io/name":      "redis"
							}
							topologyKey: "kubernetes.io/hostname"
						}
						weight: 1
					}]
				}
				automountServiceAccountToken: true
				containers: [{
					args: [
						"-c",
						"/opt/bitnami/scripts/start-scripts/start-master.sh",
					]
					command: [
						"/bin/bash",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "REDIS_REPLICATION_MODE"
						value: "master"
					}, {
						name:  "ALLOW_EMPTY_PASSWORD"
						value: "no"
					}, {
						name: "REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}, {
						name:  "REDIS_TLS_ENABLED"
						value: "no"
					}, {
						name:  "REDIS_PORT"
						value: "6379"
					}]
					image:           "docker.io/bitnami/redis:7.2.1-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"sh",
							"-c",
							"/health/ping_liveness_local.sh 5",
						]
						failureThreshold:    5
						initialDelaySeconds: 20
						periodSeconds:       5
						successThreshold:    1
						timeoutSeconds:      6
					}
					name: "redis"
					ports: [{
						containerPort: 6379
						name:          "redis"
					}]
					readinessProbe: {
						exec: command: [
							"sh",
							"-c",
							"/health/ping_readiness_local.sh 1",
						]
						failureThreshold:    5
						initialDelaySeconds: 20
						periodSeconds:       5
						successThreshold:    1
						timeoutSeconds:      2
					}
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						runAsGroup:   0
						runAsNonRoot: true
						runAsUser:    1001
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/opt/bitnami/scripts/start-scripts"
						name:      "start-scripts"
					}, {
						mountPath: "/health"
						name:      "health"
					}, {
						mountPath: "/data"
						name:      "redis-data"
					}, {
						mountPath: "/opt/bitnami/redis/mounted-etc"
						name:      "config"
					}, {
						mountPath: "/opt/bitnami/redis/etc/"
						name:      "redis-tmp-conf"
					}, {
						mountPath: "/tmp"
						name:      "tmp"
					}]
				}]
				enableServiceLinks: true
				securityContext: fsGroup: 1001
				serviceAccountName:            "mastodon-redis"
				terminationGracePeriodSeconds: 30
				volumes: [{
					configMap: {
						defaultMode: 493
						name:        "mastodon-redis-scripts"
					}
					name: "start-scripts"
				}, {
					configMap: {
						defaultMode: 493
						name:        "mastodon-redis-health"
					}
					name: "health"
				}, {
					configMap: name: "mastodon-redis-configuration"
					name: "config"
				}, {
					emptyDir: {}
					name: "redis-tmp-conf"
				}, {
					emptyDir: {}
					name: "tmp"
				}]
			}
		}
		updateStrategy: type: "RollingUpdate"
		volumeClaimTemplates: [{
			apiVersion: "v1"
			kind:       "PersistentVolumeClaim"
			metadata: {
				labels: {
					"app.kubernetes.io/component": "master"
					"app.kubernetes.io/instance":  "mastodon"
					"app.kubernetes.io/name":      "redis"
				}
				name: "redis-data"
			}
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				resources: requests: storage: "8Gi"
			}
		}]
	}
}
res: job: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-init": {
	apiVersion: "batch/v1"
	kind:       "Job"
	metadata: {
		annotations: {
			"argocd.argoproj.io/hook":               "Sync"
			"argocd.argoproj.io/hook-delete-policy": "BeforeHookCreation,HookSucceeded"
			"argocd.argoproj.io/sync-wave":          "0"
			"helm.sh/hook":                          "post-install, pre-upgrade"
			"helm.sh/hook-delete-policy":            "before-hook-creation,hook-succeeded"
			"helm.sh/hook-weight":                   "10"
		}
		labels: {
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "mastodon"
			"app.kubernetes.io/part-of":    "mastodon"
			"app.kubernetes.io/version":    "4.2.0"
			"helm.sh/chart":                "mastodon-3.0.0"
		}
		name:      "mastodon-init"
		namespace: "mastodon"
	}
	spec: {
		backoffLimit: 10
		template: {
			metadata: labels: {
				"app.kubernetes.io/component":  "init"
				"app.kubernetes.io/instance":   "mastodon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "mastodon"
				"app.kubernetes.io/version":    "4.2.0"
				"helm.sh/chart":                "mastodon-3.0.0"
			}
			spec: {
				containers: [{
					args: [
						"/scripts/migrate-and-create-admin.sh",
					]
					command: [
						"/bin/bash",
						"-ec",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name: "MASTODON_DATABASE_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "password"
							name: "mastodon-postgresql"
						}
					}, {
						name: "MASTODON_REDIS_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "redis-password"
							name: "mastodon-redis"
						}
					}]
					envFrom: [{
						configMapRef: name: "mastodon-default"
					}, {
						secretRef: name: "mastodon-default"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "migrate-and-create-admin"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
					volumeMounts: [{
						mountPath: "/scripts"
						name:      "scripts"
					}]
				}, {
					args: [
						"/scripts/precompile-assets.sh",
					]
					command: [
						"/bin/bash",
						"-ec",
					]
					env: [{
						name:  "BITNAMI_DEBUG"
						value: "false"
					}, {
						name:  "MASTODON_S3_HOSTNAME"
						value: "mastodon-minio"
					}, {
						name:  "MASTODON_S3_PORT_NUMBER"
						value: "80"
					}, {
						name: "MASTODON_AWS_ACCESS_KEY_ID"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MASTODON_AWS_SECRET_ACCESS_KEY"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}]
					envFrom: [{
						configMapRef: name: "mastodon-default"
					}, {
						secretRef: name: "mastodon-default"
					}]
					image:           "docker.io/bitnami/mastodon:4.2.0-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "mastodon-assets-precompile"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
						readOnlyRootFilesystem: false
						runAsNonRoot:           true
						runAsUser:              1001
					}
					volumeMounts: [{
						mountPath: "/scripts"
						name:      "scripts"
					}]
				}]
				restartPolicy: "OnFailure"
				securityContext: {
					fsGroup: 1001
					seccompProfile: type: "RuntimeDefault"
				}
				volumes: [{
					configMap: {
						defaultMode: 493
						name:        "mastodon-init-scripts"
					}
					name: "scripts"
				}]
			}
		}
	}
}
res: job: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio-provisioning": {
	apiVersion: "batch/v1"
	kind:       "Job"
	metadata: {
		annotations: {
			"helm.sh/hook":               "post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation"
		}
		labels: {
			"app.kubernetes.io/component":  "minio-provisioning"
			"app.kubernetes.io/instance":   "mastodon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "minio"
			"app.kubernetes.io/version":    "2023.9.23"
			"helm.sh/chart":                "minio-12.8.9"
		}
		name:      "mastodon-minio-provisioning"
		namespace: "mastodon"
	}
	spec: {
		parallelism: 1
		template: {
			metadata: labels: {
				"app.kubernetes.io/component":  "minio-provisioning"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/version":    "2023.9.23"
				"helm.sh/chart":                "minio-12.8.9"
			}
			spec: {
				containers: [{
					command: [
						"/bin/bash",
						"-c",
						"""
		set -e; echo \"Start Minio provisioning\";
		function attachPolicy() {

		  local tmp=$(mc admin $1 info provisioning $2 | sed -n -e 's/^Policy.*: \\(.*\\)$/\\1/p');
		  IFS=',' read -r -a CURRENT_POLICIES <<< \"$tmp\";
		  if [[ ! \"${CURRENT_POLICIES[*]}\" =~ \"$3\" ]]; then
		    mc admin policy attach provisioning $3 --$1=$2;
		  fi;
		};
		function detachDanglingPolicies() {

		  local tmp=$(mc admin $1 info provisioning $2 | sed -n -e 's/^Policy.*: \\(.*\\)$/\\1/p');
		  IFS=',' read -r -a CURRENT_POLICIES <<< \"$tmp\";
		  IFS=',' read -r -a DESIRED_POLICIES <<< \"$3\";
		  for current in \"${CURRENT_POLICIES[@]}\"; do
		    if [[ ! \"${DESIRED_POLICIES[*]}\" =~ \"${current}\" ]]; then
		      mc admin policy detach provisioning $current --$1=$2;
		    fi;
		  done;
		}
		function addUsersFromFile() {

		  local username=$(grep -oP '^username=\\K.+' $1);
		  local password=$(grep -oP '^password=\\K.+' $1);
		  local disabled=$(grep -oP '^disabled=\\K.+' $1);
		  local policies_list=$(grep -oP '^policies=\\K.+' $1);
		  local set_policies=$(grep -oP '^setPolicies=\\K.+' $1);

		  mc admin user add provisioning \"${username}\" \"${password}\";

		  IFS=',' read -r -a POLICIES <<< \"${policies_list}\";
		  for policy in \"${POLICIES[@]}\"; do
		    attachPolicy user \"${username}\" \"${policy}\";
		  done;
		  if [ \"${set_policies}\" == \"true\" ]; then
		    detachDanglingPolicies user \"${username}\" \"${policies_list}\";
		  fi;

		  local user_status=\"enable\";
		  if [[ \"${disabled}\" != \"\" && \"${disabled,,}\" == \"true\" ]]; then
		    user_status=\"disable\";
		  fi;

		  mc admin user \"${user_status}\" provisioning \"${username}\";
		}; mc alias set provisioning $MINIO_SCHEME://mastodon-minio:80 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD;
		mc admin service restart provisioning;
		mc anonymous set download provisioning/s3storage;
		echo \"End Minio provisioning\";
		""",
					]

					env: [{
						name:  "MINIO_SCHEME"
						value: "http"
					}, {
						name: "MINIO_ROOT_USER"
						valueFrom: secretKeyRef: {
							key:  "root-user"
							name: "mastodon-minio"
						}
					}, {
						name: "MINIO_ROOT_PASSWORD"
						valueFrom: secretKeyRef: {
							key:  "root-password"
							name: "mastodon-minio"
						}
					}]
					image:           "docker.io/bitnami/minio:2023.9.23-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "minio"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
					volumeMounts: [{
						mountPath: "/etc/ilm"
						name:      "minio-provisioning"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/bash",
						"-c",
						"""
		set -e;
		echo \"Waiting for Minio\";
		wait-for-port \\
		  --host=mastodon-minio \\
		  --state=inuse \\
		  --timeout=120 \\
		  80;
		echo \"Minio is available\";
		""",
					]

					image:           "docker.io/bitnami/minio:2023.9.23-debian-11-r0"
					imagePullPolicy: "IfNotPresent"
					name:            "wait-for-available-minio"
					resources: {
						limits: {}
						requests: {}
					}
					securityContext: {
						runAsNonRoot: true
						runAsUser:    1001
					}
				}]
				restartPolicy: "OnFailure"
				securityContext: fsGroup: 1001
				serviceAccountName:            "mastodon-minio"
				terminationGracePeriodSeconds: 0
				volumes: [{
					configMap: name: "mastodon-minio-provisioning"
					name: "minio-provisioning"
				}]
			}
		}
	}
}
res: externalsecret: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-default": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "mastodon-default"
		namespace: "mastodon"
	}
	spec: {
		data: [{
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_admin_password"
			}
			secretKey: "MASTODON_ADMIN_PASSWORD"
		}, {
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_otp_secret"
			}
			secretKey: "OTP_SECRET"
		}, {
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_secret_key_base"
			}
			secretKey: "SECRET_KEY_BASE"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "k3d-dfd"
		}
		target: {
			creationPolicy: "Owner"
			name:           "mastodon-default"
		}
	}
}
res: externalsecret: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-minio": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "mastodon-minio"
		namespace: "mastodon"
	}
	spec: {
		data: [{
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_minio_root_password"
			}
			secretKey: "root-password"
		}, {
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_minio_root_user"
			}
			secretKey: "root-user"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "k3d-dfd"
		}
		target: {
			creationPolicy: "Owner"
			name:           "mastodon-minio"
		}
	}
}
res: externalsecret: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-postgresql": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "mastodon-postgresql"
		namespace: "mastodon"
	}
	spec: {
		data: [{
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_postgresql_password"
			}
			secretKey: "password"
		}, {
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_postgresql_postgres_password"
			}
			secretKey: "postgres-password"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "k3d-dfd"
		}
		target: {
			creationPolicy: "Owner"
			name:           "mastodon-postgresql"
		}
	}
}
res: externalsecret: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-redis": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "mastodon-redis"
		namespace: "mastodon"
	}
	spec: {
		data: [{
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_redis_password"
			}
			secretKey: "redis-password"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "k3d-dfd"
		}
		target: {
			creationPolicy: "Owner"
			name:           "mastodon-redis"
		}
	}
}
res: externalsecret: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-smtp": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "mastodon-smtp"
		namespace: "mastodon"
	}
	spec: {
		data: [{
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_smtp_login"
			}
			secretKey: "login"
		}, {
			remoteRef: {
				key:      "k3d-dfd"
				property: "mastodon_smtp_password"
			}
			secretKey: "password"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "k3d-dfd"
		}
		target: {
			creationPolicy: "Owner"
			name:           "mastodon-smtp"
		}
	}
}
res: ingress: "k3d-dfd-cluster-mastodon": mastodon: "mastodon-apache": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			"traefik.ingress.kubernetes.io/router.tls":         "true"
		}
		name:      "mastodon-apache"
		namespace: "mastodon"
	}
	spec: {
		ingressClassName: "traefik"
		rules: [{
			host: "mastodon.dev.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "mastodon-apache"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}]
	}
}
