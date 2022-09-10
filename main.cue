package dev

import (
	"github.com/defn/boot/project"
)

#DevContext: {
	project.#Project
}

devContext: #DevContext & {
	codeowners: ["@jojomomojo", "@amanibhavam"]
}
