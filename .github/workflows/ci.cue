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
	build_amd: {
		steps: #DockerSteps + [{
			name: "Build amd target"
			run: """
				make docker-dev \\
					cache=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					platform=linux/amd64 \\
					arch=amd64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd
				"""
		}]
	}

	build_arm: {
		steps: #DockerSteps + [{
			name: "Build arm target"
			run: """
				make docker-dev \\
					cache=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					platform=linux/arm/v7 \\
					arch=arm64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm
				"""
		}]
	}

	build_k3d_amd: {
		steps: #DockerSteps + [{
			name: "Build amd k3d-base target"
			run: """
				make docker-k3d \\
					cache=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d \\
					platform=linux/amd64 \\
					arch=amd64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d
				"""
		}]
	}

	build_k3d_arm: {
		steps: #DockerSteps + [{
			name: "Build arm k3d-base target"
			run: """
				make docker-k3d \\
					cache=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d \\
					tag=ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d \\
					platform=linux/arm/v7 \\
					arch=arm64
				docker push ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d
				"""
		}]
	}
}
