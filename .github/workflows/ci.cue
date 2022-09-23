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
				earthly --strict --push --no-output --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd --remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd +build-amd
				"""
		}]
	}

	buildArm: {
		steps: #EarthlySteps + [{
			name: "Build arm target"
			run: """
				earthly --strict --push --no-output --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm --remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm +build-arm
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
				earthly --strict --push --no-output --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-amd --cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-arm +images --repo=ghcr.io/ --tag=${TAG}
				"""
		}]
	}
}
