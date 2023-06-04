package input

import (
	"encoding/base64"
	"strings"
)

#Input: {
	args: string | *"b25l dHdv dGhyZWU="
	arg:  [...string] | *[]
	if len(args) > 0 {
		arg: [ for a in strings.Split(args, " ") {"\(base64.Decode(null, a))"}]
	}
}
