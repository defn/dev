package m

import (
	"embed"
)

//go:embed cue.mod/module.cue
var CueModule string

//go:embed hello/cue/hello.cue
var Schema embed.FS
