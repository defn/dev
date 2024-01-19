package terraform_aws_iam_role

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_iam_role/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_iam_role/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsIamRole based on a Terraform module.
//
// Source at ./mod/terraform-aws-iam-role
type TerraformAwsIamRole interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	ArnOutput() *string
	AssumeRoleActions() *[]*string
	SetAssumeRoleActions(val *[]*string)
	AssumeRoleConditions() interface{}
	SetAssumeRoleConditions(val interface{})
	Attributes() *[]*string
	SetAttributes(val *[]*string)
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
	IdOutput() *string
	InstanceProfileEnabled() *bool
	SetInstanceProfileEnabled(val *bool)
	InstanceProfileOutput() *string
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	ManagedPolicyArns() *[]*string
	SetManagedPolicyArns(val *[]*string)
	MaxSessionDuration() *float64
	SetMaxSessionDuration(val *float64)
	Name() *string
	SetName(val *string)
	NameOutput() *string
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	Path() *string
	SetPath(val *string)
	PermissionsBoundary() *string
	SetPermissionsBoundary(val *string)
	PolicyDescription() *string
	SetPolicyDescription(val *string)
	PolicyDocumentCount() *float64
	SetPolicyDocumentCount(val *float64)
	PolicyDocuments() *[]*string
	SetPolicyDocuments(val *[]*string)
	PolicyName() *string
	SetPolicyName(val *string)
	PolicyOutput() *string
	Principals() *map[string]*[]*string
	SetPrincipals(val *map[string]*[]*string)
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	RoleDescription() *string
	SetRoleDescription(val *string)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	TagsEnabled() *string
	SetTagsEnabled(val *string)
	Tenant() *string
	SetTenant(val *string)
	UseFullname() *bool
	SetUseFullname(val *bool)
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

// The jsii proxy struct for TerraformAwsIamRole
type jsiiProxy_TerraformAwsIamRole struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsIamRole) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) ArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"arnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) AssumeRoleActions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"assumeRoleActions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) AssumeRoleConditions() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"assumeRoleConditions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) IdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"idOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) InstanceProfileEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"instanceProfileEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) InstanceProfileOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceProfileOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) ManagedPolicyArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"managedPolicyArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) MaxSessionDuration() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxSessionDuration",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) NameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"nameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Path() *string {
	var returns *string
	_jsii_.Get(
		j,
		"path",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PermissionsBoundary() *string {
	var returns *string
	_jsii_.Get(
		j,
		"permissionsBoundary",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PolicyDescription() *string {
	var returns *string
	_jsii_.Get(
		j,
		"policyDescription",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PolicyDocumentCount() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"policyDocumentCount",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PolicyDocuments() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"policyDocuments",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PolicyName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"policyName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) PolicyOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"policyOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Principals() *map[string]*[]*string {
	var returns *map[string]*[]*string
	_jsii_.Get(
		j,
		"principals",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) RoleDescription() *string {
	var returns *string
	_jsii_.Get(
		j,
		"roleDescription",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) TagsEnabled() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tagsEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) UseFullname() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"useFullname",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsIamRole) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}


func NewTerraformAwsIamRole(scope constructs.Construct, id *string, config *TerraformAwsIamRoleConfig) TerraformAwsIamRole {
	_init_.Initialize()

	if err := validateNewTerraformAwsIamRoleParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsIamRole{}

	_jsii_.Create(
		"terraform_aws_iam_role.TerraformAwsIamRole",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsIamRole_Override(t TerraformAwsIamRole, scope constructs.Construct, id *string, config *TerraformAwsIamRoleConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_iam_role.TerraformAwsIamRole",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetAssumeRoleActions(val *[]*string) {
	_jsii_.Set(
		j,
		"assumeRoleActions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetAssumeRoleConditions(val interface{}) {
	if err := j.validateSetAssumeRoleConditionsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"assumeRoleConditions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetInstanceProfileEnabled(val *bool) {
	_jsii_.Set(
		j,
		"instanceProfileEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetManagedPolicyArns(val *[]*string) {
	_jsii_.Set(
		j,
		"managedPolicyArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetMaxSessionDuration(val *float64) {
	_jsii_.Set(
		j,
		"maxSessionDuration",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPath(val *string) {
	_jsii_.Set(
		j,
		"path",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPermissionsBoundary(val *string) {
	_jsii_.Set(
		j,
		"permissionsBoundary",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPolicyDescription(val *string) {
	_jsii_.Set(
		j,
		"policyDescription",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPolicyDocumentCount(val *float64) {
	_jsii_.Set(
		j,
		"policyDocumentCount",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPolicyDocuments(val *[]*string) {
	_jsii_.Set(
		j,
		"policyDocuments",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPolicyName(val *string) {
	_jsii_.Set(
		j,
		"policyName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetPrincipals(val *map[string]*[]*string) {
	_jsii_.Set(
		j,
		"principals",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetRoleDescription(val *string) {
	if err := j.validateSetRoleDescriptionParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"roleDescription",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetTagsEnabled(val *string) {
	_jsii_.Set(
		j,
		"tagsEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsIamRole)SetUseFullname(val *bool) {
	_jsii_.Set(
		j,
		"useFullname",
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
func TerraformAwsIamRole_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsIamRole_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_iam_role.TerraformAwsIamRole",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsIamRole_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsIamRole_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_iam_role.TerraformAwsIamRole",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsIamRole) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsIamRole) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsIamRole) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsIamRole) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsIamRole) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsIamRole) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsIamRole) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

