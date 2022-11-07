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
	build_amd_dev: {
		steps: #EarthlySteps + [{
			name: "Build amd target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-dev \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd-dev \\
					+build-amd-dev
				"""
		}]
	}

	build_arm_dev: {
		steps: #EarthlySteps + [{
			name: "Build arm target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-dev \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm-dev \\
					+build-arm-dev
				"""
		}]
	}

	publish_dev: {
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-dev \\
					+build-amd-dev +build-arm-dev --image ghcr.io/${GITHUB_REPOSITORY}:${TAG}-dev
				"""
		}]
	}

	build_amd_k3d: {
		steps: #EarthlySteps + [{
			name: "Build amd k3d target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd-k3d \\
					+build-amd-k3d
				"""
		}]
	}

	build_arm_k3d: {
		steps: #EarthlySteps + [{
			name: "Build arm k3d target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm-k3d \\
					+build-arm-k3d
				"""
		}]
	}

	publish_k3d: {
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d \\
					+build-amd-k3d +build-arm-k3d --image ghcr.io/${GITHUB_REPOSITORY}:${TAG}-k3d
				"""
		}]
	}
}
