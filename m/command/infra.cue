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

#AwsProps: {
	terraform: #TerraformCloud

	organizations: [N=string]: #AwsOrganization & {
		name: N
	}
}

input: #AwsProps
