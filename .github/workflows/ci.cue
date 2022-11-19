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
					--platform linux/\(a)64 \\
					+dev --arch=\(a)64
				"""
			}]
		}
	}

	for n in ["dev", "k3d", "nomad", "caddy"] {
		"publish_\(n)": #PublishBuild & {
			_n: n
		}
	}
}
