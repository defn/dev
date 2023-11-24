package dev

import (
	dev "github.com/defn/dev/m/c/cue:dev"
)

app: dev & {
	"chart": chart
}

chart: {
	name: "dev"
}
