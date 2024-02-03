package agent

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/coder/coder/jsii"

	"github.com/defn/dev/m/tf/gen/coder/coder/agent/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type AgentDisplayAppsOutputReference interface {
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
	// Experimental.
	Fqn() *string
	InternalValue() *AgentDisplayApps
	SetInternalValue(val *AgentDisplayApps)
	PortForwardingHelper() interface{}
	SetPortForwardingHelper(val interface{})
	PortForwardingHelperInput() interface{}
	SshHelper() interface{}
	SetSshHelper(val interface{})
	SshHelperInput() interface{}
	// Experimental.
	TerraformAttribute() *string
	// Experimental.
	SetTerraformAttribute(val *string)
	// Experimental.
	TerraformResource() cdktf.IInterpolatingParent
	// Experimental.
	SetTerraformResource(val cdktf.IInterpolatingParent)
	Vscode() interface{}
	SetVscode(val interface{})
	VscodeInput() interface{}
	VscodeInsiders() interface{}
	SetVscodeInsiders(val interface{})
	VscodeInsidersInput() interface{}
	WebTerminal() interface{}
	SetWebTerminal(val interface{})
	WebTerminalInput() interface{}
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
	ResetPortForwardingHelper()
	ResetSshHelper()
	ResetVscode()
	ResetVscodeInsiders()
	ResetWebTerminal()
	// Produce the Token's value at resolution time.
	// Experimental.
	Resolve(_context cdktf.IResolveContext) interface{}
	// Return a string representation of this resolvable object.
	//
	// Returns a reversible string representation.
	// Experimental.
	ToString() *string
}

// The jsii proxy struct for AgentDisplayAppsOutputReference
type jsiiProxy_AgentDisplayAppsOutputReference struct {
	internal.Type__cdktfComplexObject
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) ComplexObjectIndex() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"complexObjectIndex",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) ComplexObjectIsFromSet() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"complexObjectIsFromSet",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) CreationStack() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"creationStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) InternalValue() *AgentDisplayApps {
	var returns *AgentDisplayApps
	_jsii_.Get(
		j,
		"internalValue",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) PortForwardingHelper() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"portForwardingHelper",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) PortForwardingHelperInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"portForwardingHelperInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SshHelper() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"sshHelper",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SshHelperInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"sshHelperInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) TerraformAttribute() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformAttribute",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) TerraformResource() cdktf.IInterpolatingParent {
	var returns cdktf.IInterpolatingParent
	_jsii_.Get(
		j,
		"terraformResource",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) Vscode() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"vscode",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) VscodeInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"vscodeInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) VscodeInsiders() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"vscodeInsiders",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) VscodeInsidersInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"vscodeInsidersInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) WebTerminal() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"webTerminal",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) WebTerminalInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"webTerminalInput",
		&returns,
	)
	return returns
}

func NewAgentDisplayAppsOutputReference(terraformResource cdktf.IInterpolatingParent, terraformAttribute *string) AgentDisplayAppsOutputReference {
	_init_.Initialize()

	if err := validateNewAgentDisplayAppsOutputReferenceParameters(terraformResource, terraformAttribute); err != nil {
		panic(err)
	}
	j := jsiiProxy_AgentDisplayAppsOutputReference{}

	_jsii_.Create(
		"coder.agent.AgentDisplayAppsOutputReference",
		[]interface{}{terraformResource, terraformAttribute},
		&j,
	)

	return &j
}

func NewAgentDisplayAppsOutputReference_Override(a AgentDisplayAppsOutputReference, terraformResource cdktf.IInterpolatingParent, terraformAttribute *string) {
	_init_.Initialize()

	_jsii_.Create(
		"coder.agent.AgentDisplayAppsOutputReference",
		[]interface{}{terraformResource, terraformAttribute},
		a,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetComplexObjectIndex(val interface{}) {
	if err := j.validateSetComplexObjectIndexParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"complexObjectIndex",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetComplexObjectIsFromSet(val *bool) {
	if err := j.validateSetComplexObjectIsFromSetParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"complexObjectIsFromSet",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetInternalValue(val *AgentDisplayApps) {
	if err := j.validateSetInternalValueParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"internalValue",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetPortForwardingHelper(val interface{}) {
	if err := j.validateSetPortForwardingHelperParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"portForwardingHelper",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetSshHelper(val interface{}) {
	if err := j.validateSetSshHelperParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"sshHelper",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetTerraformAttribute(val *string) {
	if err := j.validateSetTerraformAttributeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"terraformAttribute",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetTerraformResource(val cdktf.IInterpolatingParent) {
	if err := j.validateSetTerraformResourceParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"terraformResource",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetVscode(val interface{}) {
	if err := j.validateSetVscodeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"vscode",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetVscodeInsiders(val interface{}) {
	if err := j.validateSetVscodeInsidersParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"vscodeInsiders",
		val,
	)
}

func (j *jsiiProxy_AgentDisplayAppsOutputReference) SetWebTerminal(val interface{}) {
	if err := j.validateSetWebTerminalParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"webTerminal",
		val,
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ComputeFqn() *string {
	var returns *string

	_jsii_.Invoke(
		a,
		"computeFqn",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetAnyMapAttribute(terraformAttribute *string) *map[string]interface{} {
	if err := a.validateGetAnyMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]interface{}

	_jsii_.Invoke(
		a,
		"getAnyMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetBooleanAttribute(terraformAttribute *string) cdktf.IResolvable {
	if err := a.validateGetBooleanAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		a,
		"getBooleanAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetBooleanMapAttribute(terraformAttribute *string) *map[string]*bool {
	if err := a.validateGetBooleanMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*bool

	_jsii_.Invoke(
		a,
		"getBooleanMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetListAttribute(terraformAttribute *string) *[]*string {
	if err := a.validateGetListAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *[]*string

	_jsii_.Invoke(
		a,
		"getListAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetNumberAttribute(terraformAttribute *string) *float64 {
	if err := a.validateGetNumberAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *float64

	_jsii_.Invoke(
		a,
		"getNumberAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetNumberListAttribute(terraformAttribute *string) *[]*float64 {
	if err := a.validateGetNumberListAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *[]*float64

	_jsii_.Invoke(
		a,
		"getNumberListAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetNumberMapAttribute(terraformAttribute *string) *map[string]*float64 {
	if err := a.validateGetNumberMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*float64

	_jsii_.Invoke(
		a,
		"getNumberMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetStringAttribute(terraformAttribute *string) *string {
	if err := a.validateGetStringAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *string

	_jsii_.Invoke(
		a,
		"getStringAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) GetStringMapAttribute(terraformAttribute *string) *map[string]*string {
	if err := a.validateGetStringMapAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns *map[string]*string

	_jsii_.Invoke(
		a,
		"getStringMapAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) InterpolationAsList() cdktf.IResolvable {
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		a,
		"interpolationAsList",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) InterpolationForAttribute(property *string) cdktf.IResolvable {
	if err := a.validateInterpolationForAttributeParameters(property); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		a,
		"interpolationForAttribute",
		[]interface{}{property},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ResetPortForwardingHelper() {
	_jsii_.InvokeVoid(
		a,
		"resetPortForwardingHelper",
		nil, // no parameters
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ResetSshHelper() {
	_jsii_.InvokeVoid(
		a,
		"resetSshHelper",
		nil, // no parameters
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ResetVscode() {
	_jsii_.InvokeVoid(
		a,
		"resetVscode",
		nil, // no parameters
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ResetVscodeInsiders() {
	_jsii_.InvokeVoid(
		a,
		"resetVscodeInsiders",
		nil, // no parameters
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ResetWebTerminal() {
	_jsii_.InvokeVoid(
		a,
		"resetWebTerminal",
		nil, // no parameters
	)
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) Resolve(_context cdktf.IResolveContext) interface{} {
	if err := a.validateResolveParameters(_context); err != nil {
		panic(err)
	}
	var returns interface{}

	_jsii_.Invoke(
		a,
		"resolve",
		[]interface{}{_context},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_AgentDisplayAppsOutputReference) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		a,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}
