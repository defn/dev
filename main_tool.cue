package build

import (
	"github.com/defn/boot"
	"github.com/defn/boot/docker"
)

command: boot.commands & bootContext
command: docker.commands & dockerContext
