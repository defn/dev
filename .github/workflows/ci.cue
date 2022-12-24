package workflows

name: "CI"

on: push: {
	branches: [ "main"]
	tags: [ "v**"]
}

on: pull_request: {}

jobs: [string]: #EarthlyJob

jobs: {
	"publish_fly": #PublishBuild & {
		_n: "fly"
	}

	"publish_devcontainer": #PublishBuild & {
		_n:    "devcontainer"
		needs: "publish_fly"
	}

	"publish_k3d": #PublishBuild & {
		_n:    "k3d"
		needs: "publish_devcontainer"
	}
}
