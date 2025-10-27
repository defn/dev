@experiment(aliasv2)
@experiment(explicitopen)

package intention

repo: {
	[string]~(NAME,_): {
		#GitRepo...
		name: NAME
	}
}

#GitRepo: {
	name:        string
	description: string | *""
	createdAt?:  string
	updatedAt?:  string
	url?:        string
}
