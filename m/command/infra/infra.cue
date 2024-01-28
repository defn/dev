package infra

#AwsAdmin: {
	name:  string
	email: string
}

#AwsAccount: {
	name: string
	email: string
	profile: string | *name
	prefix: string | *""
	imported: string | *null
}

#AwsBackend: {
	lock: string
	bucket: string
	region: string
	profile: string
}

#AwsOrganization: {
	name:   string
	region: string
	accounts: [...#AwsAccount]
	admins: [...#AwsAdmin]
}

#AwsProps: {
	backend: #AwsBackend
	organization: [N=string]: #AwsOrganization & {
		name: N
	}
}

input: #AwsProps
