package workflows

#EarthlyJob: {
	"runs-on": "ubuntu-latest"

	env: FORCE_COLOR: 1

	steps: [...{...}]

	needs?: [...string] | string
}

#EarthlySteps: #DockerLoginSteps + [{
	name: "Download latest earthly"
	run: """
		sudo /bin/sh -c 'wget -q https://github.com/earthly/earthly/releases/download/v0.6.28/earthly-linux-amd64 -O /usr/local/bin/earthly && chmod +x /usr/local/bin/earthly'
		"""
}, {
	name: "Set up QEMU"
	id:   "qemu"
	uses: "docker/setup-qemu-action@v1"
	with: {
		image:     "tonistiigi/binfmt:latest"
		platforms: "all"
	}
}]

#DockerLoginSteps: [{
	name: "Checkout code"
	uses: "actions/checkout@v3"
	with: "fetch-depth": 0
}, {
	name: "Login to Packages Container registry"
	uses: "docker/login-action@v1"
	with: {
		registry: "ghcr.io"
		username: "not-used"
		password: "${{ secrets.GITHUB_TOKEN }}"
	}
}]
