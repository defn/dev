package workflows

name: "CI"

on: push: {
	branches: [ "main"]
	tags: [ "v**"]
}

on: pull_request: {}

jobs: [string]: #EarthlyJob

jobs: {
	for n in ["dev", "devcontainer", "fly", "k3d"] {
		"publish_\(n)": #PublishBuild & {
			_n: n
		}
	}
}
