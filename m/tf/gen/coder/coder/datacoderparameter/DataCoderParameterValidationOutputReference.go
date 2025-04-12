package datacoderparameter

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/coder/coder/jsii"

	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderparameter/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type DataCoderParameterValidationOutputReference interface {
	cdktf.ComplexObject
	// the index of the complex object in a list.
	// Experimental.
	ComplexObjectIndex() interface{}
	// Experimental.
	SetComplexObjectIndex(val interface{})
	// set to true if this item is from inside a set and needs tolist() for accessing it set to "0" for single list items.
	// Experimental.
	ComplexObjectIsFromSet() *bool
	// Experimental.
	SetComplexObjectIsFromSet(val *bool)
	// The creation stack of this resolvable which will be appended to errors thrown during resolution.
	//
	// If this returns an empty array the stack will not be attached.
	// Experimental.
	CreationStack() *[]*string
	Error() *string
	SetError(val *string)
	ErrorInput() *string
	// Experimental.
	Fqn() *string
	InternalValue() *DataCoderParameterValidation
	SetInternalValue(val *DataCoderParameterValidation)
	Max() *float64
	SetMax(val *float64)
	MaxDisabled() cdktf.IResolvable
	MaxInput() *float64
	Min() *float64
	SetMin(val *float64)
	MinDisabled() cdktf.IResolvable
	MinInput() *float64
	Monotonic() *string
	SetMonotonic(val *string)
	MonotonicInput() *string
	Regex() *string
	SetRegex(val *string)
	RegexInput() *string
	// Experimental.
	TerraformAttribute() *string
	// Experimental.
	SetTerraformAttribute(val *string)
	// Experimental.
	TerraformResource() cdktf.IInterpolatingParent
	// Experimental.
	SetTerraformResource(val cdktf.IInterpolatingParent)
	// Experimental.
	ComputeFqn() *string
	// Experimental.
	GetAnyMapAttribute(terraformAttribute *string) *map[string]interface{}
	// Experimental.
	GetBooleanAttribute(terraformAttribute *string) cdktf.IResolvable
	// Experimental.
	GetBooleanMapAttribute(terraformAttribute *string) *map[string]*bool
	// Experimental.
	GetListAttribute(terraformAttribute *string) *[]*string
	// Experimental.
	GetNumberAttribute(terraformAttribute *string) *float64
	// Experimental.
	GetNumberListAttribute(terraformAttribute *string) *[]*float64
	// Experimental.
	GetNumberMapAttribute(terraformAttribute *string) *map[string]*float64
	// Experimental.
	GetStringAttribute(terraformAttribute *string) *string
	// Experimental.
	GetStringMapAttribute(terraformAttribute *string) *map[string]*string
	// Experimental.
	InterpolationAsList() cdktf.IResolvable
	// Experimental.
	InterpolationForAttribute(property *string) cdktf.IResolvable
	ResetError()
	ResetMax()
	ResetMin()
	ResetMonotonic()
	ResetRegex()
	// Produce the Token's value at resolution time.
	// Experimental.
	Resolve(_context cdktf.IResolveContext) interface{}
	// Return a string representation of this resolvable object.
	//
	// Returns a reversible string representation.
	// Experimental.
	ToString() *string
}

// The jsii proxy struct for DataCoderParameterValidationOutputReference
type jsiiProxy_DataCoderParameterValidationOutputReference struct {
	internal.Type__cdktfComplexObject
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) ComplexObjectIndex() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"complexObjectIndex",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) ComplexObjectIsFromSet() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"complexObjectIsFromSet",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) CreationStack() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"creationStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Error() *string {
	var returns *string
	_jsii_.Get(
		j,
		"error",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) ErrorInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"errorInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) InternalValue() *DataCoderParameterValidation {
	var returns *DataCoderParameterValidation
	_jsii_.Get(
		j,
		"internalValue",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Max() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"max",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) MaxDisabled() cdktf.IResolvable {
	var returns cdktf.IResolvable
	_jsii_.Get(
		j,
		"maxDisabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) MaxInput() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Min() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"min",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) MinDisabled() cdktf.IResolvable {
	var returns cdktf.IResolvable
	_jsii_.Get(
		j,
		"minDisabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) MinInput() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Monotonic() *string {
	var returns *string
	_jsii_.Get(
		j,
		"monotonic",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) MonotonicInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"monotonicInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) Regex() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regex",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) RegexInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) TerraformAttribute() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformAttribute",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) TerraformResource() cdktf.IInterpolatingParent {
	var returns cdktf.IInterpolatingParent
	_jsii_.Get(
		j,
		"terraformResource",
		&returns,
	)
	return returns
}

func NewDataCoderParameterValidationOutputReference(terraformResource cdktf.IInterpolatingParent, terraformAttribute *string) DataCoderParameterValidationOutputReference {
	_init_.Initialize()

	if err := validateNewDataCoderParameterValidationOutputReferenceParameters(terraformResource, terraformAttribute); err != nil {
		panic(err)
	}
	j := jsiiProxy_DataCoderParameterValidationOutputReference{}

	_jsii_.Create(
		"coder.dataCoderParameter.DataCoderParameterValidationOutputReference",
		[]interface{}{terraformResource, terraformAttribute},
		&j,
	)

	return &j
}

func NewDataCoderParameterValidationOutputReference_Override(d DataCoderParameterValidationOutputReference, terraformResource cdktf.IInterpolatingParent, terraformAttribute *string) {
	_init_.Initialize()

	_jsii_.Create(
		"coder.dataCoderParameter.DataCoderParameterValidationOutputReference",
		[]interface{}{terraformResource, terraformAttribute},
		d,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetComplexObjectIndex(val interface{}) {
	if err := j.validateSetComplexObjectIndexParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"complexObjectIndex",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetComplexObjectIsFromSet(val *bool) {
	if err := j.validateSetComplexObjectIsFromSetParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"complexObjectIsFromSet",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetError(val *string) {
	if err := j.validateSetErrorParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"error",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetInternalValue(val *DataCoderParameterValidation) {
	if err := j.validateSetInternalValueParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"internalValue",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetMax(val *float64) {
	if err := j.validateSetMaxParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"max",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetMin(val *float64) {
	if err := j.validateSetMinParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"min",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetMonotonic(val *string) {
	if err := j.validateSetMonotonicParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"monotonic",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetRegex(val *string) {
	if err := j.validateSetRegexParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"regex",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetTerraformAttribute(val *string) {
	if err := j.validateSetTerraformAttributeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"terraformAttribute",
		val,
	)
}

func (j *jsiiProxy_DataCoderParameterValidationOutputReference) SetTerraformResource(val cdktf.IInterpolatingParent) {
	if err := j.validateSetTerraformResourceParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"terraformResource",
		val,
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ComputeFqn() *string {
	var returns *string

	_jsii_.Invoke(
		d,
		"computeFqn",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetAnyMapAttribute(terraformAttribute *string) *map[string]interface{} {
	if err := d.validateGetAnyMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]interface{}

	_jsii_.Invoke(
		d,
		"getAnyMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetBooleanAttribute(terraformAttribute *string) cdktf.IResolvable {
	if err := d.validateGetBooleanAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		d,
		"getBooleanAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetBooleanMapAttribute(terraformAttribute *string) *map[string]*bool {
	if err := d.validateGetBooleanMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*bool

	_jsii_.Invoke(
		d,
		"getBooleanMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetListAttribute(terraformAttribute *string) *[]*string {
	if err := d.validateGetListAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *[]*string

	_jsii_.Invoke(
		d,
		"getListAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetNumberAttribute(terraformAttribute *string) *float64 {
	if err := d.validateGetNumberAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *float64

	_jsii_.Invoke(
		d,
		"getNumberAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetNumberListAttribute(terraformAttribute *string) *[]*float64 {
	if err := d.validateGetNumberListAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *[]*float64

	_jsii_.Invoke(
		d,
		"getNumberListAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetNumberMapAttribute(terraformAttribute *string) *map[string]*float64 {
	if err := d.validateGetNumberMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*float64

	_jsii_.Invoke(
		d,
		"getNumberMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetStringAttribute(terraformAttribute *string) *string {
	if err := d.validateGetStringAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *string

	_jsii_.Invoke(
		d,
		"getStringAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) GetStringMapAttribute(terraformAttribute *string) *map[string]*string {
	if err := d.validateGetStringMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*string

	_jsii_.Invoke(
		d,
		"getStringMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) InterpolationAsList() cdktf.IResolvable {
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		d,
		"interpolationAsList",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) InterpolationForAttribute(property *string) cdktf.IResolvable {
	if err := d.validateInterpolationForAttributeParameters(property); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		d,
		"interpolationForAttribute",
		[]interface{}{property},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ResetError() {
	_jsii_.InvokeVoid(
		d,
		"resetError",
		nil, // no parameters
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ResetMax() {
	_jsii_.InvokeVoid(
		d,
		"resetMax",
		nil, // no parameters
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ResetMin() {
	_jsii_.InvokeVoid(
		d,
		"resetMin",
		nil, // no parameters
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ResetMonotonic() {
	_jsii_.InvokeVoid(
		d,
		"resetMonotonic",
		nil, // no parameters
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ResetRegex() {
	_jsii_.InvokeVoid(
		d,
		"resetRegex",
		nil, // no parameters
	)
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) Resolve(_context cdktf.IResolveContext) interface{} {
	if err := d.validateResolveParameters(_context); err != nil {
		panic(err)
	}
	var returns interface{}

	_jsii_.Invoke(
		d,
		"resolve",
		[]interface{}{_context},
		&returns,
	)

	return returns
}

func (d *jsiiProxy_DataCoderParameterValidationOutputReference) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		d,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}
