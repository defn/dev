package bk

env: {
	BUILDKITE_GIT_MIRRORS_PATH:        "/cache/git"
	BUILDKITE_GIT_MIRRORS_SKIP_UPDATE: "1"
}

branches: "main"

steps: [
	#DockerStep & {
		#label: "bazel-build"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-buildkite-latest"
		#args: ["""
			'
			set -
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			git config --global user.email you@example.com
			git config --global user.name YourName
			bin/persist-cache
			cd m
			echo --- bazel
			export DFD_CI_BAZEL_OPTIONS=--remote_download_minimal
			../bin/b build
			echo
			'
			"""]
	},
	#WaitStep,
	#DockerStep & {
		#label: "test-iam"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-buildkite-latest"
		#args: ["""
			'
			set -
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			git config --global user.email you@example.com
			git config --global user.name YourName
			aws sts get-caller-identity
			'
			"""]
	},
	#WaitStep,
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
			cd m/i/class
			make class-buildkite-latest
			'
			"""]
	},
	#WaitStep,
	#DockerStep & {
		#label: "build-class-latest"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-latest"
		#args: ["""
			'
			set -e
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			cd m/i/class
			make class-latest
			'
			"""]
	}, #DockerStep & {
		#label: "build-buildkite"
		#image: "coder-amanibhavam-district.tail3884f.ts.net:5000/dfd:class-latest"
		#args: ["""
			'
			set -e
			cd
			git fetch
			git reset --hard $BUILDKITE_COMMIT
			source .bash_profile
			cd m/i/class
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
