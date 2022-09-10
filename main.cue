package dev

import (
	"github.com/defn/boot/project"
)

#BootContext: {
	project.#Project
}

bootContext: #BootContext & {
	codeowners: ["@jojomomojo", "@amanibhavam"]
}
