package w

import (
	"github.com/defn/dev/m/c/infra"
)

domains: infra.domains

name: string

// list of domain names matches
#name_matched: [...bool]
#name_matched: [
	for d in domains
	if d == name {
		true
	},
]

// count how many actually matched
#name_valid: len(#name_matched)

// only one name should match
#name_valid: 1
