package terraform_aws_dynamic_subnets

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_aws_dynamic_subnets/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_aws_dynamic_subnets/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsDynamicSubnets interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	AvailabilityZoneAttributeStyle() *string
	SetAvailabilityZoneAttributeStyle(val *string)
	AvailabilityZoneIds() *[]*string
	SetAvailabilityZoneIds(val *[]*string)
	AvailabilityZoneIdsOutput() *string
	AvailabilityZones() *[]*string
	SetAvailabilityZones(val *[]*string)
	AvailabilityZonesOutput() *string
	AwsRouteCreateTimeout() *string
	SetAwsRouteCreateTimeout(val *string)
	AwsRouteDeleteTimeout() *string
	SetAwsRouteDeleteTimeout(val *string)
	AzPrivateRouteTableIdsMapOutput() *string
	AzPrivateSubnetsMapOutput() *string
	AzPublicRouteTableIdsMapOutput() *string
	AzPublicSubnetsMapOutput() *string
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
	IgwId() *[]*string
	SetIgwId(val *[]*string)
	Ipv4CidrBlock() *[]*string
	SetIpv4CidrBlock(val *[]*string)
	Ipv4Cidrs() interface{}
	SetIpv4Cidrs(val interface{})
	Ipv4Enabled() *bool
	SetIpv4Enabled(val *bool)
	Ipv4PrivateInstanceHostnamesEnabled() *bool
	SetIpv4PrivateInstanceHostnamesEnabled(val *bool)
	Ipv4PrivateInstanceHostnameType() *string
	SetIpv4PrivateInstanceHostnameType(val *string)
	Ipv4PublicInstanceHostnamesEnabled() *bool
	SetIpv4PublicInstanceHostnamesEnabled(val *bool)
	Ipv4PublicInstanceHostnameType() *string
	SetIpv4PublicInstanceHostnameType(val *string)
	Ipv6CidrBlock() *[]*string
	SetIpv6CidrBlock(val *[]*string)
	Ipv6Cidrs() interface{}
	SetIpv6Cidrs(val interface{})
	Ipv6EgressOnlyIgwId() *[]*string
	SetIpv6EgressOnlyIgwId(val *[]*string)
	Ipv6Enabled() *bool
	SetIpv6Enabled(val *bool)
	Ipv6PrivateInstanceHostnamesEnabled() *bool
	SetIpv6PrivateInstanceHostnamesEnabled(val *bool)
	Ipv6PublicInstanceHostnamesEnabled() *bool
	SetIpv6PublicInstanceHostnamesEnabled(val *bool)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	MapPublicIpOnLaunch() *bool
	SetMapPublicIpOnLaunch(val *bool)
	MaxNats() *float64
	SetMaxNats(val *float64)
	MaxSubnetCount() *float64
	SetMaxSubnetCount(val *float64)
	MetadataHttpEndpointEnabled() *bool
	SetMetadataHttpEndpointEnabled(val *bool)
	MetadataHttpPutResponseHopLimit() *float64
	SetMetadataHttpPutResponseHopLimit(val *float64)
	MetadataHttpTokensRequired() *bool
	SetMetadataHttpTokensRequired(val *bool)
	Name() *string
	SetName(val *string)
	NamedPrivateRouteTableIdsMapOutput() *string
	NamedPrivateSubnetsMapOutput() *string
	NamedPrivateSubnetsStatsMapOutput() *string
	NamedPublicRouteTableIdsMapOutput() *string
	NamedPublicSubnetsMapOutput() *string
	NamedPublicSubnetsStatsMapOutput() *string
	Namespace() *string
	SetNamespace(val *string)
	NatEipAllocationIdsOutput() *string
	NatElasticIps() *[]*string
	SetNatElasticIps(val *[]*string)
	NatGatewayEnabled() *bool
	SetNatGatewayEnabled(val *bool)
	NatGatewayIdsOutput() *string
	NatGatewayPublicIpsOutput() *string
	NatInstanceAmiId() *[]*string
	SetNatInstanceAmiId(val *[]*string)
	NatInstanceAmiIdOutput() *string
	NatInstanceCpuCreditsOverride() *string
	SetNatInstanceCpuCreditsOverride(val *string)
	NatInstanceEnabled() *bool
	SetNatInstanceEnabled(val *bool)
	NatInstanceIdsOutput() *string
	NatInstanceRootBlockDeviceEncrypted() *bool
	SetNatInstanceRootBlockDeviceEncrypted(val *bool)
	NatInstanceType() *string
	SetNatInstanceType(val *string)
	NatIpsOutput() *string
	// The tree node.
	Node() constructs.Node
	OpenNetworkAclIpv4RuleNumber() *float64
	SetOpenNetworkAclIpv4RuleNumber(val *float64)
	OpenNetworkAclIpv6RuleNumber() *float64
	SetOpenNetworkAclIpv6RuleNumber(val *float64)
	PrivateAssignIpv6AddressOnCreation() *bool
	SetPrivateAssignIpv6AddressOnCreation(val *bool)
	PrivateDns64Nat64Enabled() *bool
	SetPrivateDns64Nat64Enabled(val *bool)
	PrivateLabel() *string
	SetPrivateLabel(val *string)
	PrivateNetworkAclIdOutput() *string
	PrivateOpenNetworkAclEnabled() *bool
	SetPrivateOpenNetworkAclEnabled(val *bool)
	PrivateRouteTableEnabled() *bool
	SetPrivateRouteTableEnabled(val *bool)
	PrivateRouteTableIdsOutput() *string
	PrivateSubnetCidrsOutput() *string
	PrivateSubnetIdsOutput() *string
	PrivateSubnetIpv6CidrsOutput() *string
	PrivateSubnetsAdditionalTags() *map[string]*string
	SetPrivateSubnetsAdditionalTags(val *map[string]*string)
	PrivateSubnetsEnabled() *bool
	SetPrivateSubnetsEnabled(val *bool)
	// Experimental.
	Providers() *[]interface{}
	PublicAssignIpv6AddressOnCreation() *bool
	SetPublicAssignIpv6AddressOnCreation(val *bool)
	PublicDns64Nat64Enabled() *bool
	SetPublicDns64Nat64Enabled(val *bool)
	PublicLabel() *string
	SetPublicLabel(val *string)
	PublicNetworkAclIdOutput() *string
	PublicOpenNetworkAclEnabled() *bool
	SetPublicOpenNetworkAclEnabled(val *bool)
	PublicRouteTableEnabled() *bool
	SetPublicRouteTableEnabled(val *bool)
	PublicRouteTableIds() *[]*string
	SetPublicRouteTableIds(val *[]*string)
	PublicRouteTableIdsOutput() *string
	PublicRouteTablePerSubnetEnabled() *bool
	SetPublicRouteTablePerSubnetEnabled(val *bool)
	PublicSubnetCidrsOutput() *string
	PublicSubnetIdsOutput() *string
	PublicSubnetIpv6CidrsOutput() *string
	PublicSubnetsAdditionalTags() *map[string]*string
	SetPublicSubnetsAdditionalTags(val *map[string]*string)
	PublicSubnetsEnabled() *bool
	SetPublicSubnetsEnabled(val *bool)
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	RootBlockDeviceEncrypted() *bool
	SetRootBlockDeviceEncrypted(val *bool)
	RouteCreateTimeout() *string
	SetRouteCreateTimeout(val *string)
	RouteDeleteTimeout() *string
	SetRouteDeleteTimeout(val *string)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	SubnetCreateTimeout() *string
	SetSubnetCreateTimeout(val *string)
	SubnetDeleteTimeout() *string
	SetSubnetDeleteTimeout(val *string)
	SubnetsPerAzCount() *float64
	SetSubnetsPerAzCount(val *float64)
	SubnetsPerAzNames() *[]*string
	SetSubnetsPerAzNames(val *[]*string)
	SubnetTypeTagKey() *string
	SetSubnetTypeTagKey(val *string)
	SubnetTypeTagValueFormat() *string
	SetSubnetTypeTagValueFormat(val *string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	// Experimental.
	Version() *string
	VpcId() *string
	SetVpcId(val *string)
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

// The jsii proxy struct for TerraformAwsDynamicSubnets
type jsiiProxy_TerraformAwsDynamicSubnets struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AvailabilityZoneAttributeStyle() *string {
	var returns *string
	_jsii_.Get(
		j,
		"availabilityZoneAttributeStyle",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AvailabilityZoneIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"availabilityZoneIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AvailabilityZoneIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"availabilityZoneIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AvailabilityZones() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"availabilityZones",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AvailabilityZonesOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"availabilityZonesOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AwsRouteCreateTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"awsRouteCreateTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AwsRouteDeleteTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"awsRouteDeleteTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AzPrivateRouteTableIdsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"azPrivateRouteTableIdsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AzPrivateSubnetsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"azPrivateSubnetsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AzPublicRouteTableIdsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"azPublicRouteTableIdsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) AzPublicSubnetsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"azPublicSubnetsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) IgwId() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"igwId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4CidrBlock() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"ipv4CidrBlock",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4Cidrs() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv4Cidrs",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv4Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4PrivateInstanceHostnamesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv4PrivateInstanceHostnamesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4PrivateInstanceHostnameType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv4PrivateInstanceHostnameType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4PublicInstanceHostnamesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv4PublicInstanceHostnamesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv4PublicInstanceHostnameType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"ipv4PublicInstanceHostnameType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6CidrBlock() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"ipv6CidrBlock",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6Cidrs() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"ipv6Cidrs",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6EgressOnlyIgwId() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"ipv6EgressOnlyIgwId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv6Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6PrivateInstanceHostnamesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv6PrivateInstanceHostnamesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Ipv6PublicInstanceHostnamesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv6PublicInstanceHostnamesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MapPublicIpOnLaunch() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"mapPublicIpOnLaunch",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MaxNats() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxNats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MaxSubnetCount() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxSubnetCount",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MetadataHttpEndpointEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpEndpointEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MetadataHttpPutResponseHopLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"metadataHttpPutResponseHopLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) MetadataHttpTokensRequired() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpTokensRequired",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPrivateRouteTableIdsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPrivateRouteTableIdsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPrivateSubnetsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPrivateSubnetsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPrivateSubnetsStatsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPrivateSubnetsStatsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPublicRouteTableIdsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPublicRouteTableIdsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPublicSubnetsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPublicSubnetsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NamedPublicSubnetsStatsMapOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namedPublicSubnetsStatsMapOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatEipAllocationIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natEipAllocationIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatElasticIps() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"natElasticIps",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatGatewayEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"natGatewayEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatGatewayIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natGatewayIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatGatewayPublicIpsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natGatewayPublicIpsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceAmiId() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"natInstanceAmiId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceAmiIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natInstanceAmiIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceCpuCreditsOverride() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natInstanceCpuCreditsOverride",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"natInstanceEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natInstanceIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceRootBlockDeviceEncrypted() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"natInstanceRootBlockDeviceEncrypted",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatInstanceType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natInstanceType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) NatIpsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"natIpsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) OpenNetworkAclIpv4RuleNumber() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"openNetworkAclIpv4RuleNumber",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) OpenNetworkAclIpv6RuleNumber() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"openNetworkAclIpv6RuleNumber",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateAssignIpv6AddressOnCreation() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"privateAssignIpv6AddressOnCreation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateDns64Nat64Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"privateDns64Nat64Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateLabel() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateLabel",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateNetworkAclIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateNetworkAclIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateOpenNetworkAclEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"privateOpenNetworkAclEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateRouteTableEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"privateRouteTableEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateRouteTableIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateRouteTableIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateSubnetCidrsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateSubnetCidrsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateSubnetIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateSubnetIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateSubnetIpv6CidrsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"privateSubnetIpv6CidrsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateSubnetsAdditionalTags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"privateSubnetsAdditionalTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PrivateSubnetsEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"privateSubnetsEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicAssignIpv6AddressOnCreation() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicAssignIpv6AddressOnCreation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicDns64Nat64Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicDns64Nat64Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicLabel() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicLabel",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicNetworkAclIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicNetworkAclIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicOpenNetworkAclEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicOpenNetworkAclEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicRouteTableEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicRouteTableEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicRouteTableIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"publicRouteTableIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicRouteTableIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicRouteTableIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicRouteTablePerSubnetEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicRouteTablePerSubnetEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicSubnetCidrsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicSubnetCidrsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicSubnetIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicSubnetIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicSubnetIpv6CidrsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"publicSubnetIpv6CidrsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicSubnetsAdditionalTags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"publicSubnetsAdditionalTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) PublicSubnetsEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"publicSubnetsEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) RootBlockDeviceEncrypted() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"rootBlockDeviceEncrypted",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) RouteCreateTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"routeCreateTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) RouteDeleteTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"routeDeleteTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetCreateTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"subnetCreateTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetDeleteTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"subnetDeleteTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetsPerAzCount() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"subnetsPerAzCount",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetsPerAzNames() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"subnetsPerAzNames",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetTypeTagKey() *string {
	var returns *string
	_jsii_.Get(
		j,
		"subnetTypeTagKey",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) SubnetTypeTagValueFormat() *string {
	var returns *string
	_jsii_.Get(
		j,
		"subnetTypeTagValueFormat",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets) VpcId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcId",
		&returns,
	)
	return returns
}


func NewTerraformAwsDynamicSubnets(scope constructs.Construct, id *string, config *TerraformAwsDynamicSubnetsConfig) TerraformAwsDynamicSubnets {
	_init_.Initialize()

	if err := validateNewTerraformAwsDynamicSubnetsParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsDynamicSubnets{}

	_jsii_.Create(
		"terraform_aws_dynamic_subnets.TerraformAwsDynamicSubnets",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsDynamicSubnets_Override(t TerraformAwsDynamicSubnets, scope constructs.Construct, id *string, config *TerraformAwsDynamicSubnetsConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_dynamic_subnets.TerraformAwsDynamicSubnets",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAvailabilityZoneAttributeStyle(val *string) {
	_jsii_.Set(
		j,
		"availabilityZoneAttributeStyle",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAvailabilityZoneIds(val *[]*string) {
	_jsii_.Set(
		j,
		"availabilityZoneIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAvailabilityZones(val *[]*string) {
	_jsii_.Set(
		j,
		"availabilityZones",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAwsRouteCreateTimeout(val *string) {
	_jsii_.Set(
		j,
		"awsRouteCreateTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetAwsRouteDeleteTimeout(val *string) {
	_jsii_.Set(
		j,
		"awsRouteDeleteTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIgwId(val *[]*string) {
	_jsii_.Set(
		j,
		"igwId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4CidrBlock(val *[]*string) {
	_jsii_.Set(
		j,
		"ipv4CidrBlock",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4Cidrs(val interface{}) {
	if err := j.validateSetIpv4CidrsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv4Cidrs",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4Enabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv4Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4PrivateInstanceHostnamesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv4PrivateInstanceHostnamesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4PrivateInstanceHostnameType(val *string) {
	_jsii_.Set(
		j,
		"ipv4PrivateInstanceHostnameType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4PublicInstanceHostnamesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv4PublicInstanceHostnamesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv4PublicInstanceHostnameType(val *string) {
	_jsii_.Set(
		j,
		"ipv4PublicInstanceHostnameType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6CidrBlock(val *[]*string) {
	_jsii_.Set(
		j,
		"ipv6CidrBlock",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6Cidrs(val interface{}) {
	if err := j.validateSetIpv6CidrsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"ipv6Cidrs",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6EgressOnlyIgwId(val *[]*string) {
	_jsii_.Set(
		j,
		"ipv6EgressOnlyIgwId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6Enabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv6Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6PrivateInstanceHostnamesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv6PrivateInstanceHostnamesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetIpv6PublicInstanceHostnamesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv6PublicInstanceHostnamesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMapPublicIpOnLaunch(val *bool) {
	_jsii_.Set(
		j,
		"mapPublicIpOnLaunch",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMaxNats(val *float64) {
	_jsii_.Set(
		j,
		"maxNats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMaxSubnetCount(val *float64) {
	_jsii_.Set(
		j,
		"maxSubnetCount",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMetadataHttpEndpointEnabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpEndpointEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMetadataHttpPutResponseHopLimit(val *float64) {
	_jsii_.Set(
		j,
		"metadataHttpPutResponseHopLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetMetadataHttpTokensRequired(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpTokensRequired",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatElasticIps(val *[]*string) {
	_jsii_.Set(
		j,
		"natElasticIps",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatGatewayEnabled(val *bool) {
	_jsii_.Set(
		j,
		"natGatewayEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatInstanceAmiId(val *[]*string) {
	_jsii_.Set(
		j,
		"natInstanceAmiId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatInstanceCpuCreditsOverride(val *string) {
	_jsii_.Set(
		j,
		"natInstanceCpuCreditsOverride",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatInstanceEnabled(val *bool) {
	_jsii_.Set(
		j,
		"natInstanceEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatInstanceRootBlockDeviceEncrypted(val *bool) {
	_jsii_.Set(
		j,
		"natInstanceRootBlockDeviceEncrypted",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetNatInstanceType(val *string) {
	_jsii_.Set(
		j,
		"natInstanceType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetOpenNetworkAclIpv4RuleNumber(val *float64) {
	_jsii_.Set(
		j,
		"openNetworkAclIpv4RuleNumber",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetOpenNetworkAclIpv6RuleNumber(val *float64) {
	_jsii_.Set(
		j,
		"openNetworkAclIpv6RuleNumber",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateAssignIpv6AddressOnCreation(val *bool) {
	_jsii_.Set(
		j,
		"privateAssignIpv6AddressOnCreation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateDns64Nat64Enabled(val *bool) {
	_jsii_.Set(
		j,
		"privateDns64Nat64Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateLabel(val *string) {
	_jsii_.Set(
		j,
		"privateLabel",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateOpenNetworkAclEnabled(val *bool) {
	_jsii_.Set(
		j,
		"privateOpenNetworkAclEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateRouteTableEnabled(val *bool) {
	_jsii_.Set(
		j,
		"privateRouteTableEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateSubnetsAdditionalTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"privateSubnetsAdditionalTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPrivateSubnetsEnabled(val *bool) {
	_jsii_.Set(
		j,
		"privateSubnetsEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicAssignIpv6AddressOnCreation(val *bool) {
	_jsii_.Set(
		j,
		"publicAssignIpv6AddressOnCreation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicDns64Nat64Enabled(val *bool) {
	_jsii_.Set(
		j,
		"publicDns64Nat64Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicLabel(val *string) {
	_jsii_.Set(
		j,
		"publicLabel",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicOpenNetworkAclEnabled(val *bool) {
	_jsii_.Set(
		j,
		"publicOpenNetworkAclEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicRouteTableEnabled(val *bool) {
	_jsii_.Set(
		j,
		"publicRouteTableEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicRouteTableIds(val *[]*string) {
	_jsii_.Set(
		j,
		"publicRouteTableIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicRouteTablePerSubnetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"publicRouteTablePerSubnetEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicSubnetsAdditionalTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"publicSubnetsAdditionalTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetPublicSubnetsEnabled(val *bool) {
	_jsii_.Set(
		j,
		"publicSubnetsEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetRootBlockDeviceEncrypted(val *bool) {
	_jsii_.Set(
		j,
		"rootBlockDeviceEncrypted",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetRouteCreateTimeout(val *string) {
	_jsii_.Set(
		j,
		"routeCreateTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetRouteDeleteTimeout(val *string) {
	_jsii_.Set(
		j,
		"routeDeleteTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetCreateTimeout(val *string) {
	_jsii_.Set(
		j,
		"subnetCreateTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetDeleteTimeout(val *string) {
	_jsii_.Set(
		j,
		"subnetDeleteTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetsPerAzCount(val *float64) {
	_jsii_.Set(
		j,
		"subnetsPerAzCount",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetsPerAzNames(val *[]*string) {
	_jsii_.Set(
		j,
		"subnetsPerAzNames",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetTypeTagKey(val *string) {
	_jsii_.Set(
		j,
		"subnetTypeTagKey",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetSubnetTypeTagValueFormat(val *string) {
	_jsii_.Set(
		j,
		"subnetTypeTagValueFormat",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsDynamicSubnets)SetVpcId(val *string) {
	if err := j.validateSetVpcIdParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"vpcId",
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
func TerraformAwsDynamicSubnets_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsDynamicSubnets_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_dynamic_subnets.TerraformAwsDynamicSubnets",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsDynamicSubnets_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsDynamicSubnets_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_dynamic_subnets.TerraformAwsDynamicSubnets",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsDynamicSubnets) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsDynamicSubnets) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsDynamicSubnets) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

