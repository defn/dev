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
	for a in ["amd", "arm"] {
		"build_\(a)_dev": {
			steps: #EarthlySteps + [{
				name: "Build \(a) target"
				run:  """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-\(a)-dev \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:${BRANCH}-\(a)-dev \\
					+build-\(a)-dev
				"""
			}]
		}
	}

	for n in ["dev", "k3d", "caddy"] {
		"publish_\(n)": {
			steps: #EarthlySteps + [{
				name: "Publish images"
				run:  """
				earthly --strict --push --no-output \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-amd-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-arm-dev \\
					--cache-from ghcr.io/${GITHUB_REPOSITORY}-cache:main-all-\(n) \\
					--remote-cache ghcr.io/${GITHUB_REPOSITORY}-cache:main-all-\(n)' \\
					+build-\(n) --image ghcr.io/${GITHUB_REPOSITORY}:${TAG}-\(n)
				"""
			}]
		}
	}
}
