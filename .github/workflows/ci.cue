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
	buildAmd: {
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

	buildArm: {
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

	buildAmdK3DBase: {
		steps: #EarthlySteps + [{
			name: "Build amd k3d-base target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d-base \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd-k3d-base \\
					+build-amd-k3d-base
				"""
		}]
	}

	buildArmK3DBase: {
		steps: #EarthlySteps + [{
			name: "Build arm k3d-base target"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d-base \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm-k3d-base \\
					+build-arm-k3d-base
				"""
		}]
	}

	publish: {
		needs: [
			"buildAmd",
			"buildArm",
		]
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm \\
					+images --repo=ghcr.io/ --tag=${TAG}
				"""
		}]
	}

	publishK3DBase: {
		needs: [
			"buildAmdK3DBase",
			"buildArmK3DBase",
		]
		steps: #EarthlySteps + [{
			name: "Publish images"
			run: """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-k3d-base \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-k3d-base \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd-k3d-base \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm-k3d-base \\
					+imagesK3DBase --repo=ghcr.io/ --tag=${TAG}
				"""
		}]
	}
}
