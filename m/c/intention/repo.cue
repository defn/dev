package intention

repo: [NAME=string]: #GitRepo & {
	name: NAME
}

#GitRepo: {
	name:        string
	description: string | *""
	createdAt?:  string
	updatedAt?:  string
	url?:        string
}
