package main

#AwsAdmin: {
	name:  string
	email: string
}

#AwsOrganization: {
	name:   string
	region: string
	prefix: string
	domain: string
	accounts: [...string]
	admins: [...#AwsAdmin]
}

#TerraformCloud: {
	organization: string
	workspace:    string
}

#AwsProps: {
	terraform: #TerraformCloud

	organizations: [N=string]: #AwsOrganization & {
		name: N
	}
}

input: #AwsProps
