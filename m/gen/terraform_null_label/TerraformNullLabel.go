package terraform_null_label

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_null_label/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_null_label/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformNullLabel based on a Terraform module.
//
// Source at ./tf/mod/terraform-null-label
type TerraformNullLabel interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	AdditionalTagMapOutput() *string
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	AttributesOutput() *string
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	ContextOutput() *string
	Delimiter() *string
	SetDelimiter(val *string)
	DelimiterOutput() *string
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DescriptorsOutput() *string
	Enabled() *bool
	SetEnabled(val *bool)
	EnabledOutput() *string
	Environment() *string
	SetEnvironment(val *string)
	EnvironmentOutput() *string
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	IdFullOutput() *string
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	IdLengthLimitOutput() *string
	IdOutput() *string
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelOrderOutput() *string
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	Name() *string
	SetName(val *string)
	NameOutput() *string
	Namespace() *string
	SetNamespace(val *string)
	NamespaceOutput() *string
	// The tree node.
	Node() constructs.Node
	NormalizedContextOutput() *string
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	RegexReplaceCharsOutput() *string
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	StageOutput() *string
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	TagsAsListOfMapsOutput() *string
	TagsOutput() *string
	Tenant() *string
	SetTenant(val *string)
	TenantOutput() *string
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

// The jsii proxy struct for TerraformNullLabel
type jsiiProxy_TerraformNullLabel struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformNullLabel) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) AdditionalTagMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalTagMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) AttributesOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"attributesOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) ContextOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"contextOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) DelimiterOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiterOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) DescriptorsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"descriptorsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) EnabledOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"enabledOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) EnvironmentOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environmentOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) IdFullOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"idFullOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) IdLengthLimitOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"idLengthLimitOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) IdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"idOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) LabelOrderOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelOrderOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) NameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"nameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) NamespaceOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespaceOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) NormalizedContextOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"normalizedContextOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) RegexReplaceCharsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceCharsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) StageOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stageOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) TagsAsListOfMapsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tagsAsListOfMapsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) TagsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tagsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) TenantOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenantOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformNullLabel) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}


func NewTerraformNullLabel(scope constructs.Construct, id *string, config *TerraformNullLabelConfig) TerraformNullLabel {
	_init_.Initialize()

	if err := validateNewTerraformNullLabelParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformNullLabel{}

	_jsii_.Create(
		"terraform_null_label.TerraformNullLabel",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformNullLabel_Override(t TerraformNullLabel, scope constructs.Construct, id *string, config *TerraformNullLabelConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_null_label.TerraformNullLabel",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformNullLabel)SetTenant(val *string) {
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
func TerraformNullLabel_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformNullLabel_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_null_label.TerraformNullLabel",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformNullLabel_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformNullLabel_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_null_label.TerraformNullLabel",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformNullLabel) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformNullLabel) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformNullLabel) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformNullLabel) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformNullLabel) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformNullLabel) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformNullLabel) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

