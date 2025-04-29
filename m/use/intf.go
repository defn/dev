package main

import (
	"cuelang.org/go/cue"
)

type CueRepository interface {
	VendCueConfig() CueConfig
}

type CueConfig interface {
	GetContext() *cue.Context
}
