package build

import (
	"tool/exec"
)

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

command: build: {
	dockerBuild: exec.Run & {
		cmd: ["docker", "build", "-t", "defn/dev", "."]
	}
}

command: push: {
	dockerPush: exec.Run & {
		cmd: ["docker", "push", "defn/dev"]
	}
}
