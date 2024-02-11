package terraform_aws_vpc

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_vpc/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_vpc/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsVpc based on a Terraform module.
//
// Source at ../../mod/terraform-aws-vpc
type TerraformAwsVpc interface {
	cdktf.TerraformModule
	AdditionalCidrBlocksOutput() *string
	AdditionalCidrBlocksToAssociationIdsOutput() *string
	AdditionalIpv6CidrBlocksOutput() *string
	AdditionalIpv6CidrBlocksToAssociationIdsOutput() *string
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	AssignGeneratedIpv6CidrBlock() *bool
	SetAssignGeneratedIpv6CidrBlock(val *bool)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	DefaultNetworkAclDenyAll() *bool
	SetDefaultNetworkAclDenyAll(val *bool)
	DefaultRouteTableNoRoutes() *bool
	SetDefaultRouteTableNoRoutes(val *bool)
	DefaultSecurityGroupDenyAll() *bool
	SetDefaultSecurityGroupDenyAll(val *bool)
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DnsHostnamesEnabled() *bool
	SetDnsHostnamesEnabled(val *bool)
	DnsSupportEnabled() *bool
	SetDnsSupportEnabled(val *bool)
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
	IgwIdOutput() *string
	InstanceTenancy() *string
	SetInstanceTenancy(val *string)
	InternetGatewayEnabled() *bool
	SetInternetGatewayEnabled(val *bool)
	Ipv4AdditionalCidrBlockAssociations() interface{}
	SetIpv4AdditionalCidrBlockAssociations(val interface{})
	Ipv4CidrBlockAssociationTimeouts() interface{}
	SetIpv4CidrBlockAssociationTimeouts(val interface{})
	Ipv4PrimaryCidrBlock() *string
	SetIpv4PrimaryCidrBlock(val *string)
	Ipv4PrimaryCidrBlockAssociation() interface{}
	SetIpv4PrimaryCidrBlockAssociation(val interface{})
	Ipv6AdditionalCidrBlockAssociations() interface{}
	SetIpv6AdditionalCidrBlockAssociations(val interface{})
	Ipv6CidrBlockAssociationTimeouts() interface{}
	SetIpv6CidrBlockAssociationTimeouts(val interface{})
	Ipv6CidrBlockNetworkBorderGroup() *string
	SetIpv6CidrBlockNetworkBorderGroup(val *string)
	Ipv6CidrBlockNetworkBorderGroupOutput() *string
	Ipv6EgressOnlyIgwIdOutput() *string
	Ipv6EgressOnlyInternetGatewayEnabled() *bool
	SetIpv6EgressOnlyInternetGatewayEnabled(val *bool)
	Ipv6PrimaryCidrBlockAssociation() interface{}
	SetIpv6PrimaryCidrBlockAssociation(val interface{})
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
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
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
	VpcArnOutput() *string
	VpcCidrBlockOutput() *string
	VpcDefaultNetworkAclIdOutput() *string
	VpcDefaultRouteTableIdOutput() *string
	VpcDefaultSecurityGroupIdOutput() *string
	VpcIdOutput() *string
	VpcIpv6AssociationIdOutput() *string
	VpcIpv6CidrBlockOutput() *string
	VpcMainRouteTableIdOutput() *string
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

// The jsii proxy struct for TerraformAwsVpc
type jsiiProxy_TerraformAwsVpc struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsVpc) AdditionalCidrBlocksOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalCidrBlocksOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) AdditionalCidrBlocksToAssociationIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalCidrBlocksToAssociationIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) AdditionalIpv6CidrBlocksOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalIpv6CidrBlocksOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) AdditionalIpv6CidrBlocksToAssociationIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalIpv6CidrBlocksToAssociationIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) AssignGeneratedIpv6CidrBlock() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"assignGeneratedIpv6CidrBlock",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DefaultNetworkAclDenyAll() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"defaultNetworkAclDenyAll",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DefaultRouteTableNoRoutes() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"defaultRouteTableNoRoutes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DefaultSecurityGroupDenyAll() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"defaultSecurityGroupDenyAll",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DnsHostnamesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"dnsHostnamesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) DnsSupportEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"dnsSupportEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) IgwIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"igwIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) InstanceTenancy() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceTenancy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) InternetGatewayEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"internetGatewayEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv4AdditionalCidrBlockAssociations() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv4AdditionalCidrBlockAssociations",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv4CidrBlockAssociationTimeouts() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv4CidrBlockAssociationTimeouts",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv4PrimaryCidrBlock() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv4PrimaryCidrBlock",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv4PrimaryCidrBlockAssociation() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv4PrimaryCidrBlockAssociation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6AdditionalCidrBlockAssociations() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv6AdditionalCidrBlockAssociations",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6CidrBlockAssociationTimeouts() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv6CidrBlockAssociationTimeouts",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6CidrBlockNetworkBorderGroup() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv6CidrBlockNetworkBorderGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6CidrBlockNetworkBorderGroupOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv6CidrBlockNetworkBorderGroupOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6EgressOnlyIgwIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv6EgressOnlyIgwIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6EgressOnlyInternetGatewayEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv6EgressOnlyInternetGatewayEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Ipv6PrimaryCidrBlockAssociation() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv6PrimaryCidrBlockAssociation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcCidrBlockOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcCidrBlockOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcDefaultNetworkAclIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcDefaultNetworkAclIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcDefaultRouteTableIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcDefaultRouteTableIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcDefaultSecurityGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcDefaultSecurityGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcIpv6AssociationIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcIpv6AssociationIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcIpv6CidrBlockOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcIpv6CidrBlockOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsVpc) VpcMainRouteTableIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcMainRouteTableIdOutput",
		&returns,
	)
	return returns
}

func NewTerraformAwsVpc(scope constructs.Construct, id *string, config *TerraformAwsVpcConfig) TerraformAwsVpc {
	_init_.Initialize()

	if err := validateNewTerraformAwsVpcParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsVpc{}

	_jsii_.Create(
		"terraform_aws_vpc.TerraformAwsVpc",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsVpc_Override(t TerraformAwsVpc, scope constructs.Construct, id *string, config *TerraformAwsVpcConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_vpc.TerraformAwsVpc",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetAssignGeneratedIpv6CidrBlock(val *bool) {
	_jsii_.Set(
		j,
		"assignGeneratedIpv6CidrBlock",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDefaultNetworkAclDenyAll(val *bool) {
	_jsii_.Set(
		j,
		"defaultNetworkAclDenyAll",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDefaultRouteTableNoRoutes(val *bool) {
	_jsii_.Set(
		j,
		"defaultRouteTableNoRoutes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDefaultSecurityGroupDenyAll(val *bool) {
	_jsii_.Set(
		j,
		"defaultSecurityGroupDenyAll",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDnsHostnamesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"dnsHostnamesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetDnsSupportEnabled(val *bool) {
	_jsii_.Set(
		j,
		"dnsSupportEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetInstanceTenancy(val *string) {
	_jsii_.Set(
		j,
		"instanceTenancy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetInternetGatewayEnabled(val *bool) {
	_jsii_.Set(
		j,
		"internetGatewayEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv4AdditionalCidrBlockAssociations(val interface{}) {
	if err := j.validateSetIpv4AdditionalCidrBlockAssociationsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv4AdditionalCidrBlockAssociations",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv4CidrBlockAssociationTimeouts(val interface{}) {
	if err := j.validateSetIpv4CidrBlockAssociationTimeoutsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv4CidrBlockAssociationTimeouts",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv4PrimaryCidrBlock(val *string) {
	_jsii_.Set(
		j,
		"ipv4PrimaryCidrBlock",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv4PrimaryCidrBlockAssociation(val interface{}) {
	if err := j.validateSetIpv4PrimaryCidrBlockAssociationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv4PrimaryCidrBlockAssociation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv6AdditionalCidrBlockAssociations(val interface{}) {
	if err := j.validateSetIpv6AdditionalCidrBlockAssociationsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv6AdditionalCidrBlockAssociations",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv6CidrBlockAssociationTimeouts(val interface{}) {
	if err := j.validateSetIpv6CidrBlockAssociationTimeoutsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv6CidrBlockAssociationTimeouts",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv6CidrBlockNetworkBorderGroup(val *string) {
	_jsii_.Set(
		j,
		"ipv6CidrBlockNetworkBorderGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv6EgressOnlyInternetGatewayEnabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv6EgressOnlyInternetGatewayEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetIpv6PrimaryCidrBlockAssociation(val interface{}) {
	if err := j.validateSetIpv6PrimaryCidrBlockAssociationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv6PrimaryCidrBlockAssociation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsVpc) SetTenant(val *string) {
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
func TerraformAwsVpc_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsVpc_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_vpc.TerraformAwsVpc",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsVpc_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsVpc_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_vpc.TerraformAwsVpc",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsVpc) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsVpc) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsVpc) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsVpc) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsVpc) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsVpc) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsVpc) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}
