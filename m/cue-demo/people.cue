@experiment(aliasv2)
@experiment(explicitopen)

package spiral

#Person: {
	first:   string
	last:    string
	middle?: string
	title:   string
	title:   "parent" | "child"
}

#Parent: #Person & {
	title: "parent"
}

#Child: #Person & {
	title: "child"
}

family: "defn":   people.defn
family: "lamda":  people.lamda
family: [string]: #Person

tools: {
	mise: {}
	nix: {}
}

#defn: #Person & {
	first: "Cuong"
}

people: {
	defn: #defn & #Parent & {
		first: "Cuong"
		last:  "Nghiem"
	}

	lamda: #Child & {
		first: "David"
		last:  "Nghiem"
	}
}

relationships: {
	fam_members: [
		for f in family {
			"\(f.first) \(f.last)"
		},
	]

	parents: [
		for f in family
		if (f & #Parent) != _|_ {
			f.first
		},
	]
}
