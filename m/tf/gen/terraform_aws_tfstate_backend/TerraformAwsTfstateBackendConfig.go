package terraform_aws_tfstate_backend

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsTfstateBackendConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// The canned ACL to apply to the S3 bucket private.
	Acl *string `field:"optional" json:"acl" yaml:"acl"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// ARN format to be used.
	//
	// May be changed to support deployment in GovCloud/China regions.
	// arn:aws.
	ArnFormat *string `field:"optional" json:"arnFormat" yaml:"arnFormat"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// DynamoDB billing mode PAY_PER_REQUEST.
	BillingMode *string `field:"optional" json:"billingMode" yaml:"billingMode"`
	// Whether Amazon S3 should block public ACLs for this bucket true.
	BlockPublicAcls *bool `field:"optional" json:"blockPublicAcls" yaml:"blockPublicAcls"`
	// Whether Amazon S3 should block public bucket policies for this bucket true.
	BlockPublicPolicy *bool `field:"optional" json:"blockPublicPolicy" yaml:"blockPublicPolicy"`
	// Whether to create the S3 bucket.
	//
	// true.
	BucketEnabled *bool `field:"optional" json:"bucketEnabled" yaml:"bucketEnabled"`
	// Set bucket object ownership to "BucketOwnerEnforced".
	//
	// Disables ACLs.
	// true.
	BucketOwnershipEnforcedEnabled *bool `field:"optional" json:"bucketOwnershipEnforcedEnabled" yaml:"bucketOwnershipEnforcedEnabled"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
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
	// Whether to create the DynamoDB table.
	//
	// true.
	DynamodbEnabled *bool `field:"optional" json:"dynamodbEnabled" yaml:"dynamodbEnabled"`
	// Override the name of the DynamoDB table which defaults to using `module.dynamodb_table_label.id`.
	DynamodbTableName *string `field:"optional" json:"dynamodbTableName" yaml:"dynamodbTableName"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// Enable DynamoDB point-in-time recovery true.
	EnablePointInTimeRecovery *bool `field:"optional" json:"enablePointInTimeRecovery" yaml:"enablePointInTimeRecovery"`
	// Enable Bucket Public Access Block true.
	EnablePublicAccessBlock *bool `field:"optional" json:"enablePublicAccessBlock" yaml:"enablePublicAccessBlock"`
	// ID element.
	//
	// Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'
	Environment *string `field:"optional" json:"environment" yaml:"environment"`
	// A boolean that indicates the S3 bucket can be destroyed even if it contains objects.
	//
	// These objects are not recoverable.
	ForceDestroy *bool `field:"optional" json:"forceDestroy" yaml:"forceDestroy"`
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for keep the existing setting, which defaults to `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// Whether Amazon S3 should ignore public ACLs for this bucket true.
	IgnorePublicAcls *bool `field:"optional" json:"ignorePublicAcls" yaml:"ignorePublicAcls"`
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
	// Destination (S3 bucket name and prefix) for S3 Server Access Logs for the S3 bucket.
	Logging interface{} `field:"optional" json:"logging" yaml:"logging"`
	// A boolean that indicates that versions of S3 objects can only be deleted with MFA.
	//
	// ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 )
	MfaDelete *bool `field:"optional" json:"mfaDelete" yaml:"mfaDelete"`
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
	// ARN of the policy that is used to set the permissions boundary for the IAM replication role.
	PermissionsBoundary *string `field:"optional" json:"permissionsBoundary" yaml:"permissionsBoundary"`
	// Prevent uploads of unencrypted objects to S3 true.
	PreventUnencryptedUploads *bool `field:"optional" json:"preventUnencryptedUploads" yaml:"preventUnencryptedUploads"`
	// AWS profile name as set in the shared credentials file.
	Profile *string `field:"optional" json:"profile" yaml:"profile"`
	// DynamoDB read capacity units when using provisioned mode 5.
	ReadCapacity *float64 `field:"optional" json:"readCapacity" yaml:"readCapacity"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// Whether Amazon S3 should restrict public bucket policies for this bucket true.
	RestrictPublicBuckets *bool `field:"optional" json:"restrictPublicBuckets" yaml:"restrictPublicBuckets"`
	// The role to be assumed.
	RoleArn *string `field:"optional" json:"roleArn" yaml:"roleArn"`
	// S3 bucket name.
	//
	// If not provided, the name will be generated from the context by the label module.
	S3BucketName *string `field:"optional" json:"s3BucketName" yaml:"s3BucketName"`
	// The ARN of the S3 replica bucket (destination).
	S3ReplicaBucketArn *string `field:"optional" json:"s3ReplicaBucketArn" yaml:"s3ReplicaBucketArn"`
	// Set this to true and specify `s3_replica_bucket_arn` to enable replication.
	S3ReplicationEnabled *bool `field:"optional" json:"s3ReplicationEnabled" yaml:"s3ReplicationEnabled"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
	// (Deprecated) Name of terraform backend config file to generate terraform.tf.
	TerraformBackendConfigFileName *string `field:"optional" json:"terraformBackendConfigFileName" yaml:"terraformBackendConfigFileName"`
	// (Deprecated) Directory for the terraform backend config file, usually `.`. The default is to create no file.
	TerraformBackendConfigFilePath *string `field:"optional" json:"terraformBackendConfigFilePath" yaml:"terraformBackendConfigFilePath"`
	// (Deprecated) The path to the template used to generate the config file.
	TerraformBackendConfigTemplateFile *string `field:"optional" json:"terraformBackendConfigTemplateFile" yaml:"terraformBackendConfigTemplateFile"`
	// The path to the state file inside the bucket terraform.tfstate.
	TerraformStateFile *string `field:"optional" json:"terraformStateFile" yaml:"terraformStateFile"`
	// The minimum required terraform version 1.0.0.
	TerraformVersion *string `field:"optional" json:"terraformVersion" yaml:"terraformVersion"`
	// DynamoDB write capacity units when using provisioned mode 5.
	WriteCapacity *float64 `field:"optional" json:"writeCapacity" yaml:"writeCapacity"`
}

