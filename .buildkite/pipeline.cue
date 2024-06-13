package bk

env: {
	BUILDKITE_GIT_MIRRORS_PATH:        "/cache/git"
	BUILDKITE_GIT_MIRRORS_SKIP_UPDATE: "1"
}

branches: "main"

steps: [
	{
		label: "nix build"
		command: ["bash", "-c", """
			'
			set -e
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			cd m/pkg
			runmany 10 'cd $1 && nix build && attic push hello result' */
			'
			"""]
	},
]

#steps2: [
	#DockerStep & {
		#label: "build-class-buildkite-latest"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-buildkite-latest"
		#args: ["""
			'
			set -e
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			cd m/i
			make latest-docker
			'
			"""]
	}, #DockerStep & {
		#label: "build-buildkite"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-buildkite-latest"
		#args: ["""
			'
			set -e
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			cd m/i
			make buildkite
			'
			"""]
	},
]

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
