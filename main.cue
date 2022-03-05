package build

import (
	"github.com/defn/boot"
	"github.com/defn/boot/docker"
)

#Input: {
	cmd:  string @tag(cmd)
	args: string @tag(args)
	arg1: string @tag(arg1)
	arg2: string @tag(arg2)
	arg3: string @tag(arg3)
	arg4: string @tag(arg4)
	arg5: string @tag(arg5)
	arg6: string @tag(arg6)
	arg7: string @tag(arg7)
	arg8: string @tag(arg8)
	arg9: string @tag(arg9)
	...
}

bootContext: boot.#Boot & {
	#Input

	greeting: "hey"
}

dockerContext: docker.#Docker & {
	#Input

	image: "defn/dev"
}
