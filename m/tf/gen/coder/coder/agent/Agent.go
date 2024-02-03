package agent

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/coder/coder/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/coder/coder/agent/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Represents a {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent coder_agent}.
type Agent interface {
	cdktf.TerraformResource
	Arch() *string
	SetArch(val *string)
	ArchInput() *string
	Auth() *string
	SetAuth(val *string)
	AuthInput() *string
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	// Experimental.
	Connection() interface{}
	// Experimental.
	SetConnection(val interface{})
	ConnectionTimeout() *float64
	SetConnectionTimeout(val *float64)
	ConnectionTimeoutInput() *float64
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	// Experimental.
	Count() interface{}
	// Experimental.
	SetCount(val interface{})
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	Dir() *string
	SetDir(val *string)
	DirInput() *string
	DisplayApps() AgentDisplayAppsOutputReference
	DisplayAppsInput() *AgentDisplayApps
	Env() *map[string]*string
	SetEnv(val *map[string]*string)
	EnvInput() *map[string]*string
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	Id() *string
	SetId(val *string)
	IdInput() *string
	InitScript() *string
	// Experimental.
	Lifecycle() *cdktf.TerraformResourceLifecycle
	// Experimental.
	SetLifecycle(val *cdktf.TerraformResourceLifecycle)
	LoginBeforeReady() interface{}
	SetLoginBeforeReady(val interface{})
	LoginBeforeReadyInput() interface{}
	Metadata() AgentMetadataList
	MetadataInput() interface{}
	MotdFile() *string
	SetMotdFile(val *string)
	MotdFileInput() *string
	// The tree node.
	Node() constructs.Node
	Os() *string
	SetOs(val *string)
	OsInput() *string
	// Experimental.
	Provider() cdktf.TerraformProvider
	// Experimental.
	SetProvider(val cdktf.TerraformProvider)
	// Experimental.
	Provisioners() *[]interface{}
	// Experimental.
	SetProvisioners(val *[]interface{})
	// Experimental.
	RawOverrides() interface{}
	ShutdownScript() *string
	SetShutdownScript(val *string)
	ShutdownScriptInput() *string
	ShutdownScriptTimeout() *float64
	SetShutdownScriptTimeout(val *float64)
	ShutdownScriptTimeoutInput() *float64
	StartupScript() *string
	SetStartupScript(val *string)
	StartupScriptBehavior() *string
	SetStartupScriptBehavior(val *string)
	StartupScriptBehaviorInput() *string
	StartupScriptInput() *string
	StartupScriptTimeout() *float64
	SetStartupScriptTimeout(val *float64)
	StartupScriptTimeoutInput() *float64
	// Experimental.
	TerraformGeneratorMetadata() *cdktf.TerraformProviderGeneratorMetadata
	// Experimental.
	TerraformMetaArguments() *map[string]interface{}
	// Experimental.
	TerraformResourceType() *string
	Token() *string
	TroubleshootingUrl() *string
	SetTroubleshootingUrl(val *string)
	TroubleshootingUrlInput() *string
	// Adds a user defined moveTarget string to this resource to be later used in .moveTo(moveTarget) to resolve the location of the move.
	// Experimental.
	AddMoveTarget(moveTarget *string)
	// Experimental.
	AddOverride(path *string, value interface{})
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
	HasResourceMove() interface{}
	// Experimental.
	ImportFrom(id *string, provider cdktf.TerraformProvider)
	// Experimental.
	InterpolationForAttribute(terraformAttribute *string) cdktf.IResolvable
	// Move the resource corresponding to "id" to this resource.
	//
	// Note that the resource being moved from must be marked as moved using it's instance function.
	// Experimental.
	MoveFromId(id *string)
	// Moves this resource to the target resource given by moveTarget.
	// Experimental.
	MoveTo(moveTarget *string, index interface{})
	// Moves this resource to the resource corresponding to "id".
	// Experimental.
	MoveToId(id *string)
	// Overrides the auto-generated logical ID with a specific ID.
	// Experimental.
	OverrideLogicalId(newLogicalId *string)
	PutDisplayApps(value *AgentDisplayApps)
	PutMetadata(value interface{})
	ResetAuth()
	ResetConnectionTimeout()
	ResetDir()
	ResetDisplayApps()
	ResetEnv()
	ResetId()
	ResetLoginBeforeReady()
	ResetMetadata()
	ResetMotdFile()
	// Resets a previously passed logical Id to use the auto-generated logical id again.
	// Experimental.
	ResetOverrideLogicalId()
	ResetShutdownScript()
	ResetShutdownScriptTimeout()
	ResetStartupScript()
	ResetStartupScriptBehavior()
	ResetStartupScriptTimeout()
	ResetTroubleshootingUrl()
	SynthesizeAttributes() *map[string]interface{}
	SynthesizeHclAttributes() *map[string]interface{}
	// Experimental.
	ToHclTerraform() interface{}
	// Experimental.
	ToMetadata() interface{}
	// Returns a string representation of this construct.
	ToString() *string
	// Adds this resource to the terraform JSON output.
	// Experimental.
	ToTerraform() interface{}
}

// The jsii proxy struct for Agent
type jsiiProxy_Agent struct {
	internal.Type__cdktfTerraformResource
}

func (j *jsiiProxy_Agent) Arch() *string {
	var returns *string
	_jsii_.Get(
		j,
		"arch",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ArchInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"archInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Auth() *string {
	var returns *string
	_jsii_.Get(
		j,
		"auth",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) AuthInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"authInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Connection() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"connection",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ConnectionTimeout() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"connectionTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ConnectionTimeoutInput() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"connectionTimeoutInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Count() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"count",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Dir() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dir",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) DirInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dirInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) DisplayApps() AgentDisplayAppsOutputReference {
	var returns AgentDisplayAppsOutputReference
	_jsii_.Get(
		j,
		"displayApps",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) DisplayAppsInput() *AgentDisplayApps {
	var returns *AgentDisplayApps
	_jsii_.Get(
		j,
		"displayAppsInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Env() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"env",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) EnvInput() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"envInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Id() *string {
	var returns *string
	_jsii_.Get(
		j,
		"id",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) IdInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"idInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) InitScript() *string {
	var returns *string
	_jsii_.Get(
		j,
		"initScript",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Lifecycle() *cdktf.TerraformResourceLifecycle {
	var returns *cdktf.TerraformResourceLifecycle
	_jsii_.Get(
		j,
		"lifecycle",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) LoginBeforeReady() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"loginBeforeReady",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) LoginBeforeReadyInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"loginBeforeReadyInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Metadata() AgentMetadataList {
	var returns AgentMetadataList
	_jsii_.Get(
		j,
		"metadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) MetadataInput() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"metadataInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) MotdFile() *string {
	var returns *string
	_jsii_.Get(
		j,
		"motdFile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) MotdFileInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"motdFileInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Os() *string {
	var returns *string
	_jsii_.Get(
		j,
		"os",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) OsInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"osInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Provider() cdktf.TerraformProvider {
	var returns cdktf.TerraformProvider
	_jsii_.Get(
		j,
		"provider",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Provisioners() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"provisioners",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ShutdownScript() *string {
	var returns *string
	_jsii_.Get(
		j,
		"shutdownScript",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ShutdownScriptInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"shutdownScriptInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ShutdownScriptTimeout() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"shutdownScriptTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) ShutdownScriptTimeoutInput() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"shutdownScriptTimeoutInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScript() *string {
	var returns *string
	_jsii_.Get(
		j,
		"startupScript",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScriptBehavior() *string {
	var returns *string
	_jsii_.Get(
		j,
		"startupScriptBehavior",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScriptBehaviorInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"startupScriptBehaviorInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScriptInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"startupScriptInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScriptTimeout() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"startupScriptTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) StartupScriptTimeoutInput() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"startupScriptTimeoutInput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) TerraformGeneratorMetadata() *cdktf.TerraformProviderGeneratorMetadata {
	var returns *cdktf.TerraformProviderGeneratorMetadata
	_jsii_.Get(
		j,
		"terraformGeneratorMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) TerraformMetaArguments() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"terraformMetaArguments",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) TerraformResourceType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"terraformResourceType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) Token() *string {
	var returns *string
	_jsii_.Get(
		j,
		"token",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) TroubleshootingUrl() *string {
	var returns *string
	_jsii_.Get(
		j,
		"troubleshootingUrl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_Agent) TroubleshootingUrlInput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"troubleshootingUrlInput",
		&returns,
	)
	return returns
}

// Create a new {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent coder_agent} Resource.
func NewAgent(scope constructs.Construct, id *string, config *AgentConfig) Agent {
	_init_.Initialize()

	if err := validateNewAgentParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_Agent{}

	_jsii_.Create(
		"coder.agent.Agent",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

// Create a new {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent coder_agent} Resource.
func NewAgent_Override(a Agent, scope constructs.Construct, id *string, config *AgentConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"coder.agent.Agent",
		[]interface{}{scope, id, config},
		a,
	)
}

func (j *jsiiProxy_Agent) SetArch(val *string) {
	if err := j.validateSetArchParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"arch",
		val,
	)
}

func (j *jsiiProxy_Agent) SetAuth(val *string) {
	if err := j.validateSetAuthParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"auth",
		val,
	)
}

func (j *jsiiProxy_Agent) SetConnection(val interface{}) {
	if err := j.validateSetConnectionParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"connection",
		val,
	)
}

func (j *jsiiProxy_Agent) SetConnectionTimeout(val *float64) {
	if err := j.validateSetConnectionTimeoutParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"connectionTimeout",
		val,
	)
}

func (j *jsiiProxy_Agent) SetCount(val interface{}) {
	if err := j.validateSetCountParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"count",
		val,
	)
}

func (j *jsiiProxy_Agent) SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_Agent) SetDir(val *string) {
	if err := j.validateSetDirParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"dir",
		val,
	)
}

func (j *jsiiProxy_Agent) SetEnv(val *map[string]*string) {
	if err := j.validateSetEnvParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"env",
		val,
	)
}

func (j *jsiiProxy_Agent) SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_Agent) SetId(val *string) {
	if err := j.validateSetIdParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"id",
		val,
	)
}

func (j *jsiiProxy_Agent) SetLifecycle(val *cdktf.TerraformResourceLifecycle) {
	if err := j.validateSetLifecycleParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"lifecycle",
		val,
	)
}

func (j *jsiiProxy_Agent) SetLoginBeforeReady(val interface{}) {
	if err := j.validateSetLoginBeforeReadyParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"loginBeforeReady",
		val,
	)
}

func (j *jsiiProxy_Agent) SetMotdFile(val *string) {
	if err := j.validateSetMotdFileParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"motdFile",
		val,
	)
}

func (j *jsiiProxy_Agent) SetOs(val *string) {
	if err := j.validateSetOsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"os",
		val,
	)
}

func (j *jsiiProxy_Agent) SetProvider(val cdktf.TerraformProvider) {
	_jsii_.Set(
		j,
		"provider",
		val,
	)
}

func (j *jsiiProxy_Agent) SetProvisioners(val *[]interface{}) {
	if err := j.validateSetProvisionersParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"provisioners",
		val,
	)
}

func (j *jsiiProxy_Agent) SetShutdownScript(val *string) {
	if err := j.validateSetShutdownScriptParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"shutdownScript",
		val,
	)
}

func (j *jsiiProxy_Agent) SetShutdownScriptTimeout(val *float64) {
	if err := j.validateSetShutdownScriptTimeoutParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"shutdownScriptTimeout",
		val,
	)
}

func (j *jsiiProxy_Agent) SetStartupScript(val *string) {
	if err := j.validateSetStartupScriptParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"startupScript",
		val,
	)
}

func (j *jsiiProxy_Agent) SetStartupScriptBehavior(val *string) {
	if err := j.validateSetStartupScriptBehaviorParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"startupScriptBehavior",
		val,
	)
}

func (j *jsiiProxy_Agent) SetStartupScriptTimeout(val *float64) {
	if err := j.validateSetStartupScriptTimeoutParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"startupScriptTimeout",
		val,
	)
}

func (j *jsiiProxy_Agent) SetTroubleshootingUrl(val *string) {
	if err := j.validateSetTroubleshootingUrlParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"troubleshootingUrl",
		val,
	)
}

// Generates CDKTF code for importing a Agent resource upon running "cdktf plan <stack-name>".
func Agent_GenerateConfigForImport(scope constructs.Construct, importToId *string, importFromId *string, provider cdktf.TerraformProvider) cdktf.ImportableResource {
	_init_.Initialize()

	if err := validateAgent_GenerateConfigForImportParameters(scope, importToId, importFromId); err != nil {
		panic(err)
	}
	var returns cdktf.ImportableResource

	_jsii_.StaticInvoke(
		"coder.agent.Agent",
		"generateConfigForImport",
		[]interface{}{scope, importToId, importFromId, provider},
		&returns,
	)

	return returns
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
func Agent_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateAgent_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"coder.agent.Agent",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func Agent_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateAgent_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"coder.agent.Agent",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func Agent_IsTerraformResource(x interface{}) *bool {
	_init_.Initialize()

	if err := validateAgent_IsTerraformResourceParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"coder.agent.Agent",
		"isTerraformResource",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func Agent_TfResourceType() *string {
	_init_.Initialize()
	var returns *string
	_jsii_.StaticGet(
		"coder.agent.Agent",
		"tfResourceType",
		&returns,
	)
	return returns
}

func (a *jsiiProxy_Agent) AddMoveTarget(moveTarget *string) {
	if err := a.validateAddMoveTargetParameters(moveTarget); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"addMoveTarget",
		[]interface{}{moveTarget},
	)
}

func (a *jsiiProxy_Agent) AddOverride(path *string, value interface{}) {
	if err := a.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (a *jsiiProxy_Agent) GetAnyMapAttribute(terraformAttribute *string) *map[string]interface{} {
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

func (a *jsiiProxy_Agent) GetBooleanAttribute(terraformAttribute *string) cdktf.IResolvable {
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

func (a *jsiiProxy_Agent) GetBooleanMapAttribute(terraformAttribute *string) *map[string]*bool {
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

func (a *jsiiProxy_Agent) GetListAttribute(terraformAttribute *string) *[]*string {
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

func (a *jsiiProxy_Agent) GetNumberAttribute(terraformAttribute *string) *float64 {
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

func (a *jsiiProxy_Agent) GetNumberListAttribute(terraformAttribute *string) *[]*float64 {
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

func (a *jsiiProxy_Agent) GetNumberMapAttribute(terraformAttribute *string) *map[string]*float64 {
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

func (a *jsiiProxy_Agent) GetStringAttribute(terraformAttribute *string) *string {
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

func (a *jsiiProxy_Agent) GetStringMapAttribute(terraformAttribute *string) *map[string]*string {
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

func (a *jsiiProxy_Agent) HasResourceMove() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		a,
		"hasResourceMove",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) ImportFrom(id *string, provider cdktf.TerraformProvider) {
	if err := a.validateImportFromParameters(id); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"importFrom",
		[]interface{}{id, provider},
	)
}

func (a *jsiiProxy_Agent) InterpolationForAttribute(terraformAttribute *string) cdktf.IResolvable {
	if err := a.validateInterpolationForAttributeParameters(terraformAttribute); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		a,
		"interpolationForAttribute",
		[]interface{}{terraformAttribute},
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) MoveFromId(id *string) {
	if err := a.validateMoveFromIdParameters(id); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"moveFromId",
		[]interface{}{id},
	)
}

func (a *jsiiProxy_Agent) MoveTo(moveTarget *string, index interface{}) {
	if err := a.validateMoveToParameters(moveTarget, index); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"moveTo",
		[]interface{}{moveTarget, index},
	)
}

func (a *jsiiProxy_Agent) MoveToId(id *string) {
	if err := a.validateMoveToIdParameters(id); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"moveToId",
		[]interface{}{id},
	)
}

func (a *jsiiProxy_Agent) OverrideLogicalId(newLogicalId *string) {
	if err := a.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (a *jsiiProxy_Agent) PutDisplayApps(value *AgentDisplayApps) {
	if err := a.validatePutDisplayAppsParameters(value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"putDisplayApps",
		[]interface{}{value},
	)
}

func (a *jsiiProxy_Agent) PutMetadata(value interface{}) {
	if err := a.validatePutMetadataParameters(value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		a,
		"putMetadata",
		[]interface{}{value},
	)
}

func (a *jsiiProxy_Agent) ResetAuth() {
	_jsii_.InvokeVoid(
		a,
		"resetAuth",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetConnectionTimeout() {
	_jsii_.InvokeVoid(
		a,
		"resetConnectionTimeout",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetDir() {
	_jsii_.InvokeVoid(
		a,
		"resetDir",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetDisplayApps() {
	_jsii_.InvokeVoid(
		a,
		"resetDisplayApps",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetEnv() {
	_jsii_.InvokeVoid(
		a,
		"resetEnv",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetId() {
	_jsii_.InvokeVoid(
		a,
		"resetId",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetLoginBeforeReady() {
	_jsii_.InvokeVoid(
		a,
		"resetLoginBeforeReady",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetMetadata() {
	_jsii_.InvokeVoid(
		a,
		"resetMetadata",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetMotdFile() {
	_jsii_.InvokeVoid(
		a,
		"resetMotdFile",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		a,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetShutdownScript() {
	_jsii_.InvokeVoid(
		a,
		"resetShutdownScript",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetShutdownScriptTimeout() {
	_jsii_.InvokeVoid(
		a,
		"resetShutdownScriptTimeout",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetStartupScript() {
	_jsii_.InvokeVoid(
		a,
		"resetStartupScript",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetStartupScriptBehavior() {
	_jsii_.InvokeVoid(
		a,
		"resetStartupScriptBehavior",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetStartupScriptTimeout() {
	_jsii_.InvokeVoid(
		a,
		"resetStartupScriptTimeout",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) ResetTroubleshootingUrl() {
	_jsii_.InvokeVoid(
		a,
		"resetTroubleshootingUrl",
		nil, // no parameters
	)
}

func (a *jsiiProxy_Agent) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		a,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		a,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		a,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		a,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		a,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (a *jsiiProxy_Agent) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		a,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}
