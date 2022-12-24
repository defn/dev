package workflows

import (
	"strings"
)

name: "CI"

on: {
	push: {
		branches: [ "main"]
		tags: [ "v**"]
	}

	pull_request: {}
}

jobs: [N=string]: #PublishBuild & {
	_n: strings.Split(N, "_")[1]
}

jobs: {
	"publish_fly": {}

	"publish_devcontainer": {
		needs: "publish_fly"
	}

	"publish_k3d": {
		needs: "publish_devcontainer"
	}
}
