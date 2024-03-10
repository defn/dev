package infra

#AwsOrganization: {
	name:   string
	region: string
	accounts: [...#AwsAccount]
	admins: [...#AwsAdmin]
	ops_org_name:     string
	ops_account_name: string
	ops_account_id:   string
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

#AwsAdmin: {
	name:  string
	email: string
}

#AwsBackend: {
	lock:    string
	bucket:  string
	region:  string
	profile: string
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
