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

#KubernetesCluster: {
	region: string
	nodegroup: [string]: {
		instance_types: [...string]
		az: [string]: networkk: string
	}
	vpc: cidrs: [...string]
}

#AwsProps: {
	organization: [N=string]: #AwsOrganization & {
		name: N
	}

	kubernetes: [N=string]: #KubernetesCluster & {
		name: N
	}
}

input: #AwsProps
