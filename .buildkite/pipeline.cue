package bk

import (
	"github.com/defn/dev/m/c/infra"
)

steps: [{
	label:   "trunk check"
	command: "./.buildkite/bin/trunk-check.sh"
}, {
	label:   "bazel build"
	command: "./.buildkite/bin/bazel-build.sh"
}, {
	label:   "home build"
	command: "./.buildkite/bin/home-build.sh"
}, {
	label: "Website deploys"
	plugins: [{
		"monorepo-diff#v1.2.0": {
			diff: "git diff --name-only main"
			watch: [
				for d in infra.domains {
					path: "m/w/sites/\(d)/**"
					config: command: "./.buildkite/deploy-cf-pages.sh m/w/sites/\(d)"
				},
			]
		}
	}]
}]

#RunAsUbuntu: securityContext: {
	runAsNonRoot: true
	runAsUser:    1000
	runAsGroup:   1000
}

#BashContainer: {
	imagePullPolicy: "Always"

	command: ["bash", "-c"]

	#RunAsUbuntu
}

#WaitStep: "wait"

#BashStep: {
	#label: string
	#key:   string | *#label
	#image: string
	#args: [...string]
	#volumeMounts: [...{...}]
	#volumes: [...{...}]

	label: string | *#label
	key:   string | *#key

	plugins: [{
		kubernetes: podSpec: {
			containers: [{
				#BashContainer

				image:        #image
				args:         #args
				volumeMounts: #volumeMounts
			}]
			volumes: #volumes
		}
	}]
}

#DockerStep: #BashStep & {
	#volumeMounts: [{
		name:      "docker-socket"
		mountPath: "/var/run/docker.sock"
	}]

	#volumes: [{
		name: "docker-socket"
		hostPath: path: "/var/run/docker.sock"
	}]
}

#WorkStep: #BashStep & {
	#volumeMounts: [{
		name:      "work"
		mountPath: "/home/ubuntu/work"
	}]

	#volumes: [{
		name: "work"
		emptyDir: {}
	}]
}
