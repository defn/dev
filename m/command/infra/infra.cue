package infra

#AwsAdmin: {
	name:  string
	email: string
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
	prefix: string
	domain: string
	accounts: [...string]
	admins: [...#AwsAdmin]
}

#AwsProps: {
	backend: #AwsBackend
	organization: [N=string]: #AwsOrganization & {
		name: N
	}
}

input: #AwsProps
