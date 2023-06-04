package terraform_aws_eks_node_group

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_aws_eks_node_group/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_aws_eks_node_group/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEksNodeGroup interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	AfterClusterJoiningUserdata() *[]*string
	SetAfterClusterJoiningUserdata(val *[]*string)
	AmiImageId() *[]*string
	SetAmiImageId(val *[]*string)
	AmiReleaseVersion() *[]*string
	SetAmiReleaseVersion(val *[]*string)
	AmiType() *string
	SetAmiType(val *string)
	AssociateClusterSecurityGroup() *bool
	SetAssociateClusterSecurityGroup(val *bool)
	AssociatedSecurityGroupIds() *[]*string
	SetAssociatedSecurityGroupIds(val *[]*string)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	BeforeClusterJoiningUserdata() *[]*string
	SetBeforeClusterJoiningUserdata(val *[]*string)
	BlockDeviceMappings() *[]interface{}
	SetBlockDeviceMappings(val *[]interface{})
	BootstrapAdditionalOptions() *[]*string
	SetBootstrapAdditionalOptions(val *[]*string)
	CapacityType() *string
	SetCapacityType(val *string)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	ClusterAutoscalerEnabled() *bool
	SetClusterAutoscalerEnabled(val *bool)
	ClusterName() *string
	SetClusterName(val *string)
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	CreateBeforeDestroy() *bool
	SetCreateBeforeDestroy(val *bool)
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DesiredSize() *float64
	SetDesiredSize(val *float64)
	DetailedMonitoringEnabled() *bool
	SetDetailedMonitoringEnabled(val *bool)
	EbsOptimized() *bool
	SetEbsOptimized(val *bool)
	Ec2SshKeyName() *[]*string
	SetEc2SshKeyName(val *[]*string)
	EksNodeGroupArnOutput() *string
	EksNodeGroupCbdPetNameOutput() *string
	EksNodeGroupIdOutput() *string
	EksNodeGroupLaunchTemplateIdOutput() *string
	EksNodeGroupLaunchTemplateNameOutput() *string
	EksNodeGroupRemoteAccessSecurityGroupIdOutput() *string
	EksNodeGroupResourcesOutput() *string
	EksNodeGroupRoleArnOutput() *string
	EksNodeGroupRoleNameOutput() *string
	EksNodeGroupStatusOutput() *string
	EksNodeGroupTagsAllOutput() *string
	EksNodeGroupWindowsNoteOutput() *string
	Enabled() *bool
	SetEnabled(val *bool)
	EnclaveEnabled() *bool
	SetEnclaveEnabled(val *bool)
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
	InstanceTypes() *[]*string
	SetInstanceTypes(val *[]*string)
	KubeletAdditionalOptions() *[]*string
	SetKubeletAdditionalOptions(val *[]*string)
	KubernetesLabels() *map[string]*string
	SetKubernetesLabels(val *map[string]*string)
	KubernetesTaints() interface{}
	SetKubernetesTaints(val interface{})
	KubernetesVersion() *[]*string
	SetKubernetesVersion(val *[]*string)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LaunchTemplateId() *[]*string
	SetLaunchTemplateId(val *[]*string)
	LaunchTemplateVersion() *[]*string
	SetLaunchTemplateVersion(val *[]*string)
	MaxSize() *float64
	SetMaxSize(val *float64)
	MetadataHttpEndpointEnabled() *bool
	SetMetadataHttpEndpointEnabled(val *bool)
	MetadataHttpPutResponseHopLimit() *float64
	SetMetadataHttpPutResponseHopLimit(val *float64)
	MetadataHttpTokensRequired() *bool
	SetMetadataHttpTokensRequired(val *bool)
	MinSize() *float64
	SetMinSize(val *float64)
	ModuleDependsOn() interface{}
	SetModuleDependsOn(val interface{})
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	NodeGroupTerraformTimeouts() interface{}
	SetNodeGroupTerraformTimeouts(val interface{})
	NodeRoleArn() *[]*string
	SetNodeRoleArn(val *[]*string)
	NodeRoleCniPolicyEnabled() *bool
	SetNodeRoleCniPolicyEnabled(val *bool)
	NodeRolePermissionsBoundary() *string
	SetNodeRolePermissionsBoundary(val *string)
	NodeRolePolicyArns() *[]*string
	SetNodeRolePolicyArns(val *[]*string)
	Placement() *[]interface{}
	SetPlacement(val *[]interface{})
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	ResourcesToTag() *[]*string
	SetResourcesToTag(val *[]*string)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	SshAccessSecurityGroupIds() *[]*string
	SetSshAccessSecurityGroupIds(val *[]*string)
	Stage() *string
	SetStage(val *string)
	SubnetIds() *[]*string
	SetSubnetIds(val *[]*string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	UpdateConfig() *[]*map[string]*float64
	SetUpdateConfig(val *[]*map[string]*float64)
	UserdataOverrideBase64() *[]*string
	SetUserdataOverrideBase64(val *[]*string)
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

// The jsii proxy struct for TerraformAwsEksNodeGroup
type jsiiProxy_TerraformAwsEksNodeGroup struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AfterClusterJoiningUserdata() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"afterClusterJoiningUserdata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AmiImageId() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"amiImageId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AmiReleaseVersion() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"amiReleaseVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AmiType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"amiType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AssociateClusterSecurityGroup() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"associateClusterSecurityGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) AssociatedSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"associatedSecurityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) BeforeClusterJoiningUserdata() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"beforeClusterJoiningUserdata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) BlockDeviceMappings() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"blockDeviceMappings",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) BootstrapAdditionalOptions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"bootstrapAdditionalOptions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) CapacityType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"capacityType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ClusterAutoscalerEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"clusterAutoscalerEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ClusterName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) CreateBeforeDestroy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"createBeforeDestroy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) DesiredSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"desiredSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) DetailedMonitoringEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"detailedMonitoringEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EbsOptimized() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ebsOptimized",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Ec2SshKeyName() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"ec2SshKeyName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupCbdPetNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupCbdPetNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupLaunchTemplateIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupLaunchTemplateIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupLaunchTemplateNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupLaunchTemplateNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupRemoteAccessSecurityGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupRemoteAccessSecurityGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupResourcesOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupResourcesOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupRoleNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupRoleNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupStatusOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupStatusOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupTagsAllOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupTagsAllOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EksNodeGroupWindowsNoteOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksNodeGroupWindowsNoteOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) EnclaveEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enclaveEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) InstanceTypes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"instanceTypes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) KubeletAdditionalOptions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"kubeletAdditionalOptions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) KubernetesLabels() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"kubernetesLabels",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) KubernetesTaints() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"kubernetesTaints",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) KubernetesVersion() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"kubernetesVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LaunchTemplateId() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"launchTemplateId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) LaunchTemplateVersion() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"launchTemplateVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) MaxSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) MetadataHttpEndpointEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpEndpointEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) MetadataHttpPutResponseHopLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"metadataHttpPutResponseHopLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) MetadataHttpTokensRequired() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpTokensRequired",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) MinSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ModuleDependsOn() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"moduleDependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) NodeGroupTerraformTimeouts() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"nodeGroupTerraformTimeouts",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) NodeRoleArn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"nodeRoleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) NodeRoleCniPolicyEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"nodeRoleCniPolicyEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) NodeRolePermissionsBoundary() *string {
	var returns *string
	_jsii_.Get(
		j,
		"nodeRolePermissionsBoundary",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) NodeRolePolicyArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"nodeRolePolicyArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Placement() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"placement",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) ResourcesToTag() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"resourcesToTag",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) SshAccessSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"sshAccessSecurityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) SubnetIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"subnetIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) UpdateConfig() *[]*map[string]*float64 {
	var returns *[]*map[string]*float64
	_jsii_.Get(
		j,
		"updateConfig",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) UserdataOverrideBase64() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"userdataOverrideBase64",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}


func NewTerraformAwsEksNodeGroup(scope constructs.Construct, id *string, config *TerraformAwsEksNodeGroupConfig) TerraformAwsEksNodeGroup {
	_init_.Initialize()

	if err := validateNewTerraformAwsEksNodeGroupParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsEksNodeGroup{}

	_jsii_.Create(
		"terraform_aws_eks_node_group.TerraformAwsEksNodeGroup",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsEksNodeGroup_Override(t TerraformAwsEksNodeGroup, scope constructs.Construct, id *string, config *TerraformAwsEksNodeGroupConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_eks_node_group.TerraformAwsEksNodeGroup",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAfterClusterJoiningUserdata(val *[]*string) {
	_jsii_.Set(
		j,
		"afterClusterJoiningUserdata",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAmiImageId(val *[]*string) {
	_jsii_.Set(
		j,
		"amiImageId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAmiReleaseVersion(val *[]*string) {
	_jsii_.Set(
		j,
		"amiReleaseVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAmiType(val *string) {
	_jsii_.Set(
		j,
		"amiType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAssociateClusterSecurityGroup(val *bool) {
	_jsii_.Set(
		j,
		"associateClusterSecurityGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAssociatedSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"associatedSecurityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetBeforeClusterJoiningUserdata(val *[]*string) {
	_jsii_.Set(
		j,
		"beforeClusterJoiningUserdata",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetBlockDeviceMappings(val *[]interface{}) {
	_jsii_.Set(
		j,
		"blockDeviceMappings",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetBootstrapAdditionalOptions(val *[]*string) {
	_jsii_.Set(
		j,
		"bootstrapAdditionalOptions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetCapacityType(val *string) {
	_jsii_.Set(
		j,
		"capacityType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetClusterAutoscalerEnabled(val *bool) {
	_jsii_.Set(
		j,
		"clusterAutoscalerEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetClusterName(val *string) {
	if err := j.validateSetClusterNameParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetCreateBeforeDestroy(val *bool) {
	_jsii_.Set(
		j,
		"createBeforeDestroy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetDesiredSize(val *float64) {
	if err := j.validateSetDesiredSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"desiredSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetDetailedMonitoringEnabled(val *bool) {
	_jsii_.Set(
		j,
		"detailedMonitoringEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetEbsOptimized(val *bool) {
	_jsii_.Set(
		j,
		"ebsOptimized",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetEc2SshKeyName(val *[]*string) {
	_jsii_.Set(
		j,
		"ec2SshKeyName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetEnclaveEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enclaveEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetInstanceTypes(val *[]*string) {
	_jsii_.Set(
		j,
		"instanceTypes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetKubeletAdditionalOptions(val *[]*string) {
	_jsii_.Set(
		j,
		"kubeletAdditionalOptions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetKubernetesLabels(val *map[string]*string) {
	_jsii_.Set(
		j,
		"kubernetesLabels",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetKubernetesTaints(val interface{}) {
	if err := j.validateSetKubernetesTaintsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"kubernetesTaints",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetKubernetesVersion(val *[]*string) {
	_jsii_.Set(
		j,
		"kubernetesVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLaunchTemplateId(val *[]*string) {
	_jsii_.Set(
		j,
		"launchTemplateId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetLaunchTemplateVersion(val *[]*string) {
	_jsii_.Set(
		j,
		"launchTemplateVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetMaxSize(val *float64) {
	if err := j.validateSetMaxSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"maxSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetMetadataHttpEndpointEnabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpEndpointEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetMetadataHttpPutResponseHopLimit(val *float64) {
	_jsii_.Set(
		j,
		"metadataHttpPutResponseHopLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetMetadataHttpTokensRequired(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpTokensRequired",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetMinSize(val *float64) {
	if err := j.validateSetMinSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"minSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetModuleDependsOn(val interface{}) {
	if err := j.validateSetModuleDependsOnParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"moduleDependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNodeGroupTerraformTimeouts(val interface{}) {
	if err := j.validateSetNodeGroupTerraformTimeoutsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"nodeGroupTerraformTimeouts",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNodeRoleArn(val *[]*string) {
	_jsii_.Set(
		j,
		"nodeRoleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNodeRoleCniPolicyEnabled(val *bool) {
	_jsii_.Set(
		j,
		"nodeRoleCniPolicyEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNodeRolePermissionsBoundary(val *string) {
	_jsii_.Set(
		j,
		"nodeRolePermissionsBoundary",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetNodeRolePolicyArns(val *[]*string) {
	_jsii_.Set(
		j,
		"nodeRolePolicyArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetPlacement(val *[]interface{}) {
	_jsii_.Set(
		j,
		"placement",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetResourcesToTag(val *[]*string) {
	_jsii_.Set(
		j,
		"resourcesToTag",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetSshAccessSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"sshAccessSecurityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetSubnetIds(val *[]*string) {
	if err := j.validateSetSubnetIdsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"subnetIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetUpdateConfig(val *[]*map[string]*float64) {
	_jsii_.Set(
		j,
		"updateConfig",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksNodeGroup)SetUserdataOverrideBase64(val *[]*string) {
	_jsii_.Set(
		j,
		"userdataOverrideBase64",
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
func TerraformAwsEksNodeGroup_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksNodeGroup_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_node_group.TerraformAwsEksNodeGroup",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsEksNodeGroup_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksNodeGroup_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_node_group.TerraformAwsEksNodeGroup",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsEksNodeGroup) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsEksNodeGroup) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksNodeGroup) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

