package terraform_aws_s3_bucket

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_s3_bucket/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_s3_bucket/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsS3Bucket based on a Terraform module.
//
// Source at ../../mod/terraform-aws-s3-bucket
type TerraformAwsS3Bucket interface {
	cdktf.TerraformModule
	AccessKeyEnabled() *bool
	SetAccessKeyEnabled(val *bool)
	AccessKeyIdOutput() *string
	AccessKeyIdSsmPathOutput() *string
	Acl() *string
	SetAcl(val *string)
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	AllowedBucketActions() *[]*string
	SetAllowedBucketActions(val *[]*string)
	AllowEncryptedUploadsOnly() *bool
	SetAllowEncryptedUploadsOnly(val *bool)
	AllowPublicWebsite() *bool
	SetAllowPublicWebsite(val *bool)
	AllowSslRequestsOnly() *bool
	SetAllowSslRequestsOnly(val *bool)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	BlockPublicAcls() *bool
	SetBlockPublicAcls(val *bool)
	BlockPublicPolicy() *bool
	SetBlockPublicPolicy(val *bool)
	BucketArnOutput() *string
	BucketDomainNameOutput() *string
	BucketIdOutput() *string
	BucketKeyEnabled() *bool
	SetBucketKeyEnabled(val *bool)
	BucketName() *string
	SetBucketName(val *string)
	BucketRegionalDomainNameOutput() *string
	BucketRegionOutput() *string
	BucketWebsiteDomainOutput() *string
	BucketWebsiteEndpointOutput() *string
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	CorsConfiguration() interface{}
	SetCorsConfiguration(val interface{})
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	Enabled() *bool
	SetEnabled(val *bool)
	EnabledOutput() *string
	Environment() *string
	SetEnvironment(val *string)
	ForceDestroy() *bool
	SetForceDestroy(val *bool)
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	Grants() interface{}
	SetGrants(val interface{})
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	IgnorePublicAcls() *bool
	SetIgnorePublicAcls(val *bool)
	KmsMasterKeyArn() *string
	SetKmsMasterKeyArn(val *string)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LifecycleConfigurationRules() interface{}
	SetLifecycleConfigurationRules(val interface{})
	LifecycleRuleIds() *[]*string
	SetLifecycleRuleIds(val *[]*string)
	LifecycleRules() interface{}
	SetLifecycleRules(val interface{})
	Logging() interface{}
	SetLogging(val interface{})
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	ObjectLockConfiguration() interface{}
	SetObjectLockConfiguration(val interface{})
	Policy() *string
	SetPolicy(val *string)
	PrivilegedPrincipalActions() *[]*string
	SetPrivilegedPrincipalActions(val *[]*string)
	PrivilegedPrincipalArns() *[]*map[string]*[]*string
	SetPrivilegedPrincipalArns(val *[]*map[string]*[]*string)
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	ReplicationRoleArnOutput() *string
	ReplicationRules() *[]interface{}
	SetReplicationRules(val *[]interface{})
	RestrictPublicBuckets() *bool
	SetRestrictPublicBuckets(val *bool)
	S3ObjectOwnership() *string
	SetS3ObjectOwnership(val *string)
	S3ReplicaBucketArn() *string
	SetS3ReplicaBucketArn(val *string)
	S3ReplicationEnabled() *bool
	SetS3ReplicationEnabled(val *bool)
	S3ReplicationPermissionsBoundaryArn() *string
	SetS3ReplicationPermissionsBoundaryArn(val *string)
	S3ReplicationRules() *[]interface{}
	SetS3ReplicationRules(val *[]interface{})
	S3ReplicationSourceRoles() *[]*string
	SetS3ReplicationSourceRoles(val *[]*string)
	SecretAccessKeyOutput() *string
	SecretAccessKeySsmPathOutput() *string
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	SourcePolicyDocuments() *[]*string
	SetSourcePolicyDocuments(val *[]*string)
	SseAlgorithm() *string
	SetSseAlgorithm(val *string)
	SsmBasePath() *string
	SetSsmBasePath(val *string)
	Stage() *string
	SetStage(val *string)
	StoreAccessKeyInSsm() *bool
	SetStoreAccessKeyInSsm(val *bool)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	TransferAccelerationEnabled() *bool
	SetTransferAccelerationEnabled(val *bool)
	UserArnOutput() *string
	UserEnabled() *bool
	SetUserEnabled(val *bool)
	UserEnabledOutput() *string
	UserNameOutput() *string
	UserPermissionsBoundaryArn() *string
	SetUserPermissionsBoundaryArn(val *string)
	UserUniqueIdOutput() *string
	// Experimental.
	Version() *string
	VersioningEnabled() *bool
	SetVersioningEnabled(val *bool)
	WebsiteConfiguration() interface{}
	SetWebsiteConfiguration(val interface{})
	WebsiteRedirectAllRequestsTo() interface{}
	SetWebsiteRedirectAllRequestsTo(val interface{})
	// Experimental.
	AddOverride(path *string, value interface{})
	// Experimental.
	AddProvider(provider interface{})
	// Experimental.
	GetString(output *string) *string
	// Experimental.
	InterpolationForOutput(moduleOutput *string) cdktf.IResolvable
	// Overrides the auto-generated logical ID with a specific ID.
	// Experimental.
	OverrideLogicalId(newLogicalId *string)
	// Resets a previously passed logical Id to use the auto-generated logical id again.
	// Experimental.
	ResetOverrideLogicalId()
	SynthesizeAttributes() *map[string]interface{}
	SynthesizeHclAttributes() *map[string]interface{}
	// Experimental.
	ToHclTerraform() interface{}
	// Experimental.
	ToMetadata() interface{}
	// Returns a string representation of this construct.
	ToString() *string
	// Experimental.
	ToTerraform() interface{}
}

// The jsii proxy struct for TerraformAwsS3Bucket
type jsiiProxy_TerraformAwsS3Bucket struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AccessKeyEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"accessKeyEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AccessKeyIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"accessKeyIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AccessKeyIdSsmPathOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"accessKeyIdSsmPathOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Acl() *string {
	var returns *string
	_jsii_.Get(
		j,
		"acl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AllowedBucketActions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedBucketActions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AllowEncryptedUploadsOnly() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"allowEncryptedUploadsOnly",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AllowPublicWebsite() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"allowPublicWebsite",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) AllowSslRequestsOnly() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"allowSslRequestsOnly",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BlockPublicAcls() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"blockPublicAcls",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BlockPublicPolicy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"blockPublicPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketDomainNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketDomainNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketKeyEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"bucketKeyEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketRegionalDomainNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketRegionalDomainNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketRegionOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketRegionOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketWebsiteDomainOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketWebsiteDomainOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) BucketWebsiteEndpointOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bucketWebsiteEndpointOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) CorsConfiguration() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"corsConfiguration",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) EnabledOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"enabledOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ForceDestroy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"forceDestroy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Grants() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"grants",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) IgnorePublicAcls() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ignorePublicAcls",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) KmsMasterKeyArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kmsMasterKeyArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LifecycleConfigurationRules() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"lifecycleConfigurationRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LifecycleRuleIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"lifecycleRuleIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) LifecycleRules() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"lifecycleRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Logging() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"logging",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ObjectLockConfiguration() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"objectLockConfiguration",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Policy() *string {
	var returns *string
	_jsii_.Get(
		j,
		"policy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) PrivilegedPrincipalActions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"privilegedPrincipalActions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) PrivilegedPrincipalArns() *[]*map[string]*[]*string {
	var returns *[]*map[string]*[]*string
	_jsii_.Get(
		j,
		"privilegedPrincipalArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ReplicationRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"replicationRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) ReplicationRules() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"replicationRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) RestrictPublicBuckets() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"restrictPublicBuckets",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ObjectOwnership() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ObjectOwnership",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ReplicaBucketArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ReplicaBucketArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ReplicationEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"s3ReplicationEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ReplicationPermissionsBoundaryArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ReplicationPermissionsBoundaryArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ReplicationRules() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"s3ReplicationRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) S3ReplicationSourceRoles() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"s3ReplicationSourceRoles",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SecretAccessKeyOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"secretAccessKeyOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SecretAccessKeySsmPathOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"secretAccessKeySsmPathOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SourcePolicyDocuments() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"sourcePolicyDocuments",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SseAlgorithm() *string {
	var returns *string
	_jsii_.Get(
		j,
		"sseAlgorithm",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SsmBasePath() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ssmBasePath",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) StoreAccessKeyInSsm() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"storeAccessKeyInSsm",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) TransferAccelerationEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"transferAccelerationEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"userEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserEnabledOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userEnabledOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserPermissionsBoundaryArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userPermissionsBoundaryArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) UserUniqueIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userUniqueIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) VersioningEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"versioningEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) WebsiteConfiguration() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"websiteConfiguration",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsS3Bucket) WebsiteRedirectAllRequestsTo() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"websiteRedirectAllRequestsTo",
		&returns,
	)
	return returns
}

func NewTerraformAwsS3Bucket(scope constructs.Construct, id *string, config *TerraformAwsS3BucketConfig) TerraformAwsS3Bucket {
	_init_.Initialize()

	if err := validateNewTerraformAwsS3BucketParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsS3Bucket{}

	_jsii_.Create(
		"terraform_aws_s3_bucket.TerraformAwsS3Bucket",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsS3Bucket_Override(t TerraformAwsS3Bucket, scope constructs.Construct, id *string, config *TerraformAwsS3BucketConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_s3_bucket.TerraformAwsS3Bucket",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAccessKeyEnabled(val *bool) {
	_jsii_.Set(
		j,
		"accessKeyEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAcl(val *string) {
	_jsii_.Set(
		j,
		"acl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAllowedBucketActions(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedBucketActions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAllowEncryptedUploadsOnly(val *bool) {
	_jsii_.Set(
		j,
		"allowEncryptedUploadsOnly",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAllowPublicWebsite(val *bool) {
	_jsii_.Set(
		j,
		"allowPublicWebsite",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAllowSslRequestsOnly(val *bool) {
	_jsii_.Set(
		j,
		"allowSslRequestsOnly",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetBlockPublicAcls(val *bool) {
	_jsii_.Set(
		j,
		"blockPublicAcls",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetBlockPublicPolicy(val *bool) {
	_jsii_.Set(
		j,
		"blockPublicPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetBucketKeyEnabled(val *bool) {
	_jsii_.Set(
		j,
		"bucketKeyEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetBucketName(val *string) {
	_jsii_.Set(
		j,
		"bucketName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetCorsConfiguration(val interface{}) {
	if err := j.validateSetCorsConfigurationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"corsConfiguration",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetForceDestroy(val *bool) {
	_jsii_.Set(
		j,
		"forceDestroy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetGrants(val interface{}) {
	if err := j.validateSetGrantsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"grants",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetIgnorePublicAcls(val *bool) {
	_jsii_.Set(
		j,
		"ignorePublicAcls",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetKmsMasterKeyArn(val *string) {
	_jsii_.Set(
		j,
		"kmsMasterKeyArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLifecycleConfigurationRules(val interface{}) {
	if err := j.validateSetLifecycleConfigurationRulesParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"lifecycleConfigurationRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLifecycleRuleIds(val *[]*string) {
	_jsii_.Set(
		j,
		"lifecycleRuleIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLifecycleRules(val interface{}) {
	if err := j.validateSetLifecycleRulesParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"lifecycleRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetLogging(val interface{}) {
	if err := j.validateSetLoggingParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"logging",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetObjectLockConfiguration(val interface{}) {
	if err := j.validateSetObjectLockConfigurationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"objectLockConfiguration",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetPolicy(val *string) {
	_jsii_.Set(
		j,
		"policy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetPrivilegedPrincipalActions(val *[]*string) {
	_jsii_.Set(
		j,
		"privilegedPrincipalActions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetPrivilegedPrincipalArns(val *[]*map[string]*[]*string) {
	_jsii_.Set(
		j,
		"privilegedPrincipalArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetReplicationRules(val *[]interface{}) {
	_jsii_.Set(
		j,
		"replicationRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetRestrictPublicBuckets(val *bool) {
	_jsii_.Set(
		j,
		"restrictPublicBuckets",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ObjectOwnership(val *string) {
	_jsii_.Set(
		j,
		"s3ObjectOwnership",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ReplicaBucketArn(val *string) {
	_jsii_.Set(
		j,
		"s3ReplicaBucketArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ReplicationEnabled(val *bool) {
	_jsii_.Set(
		j,
		"s3ReplicationEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ReplicationPermissionsBoundaryArn(val *string) {
	_jsii_.Set(
		j,
		"s3ReplicationPermissionsBoundaryArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ReplicationRules(val *[]interface{}) {
	_jsii_.Set(
		j,
		"s3ReplicationRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetS3ReplicationSourceRoles(val *[]*string) {
	_jsii_.Set(
		j,
		"s3ReplicationSourceRoles",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetSourcePolicyDocuments(val *[]*string) {
	_jsii_.Set(
		j,
		"sourcePolicyDocuments",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetSseAlgorithm(val *string) {
	_jsii_.Set(
		j,
		"sseAlgorithm",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetSsmBasePath(val *string) {
	_jsii_.Set(
		j,
		"ssmBasePath",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetStoreAccessKeyInSsm(val *bool) {
	_jsii_.Set(
		j,
		"storeAccessKeyInSsm",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetTransferAccelerationEnabled(val *bool) {
	_jsii_.Set(
		j,
		"transferAccelerationEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetUserEnabled(val *bool) {
	_jsii_.Set(
		j,
		"userEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetUserPermissionsBoundaryArn(val *string) {
	_jsii_.Set(
		j,
		"userPermissionsBoundaryArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetVersioningEnabled(val *bool) {
	_jsii_.Set(
		j,
		"versioningEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetWebsiteConfiguration(val interface{}) {
	if err := j.validateSetWebsiteConfigurationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"websiteConfiguration",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsS3Bucket) SetWebsiteRedirectAllRequestsTo(val interface{}) {
	if err := j.validateSetWebsiteRedirectAllRequestsToParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"websiteRedirectAllRequestsTo",
		val,
	)
}

// Checks if `x` is a construct.
//
// Use this method instead of `instanceof` to properly detect `Construct`
// instances, even when the construct library is symlinked.
//
// Explanation: in JavaScript, multiple copies of the `constructs` library on
// disk are seen as independent, completely different libraries. As a
// consequence, the class `Construct` in each copy of the `constructs` library
// is seen as a different class, and an instance of one class will not test as
// `instanceof` the other class. `npm install` will not create installations
// like this, but users may manually symlink construct libraries together or
// use a monorepo tool: in those cases, multiple copies of the `constructs`
// library can be accidentally installed, and `instanceof` will behave
// unpredictably. It is safest to avoid using `instanceof`, and using
// this type-testing method instead.
//
// Returns: true if `x` is an object created from a class which extends `Construct`.
func TerraformAwsS3Bucket_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsS3Bucket_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_s3_bucket.TerraformAwsS3Bucket",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsS3Bucket_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsS3Bucket_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_s3_bucket.TerraformAwsS3Bucket",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsS3Bucket) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsS3Bucket) GetString(output *string) *string {
	if err := t.validateGetStringParameters(output); err != nil {
		panic(err)
	}
	var returns *string

	_jsii_.Invoke(
		t,
		"getString",
		[]interface{}{output},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
	if err := t.validateInterpolationForOutputParameters(moduleOutput); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		t,
		"interpolationForOutput",
		[]interface{}{moduleOutput},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsS3Bucket) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsS3Bucket) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsS3Bucket) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}
