package infra

#AwsAdmin: {
	name:  string
	email: string
}

#AwsAccount: {
	name:     string
	email:    string
	profile:  string | *name
	prefix:   string | *""
	imported: string | *null
	region:   string
	cfg:      #CfgTerraformAwsS3BucketConfig
}

#AwsBackend: {
	lock:    string
	bucket:  string
	region:  string
	profile: string
}

#AwsOrganization: {
	name:   string
	region: string
	accounts: [...#AwsAccount]
	admins: [...#AwsAdmin]
}

#AwsAccountInfo: {
	id: string
}

#AwsInfo: {
	url: string
	account: [string]: #AwsAccountInfo
}

#AwsProps: {
	backend: #AwsBackend
	organization: [N=string]: #AwsOrganization & {
		name: N
	}
	accounts: [...string]
	info: [string]: #AwsInfo
}

#CfgTerraformAwsS3BucketConfig: {
	id: string

	enabled:   bool
	namespace: string
	stage:     string
	name:      string
	attributes: [...string]

	acl:                string
	user_enabled:       bool
	versioning_enabled: bool
}

input: #AwsProps
