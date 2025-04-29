package main

import (
	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
)

// StudentConfig implements CueConfig
type StudentConfig struct {
	ctx *cue.Context
}

func (s *StudentConfig) GetContext() *cue.Context {
	return s.ctx
}

// StudentRepository implements CueRepository
type StudentRepository struct{}

func (u StudentRepository) VendCueConfig() CueConfig {
	return &StudentConfig{
		ctx: cuecontext.New(),
	}
}

// Provide StudentRepository
func UseStudentRepository() CueRepository {
	return StudentRepository{}
}
