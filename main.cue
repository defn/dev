package build

import (
	"github.com/defn/boot/docker"
	"github.com/defn/boot/k"
)

a: k.app.#StatefulSet & {
	metadata: labels: defn: "cool"
}

n: k.core.#Namespace & {
	metadata: labels: defn: "beans"
}

dockerContext: docker.#Docker & {
	image: "defn/dev"
}
