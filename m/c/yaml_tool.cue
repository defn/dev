package c

import (
	"tool/file"
)

command: "gen": {
	for kind, k in gen
	for fname, f in k {
		"\(fname)": file.Create & {
			filename: fname
			contents: f
		}
	}
}
