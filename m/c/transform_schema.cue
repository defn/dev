package c

// All inputs have a name and label, which are usually the same.  Set both in
// the same place.  See #Transform.inputs.
#Input: {
	name:  string
	label: string
}

#Transform: {
	// A transformer takes an (in)put and (out)put.  The input is extended with
	// additional fields, the output is the template.
	transformer: {
		from: {
			#Input
			...
		}
		to: {
			_in: from
			...
		}
	}

	inputs: [N=string]: {
		transformer.from

		// The label is usually a custom value like "resource-\(label)",
		// defaults to the name.  Additional fields can be defined in terms of
		// name.
		name:  N
		label: string | *name
	}

	outputs: {
		// Outputs are meant to be assigned to top level fields, like
		// "resource:" or "kustomizes"

		for _from in inputs {
			(_from.label): (transformer & {
				from: _from
			}).to
		}
	}
}
