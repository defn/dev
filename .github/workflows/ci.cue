package workflows

name: "CI"

on: push: branches: [
	"main",
]

on: push: tags: [
	"v**",
]

on: pull_request: {}

jobs: [string]: #EarthlyJob

jobs: {
	build_amd: {
		steps: #EarthlySteps + [{
			name: "Build amd target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd \\
					+build-amd
				"""
		}]
	}

	build_arm: {
		steps: #EarthlySteps + [{
			name: "Build arm target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm \\
					+build-arm
				"""
		}]
	}

	publish: {
		needs: [
			"build_amd",
			"build_arm",
		]
		steps: #DockerLoginSteps + [{
			name: "Publish images"
			run: """
				docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${TAG} ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm
				docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${TAG}
				"""
		}]
	}

	build_k3d_amd: {
		steps: #EarthlySteps + [{
			name: "Build amd k3d target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-amd \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-amd \\
					+build-amd-k3d
				"""
		}]
	}

	build_k3d_arm: {
		steps: #EarthlySteps + [{
			name: "Build arm k3d target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-arm \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-arm \\
					+build-arm-k3d
				"""
		}]
	}

	publish_k3d: {
		needs: [
			"build_k3d_amd",
			"build_k3d_arm",
		]
		steps: #DockerLoginSteps + [{
			name: "Publish images"
			run: """
				docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${TAG} ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-amd ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-arm
				docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${TAG}
				"""
		}]
	}
}
