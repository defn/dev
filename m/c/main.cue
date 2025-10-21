package main

import (
	intention "github.com/defn/dev/m/c/intention"
	definition "github.com/defn/dev/m/c/definition"
	execution "github.com/defn/dev/m/c/execution"
	application "github.com/defn/dev/m/c/application"
)

config: {
	resource: execution.resource
	repo:     intention.repo
	repo:     definition.repo
	repo:     application.repo
}
