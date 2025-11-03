@experiment(aliasv2)
@experiment(explicitopen)

package main

import (
	intention "github.com/defn/dev/m/c/intention"

	execution "github.com/defn/dev/m/c/execution"
	application "github.com/defn/dev/m/c/application"

	definition "github.com/defn/dev/m/c/definition"
	definition_aws "github.com/defn/dev/m/c/definition/aws"
)

config: {
	resource: intention.resource
	resource: execution.resource

	repo: intention.repo
	repo: definition.repo
	repo: application.repo

	aws: definition_aws
	aws: intention.aws
}
