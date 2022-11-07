package workflows

#DockerJob: {
	"runs-on": "ubuntu-latest"

	env: FORCE_COLOR: 1

	steps: [...{...}]

	needs?: [...string] | string
}

#DockerSteps: [{
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
}, {
	name: "Set up QEMU"
	id:   "qemu"
	uses: "docker/setup-qemu-action@v1"
	with: {
		image:     "tonistiigi/binfmt:latest"
		platforms: "all"
	}
}, {
	name: "Set up Docker Buildx"
	id:   "buildx"
	uses: "docker/setup-buildx-action@v2"
}]
