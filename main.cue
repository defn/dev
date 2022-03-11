package build

import (
	"github.com/defn/boot/docker"
	app "github.com/defn/boot/k8s.io/api/apps/v1"
	core "github.com/defn/boot/k8s.io/api/core/v1"
)

a: app.#StatefulSet & {
	metadata: labels: defn: "cool"
}

n: core.#Namespace & {
	metadata: labels: defn: "beans"
}

dockerContext: docker.#Docker & {
	image: "defn/dev"
}
