package terraform_aws_s3_bucket

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsS3BucketConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// Set to `true` to create an IAM Access Key for the created IAM user true.
	AccessKeyEnabled *bool `field:"optional" json:"accessKeyEnabled" yaml:"accessKeyEnabled"`
	// The [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) to apply. Deprecated by AWS in favor of bucket policies. Automatically disabled if `s3_object_ownership` is set to "BucketOwnerEnforced". Defaults to "private" for backwards compatibility, but we recommend setting `s3_object_ownership` to "BucketOwnerEnforced" instead.
	//
	// private.
	Acl *string `field:"optional" json:"acl" yaml:"acl"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// List of actions the user is permitted to perform on the S3 bucket s3:PutObject s3:PutObjectAcl s3:GetObject s3:DeleteObject s3:ListBucket s3:ListBucketMultipartUploads s3:GetBucketLocation s3:AbortMultipartUpload.
	AllowedBucketActions *[]*string `field:"optional" json:"allowedBucketActions" yaml:"allowedBucketActions"`
	// Set to `true` to prevent uploads of unencrypted objects to S3 bucket.
	AllowEncryptedUploadsOnly *bool `field:"optional" json:"allowEncryptedUploadsOnly" yaml:"allowEncryptedUploadsOnly"`
	// Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL).
	//
	// This will explicitly deny access to HTTP requests.
	AllowSslRequestsOnly *bool `field:"optional" json:"allowSslRequestsOnly" yaml:"allowSslRequestsOnly"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// Set to `false` to disable the blocking of new public access lists on the bucket true.
	BlockPublicAcls *bool `field:"optional" json:"blockPublicAcls" yaml:"blockPublicAcls"`
	// Set to `false` to disable the blocking of new public policies on the bucket true.
	BlockPublicPolicy *bool `field:"optional" json:"blockPublicPolicy" yaml:"blockPublicPolicy"`
	// Set this to true to use Amazon S3 Bucket Keys for SSE-KMS, which may reduce the number of AWS KMS requests.
	//
	// For more information, see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
	BucketKeyEnabled *bool `field:"optional" json:"bucketKeyEnabled" yaml:"bucketKeyEnabled"`
	// Bucket name.
	//
	// If provided, the bucket will be created with this name instead of generating the name from the context.
	BucketName *string `field:"optional" json:"bucketName" yaml:"bucketName"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// Specifies the allowed headers, methods, origins and exposed headers when using CORS on this bucket.
	CorsConfiguration interface{} `field:"optional" json:"corsConfiguration" yaml:"corsConfiguration"`
	// Delimiter to be used between ID elements.
	//
	// Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
	Delimiter *string `field:"optional" json:"delimiter" yaml:"delimiter"`
	// Describe additional descriptors to be output in the `descriptors` output map.
	//
	// Map of maps. Keys are names of descriptors. Values are maps of the form
	// `{
	//    format = string
	//    labels = list(string)
	// }`
	// (Type is `any` so the map values can later be enhanced to provide additional options.)
	// `format` is a Terraform format string to be passed to the `format()` function.
	// `labels` is a list of labels, in order, to pass to `format()` function.
	// Label values will be normalized before being passed to `format()` so they will be
	// identical to how they appear in `id`.
	// Default is `{}` (`descriptors` output will be empty).
	DescriptorFormats interface{} `field:"optional" json:"descriptorFormats" yaml:"descriptorFormats"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// ID element.
	//
	// Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'
	Environment *string `field:"optional" json:"environment" yaml:"environment"`
	// When `true`, permits a non-empty S3 bucket to be deleted by first deleting all objects in the bucket.
	//
	// THESE OBJECTS ARE NOT RECOVERABLE even if they were versioned and stored in Glacier.
	ForceDestroy *bool `field:"optional" json:"forceDestroy" yaml:"forceDestroy"`
	// A list of policy grants for the bucket, taking a list of permissions.
	//
	// Conflicts with `acl`. Set `acl` to `null` to use this.
	// Deprecated by AWS in favor of bucket policies.
	// Automatically disabled if `s3_object_ownership` is set to "BucketOwnerEnforced".
	Grants interface{} `field:"optional" json:"grants" yaml:"grants"`
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for keep the existing setting, which defaults to `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// Set to `false` to disable the ignoring of public access lists on the bucket true.
	IgnorePublicAcls *bool `field:"optional" json:"ignorePublicAcls" yaml:"ignorePublicAcls"`
	// The AWS KMS master key ARN used for the `SSE-KMS` encryption.
	//
	// This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`
	KmsMasterKeyArn *string `field:"optional" json:"kmsMasterKeyArn" yaml:"kmsMasterKeyArn"`
	// Controls the letter case of the `tags` keys (label names) for tags generated by this module.
	//
	// Does not affect keys of tags passed in via the `tags` input.
	// Possible values: `lower`, `title`, `upper`.
	// Default value: `title`.
	LabelKeyCase *string `field:"optional" json:"labelKeyCase" yaml:"labelKeyCase"`
	// The order in which the labels (ID elements) appear in the `id`.
	//
	// Defaults to ["namespace", "environment", "stage", "name", "attributes"].
	// You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
	LabelOrder *[]*string `field:"optional" json:"labelOrder" yaml:"labelOrder"`
	// Set of labels (ID elements) to include as tags in the `tags` output.
	//
	// Default is to include all labels.
	// Tags with empty values will not be included in the `tags` output.
	// Set to `[]` to suppress all generated tags.
	// **Notes:**
	//   The value of the `name` tag, if included, will be the `id`, not the `name`.
	//   Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be
	//   changed in later chained modules. Attempts to change it will be silently ignored.
	//
	// default.
	LabelsAsTags *[]*string `field:"optional" json:"labelsAsTags" yaml:"labelsAsTags"`
	// Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually.
	//
	// Does not affect values of tags passed in via the `tags` input.
	// Possible values: `lower`, `title`, `upper` and `none` (no transformation).
	// Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.
	// Default value: `lower`.
	LabelValueCase *string `field:"optional" json:"labelValueCase" yaml:"labelValueCase"`
	// A list of lifecycle V2 rules.
	LifecycleConfigurationRules interface{} `field:"optional" json:"lifecycleConfigurationRules" yaml:"lifecycleConfigurationRules"`
	// DEPRECATED (use `lifecycle_configuration_rules`): A list of IDs to assign to corresponding `lifecycle_rules`.
	LifecycleRuleIds *[]*string `field:"optional" json:"lifecycleRuleIds" yaml:"lifecycleRuleIds"`
	// DEPRECATED (`use lifecycle_configuration_rules`): A list of lifecycle rules.
	LifecycleRules interface{} `field:"optional" json:"lifecycleRules" yaml:"lifecycleRules"`
	// Bucket access logging configuration.
	Logging interface{} `field:"optional" json:"logging" yaml:"logging"`
	// ID element.
	//
	// Usually the component or solution name, e.g. 'app' or 'jenkins'.
	// This is the only ID element not also included as a `tag`.
	// The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.
	Name *string `field:"optional" json:"name" yaml:"name"`
	// ID element.
	//
	// Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique
	Namespace *string `field:"optional" json:"namespace" yaml:"namespace"`
	// A configuration for S3 object locking.
	//
	// With S3 Object Lock, you can store objects using a `write once, read many` (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely.
	ObjectLockConfiguration interface{} `field:"optional" json:"objectLockConfiguration" yaml:"objectLockConfiguration"`
	// DEPRECATED (use `source_policy_documents`): A valid bucket policy JSON document.
	//
	// Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy
	Policy *string `field:"optional" json:"policy" yaml:"policy"`
	// List of actions to permit `privileged_principal_arns` to perform on bucket and bucket prefixes (see `privileged_principal_arns`).
	PrivilegedPrincipalActions *[]*string `field:"optional" json:"privilegedPrincipalActions" yaml:"privilegedPrincipalActions"`
	// List of maps.
	//
	// Each map has a key, an IAM Principal ARN, whose associated value is
	// a list of S3 path prefixes to grant `privileged_principal_actions` permissions for that principal,
	// in addition to the bucket itself, which is automatically included. Prefixes should not begin with '/'.
	//
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	PrivilegedPrincipalArns *[]*map[string]*[]*string `field:"optional" json:"privilegedPrincipalArns" yaml:"privilegedPrincipalArns"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// DEPRECATED (use `s3_replication_rules`): Specifies the replication rules for S3 bucket replication if enabled.
	//
	// You must also set s3_replication_enabled to true.
	ReplicationRules *[]interface{} `field:"optional" json:"replicationRules" yaml:"replicationRules"`
	// Set to `false` to disable the restricting of making the bucket public true.
	RestrictPublicBuckets *bool `field:"optional" json:"restrictPublicBuckets" yaml:"restrictPublicBuckets"`
	// Specifies the S3 object ownership control.
	//
	// Valid values are `ObjectWriter`, `BucketOwnerPreferred`, and 'BucketOwnerEnforced'.
	// Defaults to "ObjectWriter" for backwards compatibility, but we recommend setting "BucketOwnerEnforced" instead.
	//
	// ObjectWriter.
	S3ObjectOwnership *string `field:"optional" json:"s3ObjectOwnership" yaml:"s3ObjectOwnership"`
	// A single S3 bucket ARN to use for all replication rules.
	//
	// Note: The destination bucket can be specified in the replication rule itself
	// (which allows for multiple destinations), in which case it will take precedence over this variable.
	S3ReplicaBucketArn *string `field:"optional" json:"s3ReplicaBucketArn" yaml:"s3ReplicaBucketArn"`
	// Set this to true and specify `s3_replication_rules` to enable replication.
	//
	// `versioning_enabled` must also be `true`.
	S3ReplicationEnabled *bool `field:"optional" json:"s3ReplicationEnabled" yaml:"s3ReplicationEnabled"`
	// Permissions boundary ARN for the created IAM replication role.
	S3ReplicationPermissionsBoundaryArn *string `field:"optional" json:"s3ReplicationPermissionsBoundaryArn" yaml:"s3ReplicationPermissionsBoundaryArn"`
	// Specifies the replication rules for S3 bucket replication if enabled.
	//
	// You must also set s3_replication_enabled to true.
	S3ReplicationRules *[]interface{} `field:"optional" json:"s3ReplicationRules" yaml:"s3ReplicationRules"`
	// Cross-account IAM Role ARNs that will be allowed to perform S3 replication to this bucket (for replication within the same AWS account, it's not necessary to adjust the bucket policy).
	S3ReplicationSourceRoles *[]*string `field:"optional" json:"s3ReplicationSourceRoles" yaml:"s3ReplicationSourceRoles"`
	// List of IAM policy documents that are merged together into the exported document.
	//
	// Statements defined in source_policy_documents or source_json must have unique SIDs.
	// Statement having SIDs that match policy SIDs generated by this module will override them.
	SourcePolicyDocuments *[]*string `field:"optional" json:"sourcePolicyDocuments" yaml:"sourcePolicyDocuments"`
	// The server-side encryption algorithm to use.
	//
	// Valid values are `AES256` and `aws:kms`
	// AES256.
	SseAlgorithm *string `field:"optional" json:"sseAlgorithm" yaml:"sseAlgorithm"`
	// The base path for SSM parameters where created IAM user's access key is stored /s3_user/.
	SsmBasePath *string `field:"optional" json:"ssmBasePath" yaml:"ssmBasePath"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// Set to `true` to store the created IAM user's access key in SSM Parameter Store, `false` to store them in Terraform state as outputs.
	//
	// Since Terraform state would contain the secrets in plaintext,
	// use of SSM Parameter Store is recommended.
	StoreAccessKeyInSsm *bool `field:"optional" json:"storeAccessKeyInSsm" yaml:"storeAccessKeyInSsm"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
	// Set this to `true` to enable S3 Transfer Acceleration for the bucket.
	//
	// Note: When this is set to `false` Terraform does not perform drift detection
	// and will not disable Transfer Acceleration if it was enabled outside of Terraform.
	// To disable it via Terraform, you must set this to `true` and then to `false`.
	// Note: not all regions support Transfer Acceleration.
	TransferAccelerationEnabled *bool `field:"optional" json:"transferAccelerationEnabled" yaml:"transferAccelerationEnabled"`
	// Set to `true` to create an IAM user with permission to access the bucket.
	UserEnabled *bool `field:"optional" json:"userEnabled" yaml:"userEnabled"`
	// Permission boundary ARN for the IAM user created to access the bucket.
	UserPermissionsBoundaryArn *string `field:"optional" json:"userPermissionsBoundaryArn" yaml:"userPermissionsBoundaryArn"`
	// A state of versioning.
	//
	// Versioning is a means of keeping multiple variants of an object in the same bucket
	// true.
	VersioningEnabled *bool `field:"optional" json:"versioningEnabled" yaml:"versioningEnabled"`
	// Specifies the static website hosting configuration object.
	WebsiteConfiguration interface{} `field:"optional" json:"websiteConfiguration" yaml:"websiteConfiguration"`
	// If provided, all website requests will be redirected to the specified host name and protocol.
	WebsiteRedirectAllRequestsTo interface{} `field:"optional" json:"websiteRedirectAllRequestsTo" yaml:"websiteRedirectAllRequestsTo"`
}
