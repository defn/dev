package terraform_aws_eks_iam_role

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_aws_eks_iam_role/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_aws_eks_iam_role/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEksIamRole interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	AwsAccountNumber() *string
	SetAwsAccountNumber(val *string)
	AwsIamPolicyDocument() interface{}
	SetAwsIamPolicyDocument(val interface{})
	AwsPartition() *string
	SetAwsPartition(val *string)
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
	EksClusterOidcIssuerUrl() *string
	SetEksClusterOidcIssuerUrl(val *string)
	Enabled() *bool
	SetEnabled(val *bool)
	Environment() *string
	SetEnvironment(val *string)
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
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	PermissionsBoundary() *string
	SetPermissionsBoundary(val *string)
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	ServiceAccountListQualifier() *string
	SetServiceAccountListQualifier(val *string)
	ServiceAccountName() *string
	SetServiceAccountName(val *string)
	ServiceAccountNameOutput() *string
	ServiceAccountNamespace() *string
	SetServiceAccountNamespace(val *string)
	ServiceAccountNamespaceNameList() *[]*string
	SetServiceAccountNamespaceNameList(val *[]*string)
	ServiceAccountNamespaceOutput() *string
	ServiceAccountPolicyArnOutput() *string
	ServiceAccountPolicyIdOutput() *string
	ServiceAccountPolicyNameOutput() *string
	ServiceAccountRoleArnOutput() *string
	ServiceAccountRoleNameOutput() *string
	ServiceAccountRoleUniqueIdOutput() *string
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
	// Experimental.
	Version() *string
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
	// Experimental.
	ToMetadata() interface{}
	// Returns a string representation of this construct.
	ToString() *string
	// Experimental.
	ToTerraform() interface{}
}

// The jsii proxy struct for TerraformAwsEksIamRole
type jsiiProxy_TerraformAwsEksIamRole struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsEksIamRole) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) AwsAccountNumber() *string {
	var returns *string
	_jsii_.Get(
		j,
		"awsAccountNumber",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) AwsIamPolicyDocument() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"awsIamPolicyDocument",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) AwsPartition() *string {
	var returns *string
	_jsii_.Get(
		j,
		"awsPartition",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) EksClusterOidcIssuerUrl() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterOidcIssuerUrl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) PermissionsBoundary() *string {
	var returns *string
	_jsii_.Get(
		j,
		"permissionsBoundary",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountListQualifier() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountListQualifier",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountNamespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountNamespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountNamespaceNameList() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"serviceAccountNamespaceNameList",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountNamespaceOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountNamespaceOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountPolicyArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountPolicyArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountPolicyIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountPolicyIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountPolicyNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountPolicyNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountRoleNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountRoleNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) ServiceAccountRoleUniqueIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceAccountRoleUniqueIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksIamRole) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}


func NewTerraformAwsEksIamRole(scope constructs.Construct, id *string, config *TerraformAwsEksIamRoleConfig) TerraformAwsEksIamRole {
	_init_.Initialize()

	if err := validateNewTerraformAwsEksIamRoleParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsEksIamRole{}

	_jsii_.Create(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRole",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsEksIamRole_Override(t TerraformAwsEksIamRole, scope constructs.Construct, id *string, config *TerraformAwsEksIamRoleConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRole",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetAwsAccountNumber(val *string) {
	_jsii_.Set(
		j,
		"awsAccountNumber",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetAwsIamPolicyDocument(val interface{}) {
	if err := j.validateSetAwsIamPolicyDocumentParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"awsIamPolicyDocument",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetAwsPartition(val *string) {
	_jsii_.Set(
		j,
		"awsPartition",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetEksClusterOidcIssuerUrl(val *string) {
	if err := j.validateSetEksClusterOidcIssuerUrlParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"eksClusterOidcIssuerUrl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetPermissionsBoundary(val *string) {
	_jsii_.Set(
		j,
		"permissionsBoundary",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetServiceAccountListQualifier(val *string) {
	_jsii_.Set(
		j,
		"serviceAccountListQualifier",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetServiceAccountName(val *string) {
	_jsii_.Set(
		j,
		"serviceAccountName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetServiceAccountNamespace(val *string) {
	_jsii_.Set(
		j,
		"serviceAccountNamespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetServiceAccountNamespaceNameList(val *[]*string) {
	_jsii_.Set(
		j,
		"serviceAccountNamespaceNameList",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksIamRole)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
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
func TerraformAwsEksIamRole_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksIamRole_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRole",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsEksIamRole_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksIamRole_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRole",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksIamRole) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsEksIamRole) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsEksIamRole) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsEksIamRole) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsEksIamRole) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsEksIamRole) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsEksIamRole) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksIamRole) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksIamRole) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksIamRole) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

