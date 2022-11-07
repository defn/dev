package workflows

name: "CI"

on: push: branches: [
	"main",
]

on: push: tags: [
	"v**",
]

on: pull_request: {}

jobs: [string]: #DockerJob

jobs: {
	build_nix_amd: {
		steps: #DockerSteps + [{
			name: "Build nix amd target"
			run: """
				make docker-nix \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-nix \\
					platform=linux/amd64 \\
					arch=amd64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-nix
				"""
		}]
	}

	build_nix_arm: {
		steps: #DockerSteps + [{
			name: "Build nix arm target"
			run: """
				make docker-nix \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-nix \\
					platform=linux/arm64 \\
					arch=arm64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-nix
				"""
		}]
	}

	build_amd: {
		needs: [ "build_nix_amd"]
		steps: #DockerSteps + [{
			name: "Build amd target"
			run: """
				make docker-dev \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					platform=linux/amd64 \\
					arch=amd64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd
				"""
		}]
	}

	build_arm: {
		needs: [ "build_nix_arm"]
		steps: #DockerSteps + [{
			name: "Build arm target"
			run: """
				make docker-dev \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					platform=linux/arm64 \\
					arch=arm64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm
				"""
		}]
	}

	build_k3d_amd: {
		needs: [ "build_nix_amd"]
		steps: #DockerSteps + [{
			name: "Build amd k3d-base target"
			run: """
				make docker-k3d \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d \\
					platform=linux/amd64 \\
					arch=amd64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d
				"""
		}]
	}

	build_k3d_arm: {
		needs: [ "build_nix_arm"]
		steps: #DockerSteps + [{
			name: "Build arm k3d-base target"
			run: """
				make docker-k3d \\
					cache="--cache-from=type=gha --cache-to=gha" \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d \\
					platform=linux/arm64 \\
					arch=arm64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d
				"""
		}]
	}
}
