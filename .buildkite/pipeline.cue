package bk

env: {
	BUILDKITE_GIT_MIRRORS_PATH:        "/cache/git"
	BUILDKITE_GIT_MIRRORS_SKIP_UPDATE: "1"
}

steps: [#DockerStep & {
	#label: "buildkite-docker-image"
	#image: "cache.defn.run:5000/dfd:class-latest"
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
}, #WorkStep & {
	#label: "bazel-build"
	#image: "cache.defn.run:5000/dfd:class-latest"
	#args: ["""
		'
		set -e
		cd
		git fetch
		git reset --hard $BUILDKITE_COMMIT
		source .bash_profile
		git config --global user.email you@example.com
		git config --global user.name YourName
		bin/persist-cache
		cd m
		du -sh ~/work
		echo --- bazel
		export DFD_CI_BAZEL_OPTIONS=--remote_download_minimal
		../bin/b build
		echo --- bazel again
		../bin/b build
		(set +f; ls -ld ~/work ~/work/. ~/work/* || true; du -sh ~/work ~/work/*)
		echo
		'
		"""]
}, #DockerStep & {
	#label: "latest-class-docker-image"
	#image: "cache.defn.run:5000/dfd:class-latest"
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

}, #BashStep & {
	#label: "load-class-docker-image"
	#image: "cache.defn.run:5000/dfd:class-latest"
	#args: ["""
		'
		set -e
		cd
		echo --- git log
		git log | head
		'
		"""]
	depends_on: ["latest-class-docker-image"]
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

#BashStep: {
	#label: string
	#key:   string | *#label
	#image: string
	#args: [...string]
	#depends_on: [...string]
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
	depends_on: #depends_on
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
