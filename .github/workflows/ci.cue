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
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-all \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-all \\
					+images --repo=ghcr.io/ --tag=${TAG}
				"""
		}]
	}

	build_k3d_amd: {
		steps: #EarthlySteps + [{
			name: "Build amd k3d-base target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-amd \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-amd \\
					+build-amd-k3d-base
				"""
		}]
	}

	build_k3d_arm: {
		steps: #EarthlySteps + [{
			name: "Build arm k3d-base target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-arm \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-arm \\
					+build-arm-k3d-base
				"""
		}]
	}

	publish_k3d: {
		needs: [
			"build_k3d_amd",
			"build_k3d_arm",
		]
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-k3d-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-k3d-arm \\
					+imagesK3DBase --repo=ghcr.io/ --tag=${TAG}
				"""
		}]
	}
}
