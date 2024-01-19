package terraform_aws_tfstate_backend

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_tfstate_backend/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_tfstate_backend/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsTfstateBackend based on a Terraform module.
//
// Source at ./mod/terraform-aws-tfstate-backend
type TerraformAwsTfstateBackend interface {
	cdktf.TerraformModule
	Acl() *string
	SetAcl(val *string)
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	ArnFormat() *string
	SetArnFormat(val *string)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	BillingMode() *string
	SetBillingMode(val *string)
	BlockPublicAcls() *bool
	SetBlockPublicAcls(val *bool)
	BlockPublicPolicy() *bool
	SetBlockPublicPolicy(val *bool)
	BucketEnabled() *bool
	SetBucketEnabled(val *bool)
	BucketOwnershipEnforcedEnabled() *bool
	SetBucketOwnershipEnforcedEnabled(val *bool)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DynamodbEnabled() *bool
	SetDynamodbEnabled(val *bool)
	DynamodbTableArnOutput() *string
	DynamodbTableIdOutput() *string
	DynamodbTableName() *string
	SetDynamodbTableName(val *string)
	DynamodbTableNameOutput() *string
	Enabled() *bool
	SetEnabled(val *bool)
	EnablePointInTimeRecovery() *bool
	SetEnablePointInTimeRecovery(val *bool)
	EnablePublicAccessBlock() *bool
	SetEnablePublicAccessBlock(val *bool)
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
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	IgnorePublicAcls() *bool
	SetIgnorePublicAcls(val *bool)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	Logging() interface{}
	SetLogging(val interface{})
	MfaDelete() *bool
	SetMfaDelete(val *bool)
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	PermissionsBoundary() *string
	SetPermissionsBoundary(val *string)
	PreventUnencryptedUploads() *bool
	SetPreventUnencryptedUploads(val *bool)
	Profile() *string
	SetProfile(val *string)
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	ReadCapacity() *float64
	SetReadCapacity(val *float64)
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	RestrictPublicBuckets() *bool
	SetRestrictPublicBuckets(val *bool)
	RoleArn() *string
	SetRoleArn(val *string)
	S3BucketArnOutput() *string
	S3BucketDomainNameOutput() *string
	S3BucketIdOutput() *string
	S3BucketName() *string
	SetS3BucketName(val *string)
	S3ReplicaBucketArn() *string
	SetS3ReplicaBucketArn(val *string)
	S3ReplicationEnabled() *bool
	SetS3ReplicationEnabled(val *bool)
	S3ReplicationRoleArnOutput() *string
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	TerraformBackendConfigFileName() *string
	SetTerraformBackendConfigFileName(val *string)
	TerraformBackendConfigFilePath() *string
	SetTerraformBackendConfigFilePath(val *string)
	TerraformBackendConfigOutput() *string
	TerraformBackendConfigTemplateFile() *string
	SetTerraformBackendConfigTemplateFile(val *string)
	TerraformStateFile() *string
	SetTerraformStateFile(val *string)
	TerraformVersion() *string
	SetTerraformVersion(val *string)
	// Experimental.
	Version() *string
	WriteCapacity() *float64
	SetWriteCapacity(val *float64)
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

// The jsii proxy struct for TerraformAwsTfstateBackend
type jsiiProxy_TerraformAwsTfstateBackend struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Acl() *string {
	var returns *string
	_jsii_.Get(
		j,
		"acl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) ArnFormat() *string {
	var returns *string
	_jsii_.Get(
		j,
		"arnFormat",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) BillingMode() *string {
	var returns *string
	_jsii_.Get(
		j,
		"billingMode",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) BlockPublicAcls() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"blockPublicAcls",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) BlockPublicPolicy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"blockPublicPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) BucketEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"bucketEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) BucketOwnershipEnforcedEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"bucketOwnershipEnforcedEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DynamodbEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"dynamodbEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DynamodbTableArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dynamodbTableArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DynamodbTableIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dynamodbTableIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DynamodbTableName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dynamodbTableName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) DynamodbTableNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dynamodbTableNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) EnablePointInTimeRecovery() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enablePointInTimeRecovery",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) EnablePublicAccessBlock() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enablePublicAccessBlock",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) ForceDestroy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"forceDestroy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) IgnorePublicAcls() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ignorePublicAcls",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Logging() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"logging",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) MfaDelete() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"mfaDelete",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) PermissionsBoundary() *string {
	var returns *string
	_jsii_.Get(
		j,
		"permissionsBoundary",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) PreventUnencryptedUploads() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"preventUnencryptedUploads",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Profile() *string {
	var returns *string
	_jsii_.Get(
		j,
		"profile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) ReadCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"readCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) RestrictPublicBuckets() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"restrictPublicBuckets",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) RoleArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"roleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3BucketArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3BucketDomainNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketDomainNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3BucketIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3BucketName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3ReplicaBucketArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ReplicaBucketArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3ReplicationEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"s3ReplicationEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) S3ReplicationRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ReplicationRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformBackendConfigFileName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformBackendConfigFileName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformBackendConfigFilePath() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformBackendConfigFilePath",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformBackendConfigOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformBackendConfigOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformBackendConfigTemplateFile() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformBackendConfigTemplateFile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformStateFile() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformStateFile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) TerraformVersion() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsTfstateBackend) WriteCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"writeCapacity",
		&returns,
	)
	return returns
}


func NewTerraformAwsTfstateBackend(scope constructs.Construct, id *string, config *TerraformAwsTfstateBackendConfig) TerraformAwsTfstateBackend {
	_init_.Initialize()

	if err := validateNewTerraformAwsTfstateBackendParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsTfstateBackend{}

	_jsii_.Create(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackend",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsTfstateBackend_Override(t TerraformAwsTfstateBackend, scope constructs.Construct, id *string, config *TerraformAwsTfstateBackendConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackend",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetAcl(val *string) {
	_jsii_.Set(
		j,
		"acl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetArnFormat(val *string) {
	_jsii_.Set(
		j,
		"arnFormat",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetBillingMode(val *string) {
	_jsii_.Set(
		j,
		"billingMode",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetBlockPublicAcls(val *bool) {
	_jsii_.Set(
		j,
		"blockPublicAcls",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetBlockPublicPolicy(val *bool) {
	_jsii_.Set(
		j,
		"blockPublicPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetBucketEnabled(val *bool) {
	_jsii_.Set(
		j,
		"bucketEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetBucketOwnershipEnforcedEnabled(val *bool) {
	_jsii_.Set(
		j,
		"bucketOwnershipEnforcedEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetDynamodbEnabled(val *bool) {
	_jsii_.Set(
		j,
		"dynamodbEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetDynamodbTableName(val *string) {
	_jsii_.Set(
		j,
		"dynamodbTableName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetEnablePointInTimeRecovery(val *bool) {
	_jsii_.Set(
		j,
		"enablePointInTimeRecovery",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetEnablePublicAccessBlock(val *bool) {
	_jsii_.Set(
		j,
		"enablePublicAccessBlock",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetForceDestroy(val *bool) {
	_jsii_.Set(
		j,
		"forceDestroy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetIgnorePublicAcls(val *bool) {
	_jsii_.Set(
		j,
		"ignorePublicAcls",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetLogging(val interface{}) {
	if err := j.validateSetLoggingParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"logging",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetMfaDelete(val *bool) {
	_jsii_.Set(
		j,
		"mfaDelete",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetPermissionsBoundary(val *string) {
	_jsii_.Set(
		j,
		"permissionsBoundary",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetPreventUnencryptedUploads(val *bool) {
	_jsii_.Set(
		j,
		"preventUnencryptedUploads",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetProfile(val *string) {
	_jsii_.Set(
		j,
		"profile",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetReadCapacity(val *float64) {
	_jsii_.Set(
		j,
		"readCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetRestrictPublicBuckets(val *bool) {
	_jsii_.Set(
		j,
		"restrictPublicBuckets",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetRoleArn(val *string) {
	_jsii_.Set(
		j,
		"roleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetS3BucketName(val *string) {
	_jsii_.Set(
		j,
		"s3BucketName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetS3ReplicaBucketArn(val *string) {
	_jsii_.Set(
		j,
		"s3ReplicaBucketArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetS3ReplicationEnabled(val *bool) {
	_jsii_.Set(
		j,
		"s3ReplicationEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTerraformBackendConfigFileName(val *string) {
	_jsii_.Set(
		j,
		"terraformBackendConfigFileName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTerraformBackendConfigFilePath(val *string) {
	_jsii_.Set(
		j,
		"terraformBackendConfigFilePath",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTerraformBackendConfigTemplateFile(val *string) {
	_jsii_.Set(
		j,
		"terraformBackendConfigTemplateFile",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTerraformStateFile(val *string) {
	_jsii_.Set(
		j,
		"terraformStateFile",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetTerraformVersion(val *string) {
	_jsii_.Set(
		j,
		"terraformVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsTfstateBackend)SetWriteCapacity(val *float64) {
	_jsii_.Set(
		j,
		"writeCapacity",
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
func TerraformAwsTfstateBackend_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsTfstateBackend_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackend",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsTfstateBackend_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsTfstateBackend_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackend",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsTfstateBackend) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsTfstateBackend) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsTfstateBackend) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

