package infra

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
	name:   string
	region: string
	nodegroup: [NAME=string]: {
		name: string | *NAME
		instance_types: [...string]
		az: [string]: network: string
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
