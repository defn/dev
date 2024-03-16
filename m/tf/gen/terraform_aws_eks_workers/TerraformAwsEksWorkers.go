package terraform_aws_eks_workers

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_eks_workers/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_eks_workers/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsEksWorkers based on a Terraform module.
//
// Source at ./mod/terraform-aws-eks-workers
type TerraformAwsEksWorkers interface {
	cdktf.TerraformModule
	AdditionalSecurityGroupIds() *[]*string
	SetAdditionalSecurityGroupIds(val *[]*string)
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	AfterClusterJoiningUserdata() *string
	SetAfterClusterJoiningUserdata(val *string)
	AllowedCidrBlocks() *[]*string
	SetAllowedCidrBlocks(val *[]*string)
	AllowedSecurityGroups() *[]*string
	SetAllowedSecurityGroups(val *[]*string)
	AssociatePublicIpAddress() *bool
	SetAssociatePublicIpAddress(val *bool)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	AutoscalingGroupArnOutput() *string
	AutoscalingGroupDefaultCooldownOutput() *string
	AutoscalingGroupDesiredCapacityOutput() *string
	AutoscalingGroupHealthCheckGracePeriodOutput() *string
	AutoscalingGroupHealthCheckTypeOutput() *string
	AutoscalingGroupIdOutput() *string
	AutoscalingGroupMaxSizeOutput() *string
	AutoscalingGroupMinSizeOutput() *string
	AutoscalingGroupNameOutput() *string
	AutoscalingGroupTags() *map[string]*string
	SetAutoscalingGroupTags(val *map[string]*string)
	AutoscalingGroupTagsOutput() *string
	AutoscalingPoliciesEnabled() *bool
	SetAutoscalingPoliciesEnabled(val *bool)
	AwsIamInstanceProfileName() *string
	SetAwsIamInstanceProfileName(val *string)
	BeforeClusterJoiningUserdata() *string
	SetBeforeClusterJoiningUserdata(val *string)
	BlockDeviceMappings() interface{}
	SetBlockDeviceMappings(val interface{})
	BootstrapExtraArgs() *string
	SetBootstrapExtraArgs(val *string)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	ClusterCertificateAuthorityData() *string
	SetClusterCertificateAuthorityData(val *string)
	ClusterEndpoint() *string
	SetClusterEndpoint(val *string)
	ClusterName() *string
	SetClusterName(val *string)
	ClusterSecurityGroupId() *string
	SetClusterSecurityGroupId(val *string)
	ClusterSecurityGroupIngressEnabled() *bool
	SetClusterSecurityGroupIngressEnabled(val *bool)
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	CpuUtilizationHighEvaluationPeriods() *float64
	SetCpuUtilizationHighEvaluationPeriods(val *float64)
	CpuUtilizationHighPeriodSeconds() *float64
	SetCpuUtilizationHighPeriodSeconds(val *float64)
	CpuUtilizationHighStatistic() *string
	SetCpuUtilizationHighStatistic(val *string)
	CpuUtilizationHighThresholdPercent() *float64
	SetCpuUtilizationHighThresholdPercent(val *float64)
	CpuUtilizationLowEvaluationPeriods() *float64
	SetCpuUtilizationLowEvaluationPeriods(val *float64)
	CpuUtilizationLowPeriodSeconds() *float64
	SetCpuUtilizationLowPeriodSeconds(val *float64)
	CpuUtilizationLowStatistic() *string
	SetCpuUtilizationLowStatistic(val *string)
	CpuUtilizationLowThresholdPercent() *float64
	SetCpuUtilizationLowThresholdPercent(val *float64)
	CreditSpecification() interface{}
	SetCreditSpecification(val interface{})
	DefaultCooldown() *float64
	SetDefaultCooldown(val *float64)
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DisableApiTermination() *bool
	SetDisableApiTermination(val *bool)
	EbsOptimized() *bool
	SetEbsOptimized(val *bool)
	EksWorkerAmiNameFilter() *string
	SetEksWorkerAmiNameFilter(val *string)
	EksWorkerAmiNameRegex() *string
	SetEksWorkerAmiNameRegex(val *string)
	ElasticGpuSpecifications() interface{}
	SetElasticGpuSpecifications(val interface{})
	Enabled() *bool
	SetEnabled(val *bool)
	EnabledMetrics() *[]*string
	SetEnabledMetrics(val *[]*string)
	EnableMonitoring() *bool
	SetEnableMonitoring(val *bool)
	Environment() *string
	SetEnvironment(val *string)
	ForceDelete() *bool
	SetForceDelete(val *bool)
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	HealthCheckGracePeriod() *float64
	SetHealthCheckGracePeriod(val *float64)
	HealthCheckType() *string
	SetHealthCheckType(val *string)
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	ImageId() *string
	SetImageId(val *string)
	InstanceInitiatedShutdownBehavior() *string
	SetInstanceInitiatedShutdownBehavior(val *string)
	InstanceMarketOptions() interface{}
	SetInstanceMarketOptions(val interface{})
	InstanceType() *string
	SetInstanceType(val *string)
	KeyName() *string
	SetKeyName(val *string)
	KubeletExtraArgs() *string
	SetKubeletExtraArgs(val *string)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LaunchTemplateArnOutput() *string
	LaunchTemplateIdOutput() *string
	LoadBalancers() *[]*string
	SetLoadBalancers(val *[]*string)
	MaxSize() *float64
	SetMaxSize(val *float64)
	MetadataHttpEndpointEnabled() *bool
	SetMetadataHttpEndpointEnabled(val *bool)
	MetadataHttpPutResponseHopLimit() *float64
	SetMetadataHttpPutResponseHopLimit(val *float64)
	MetadataHttpTokensRequired() *bool
	SetMetadataHttpTokensRequired(val *bool)
	MetricsGranularity() *string
	SetMetricsGranularity(val *string)
	MinElbCapacity() *float64
	SetMinElbCapacity(val *float64)
	MinSize() *float64
	SetMinSize(val *float64)
	MixedInstancesPolicy() interface{}
	SetMixedInstancesPolicy(val interface{})
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	Placement() interface{}
	SetPlacement(val interface{})
	PlacementGroup() *string
	SetPlacementGroup(val *string)
	ProtectFromScaleIn() *bool
	SetProtectFromScaleIn(val *bool)
	// Experimental.
	Providers() *[]interface{}
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	ScaleDownAdjustmentType() *string
	SetScaleDownAdjustmentType(val *string)
	ScaleDownCooldownSeconds() *float64
	SetScaleDownCooldownSeconds(val *float64)
	ScaleDownPolicyType() *string
	SetScaleDownPolicyType(val *string)
	ScaleDownScalingAdjustment() *float64
	SetScaleDownScalingAdjustment(val *float64)
	ScaleUpAdjustmentType() *string
	SetScaleUpAdjustmentType(val *string)
	ScaleUpCooldownSeconds() *float64
	SetScaleUpCooldownSeconds(val *float64)
	ScaleUpPolicyType() *string
	SetScaleUpPolicyType(val *string)
	ScaleUpScalingAdjustment() *float64
	SetScaleUpScalingAdjustment(val *float64)
	SecurityGroupArnOutput() *string
	SecurityGroupIdOutput() *string
	SecurityGroupNameOutput() *string
	ServiceLinkedRoleArn() *string
	SetServiceLinkedRoleArn(val *string)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	SubnetIds() *[]*string
	SetSubnetIds(val *[]*string)
	SuspendedProcesses() *[]*string
	SetSuspendedProcesses(val *[]*string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	TargetGroupArns() *[]*string
	SetTargetGroupArns(val *[]*string)
	TerminationPolicies() *[]*string
	SetTerminationPolicies(val *[]*string)
	UseCustomImageId() *bool
	SetUseCustomImageId(val *bool)
	UseExistingAwsIamInstanceProfile() *bool
	SetUseExistingAwsIamInstanceProfile(val *bool)
	UseExistingSecurityGroup() *bool
	SetUseExistingSecurityGroup(val *bool)
	// Experimental.
	Version() *string
	VpcId() *string
	SetVpcId(val *string)
	WaitForCapacityTimeout() *string
	SetWaitForCapacityTimeout(val *string)
	WaitForElbCapacity() *float64
	SetWaitForElbCapacity(val *float64)
	WorkersRoleArnOutput() *string
	WorkersRoleNameOutput() *string
	WorkersRolePolicyArns() *[]*string
	SetWorkersRolePolicyArns(val *[]*string)
	WorkersRolePolicyArnsCount() *float64
	SetWorkersRolePolicyArnsCount(val *float64)
	WorkersSecurityGroupId() *string
	SetWorkersSecurityGroupId(val *string)
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

// The jsii proxy struct for TerraformAwsEksWorkers
type jsiiProxy_TerraformAwsEksWorkers struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AdditionalSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"additionalSecurityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AfterClusterJoiningUserdata() *string {
	var returns *string
	_jsii_.Get(
		j,
		"afterClusterJoiningUserdata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AllowedCidrBlocks() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedCidrBlocks",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AllowedSecurityGroups() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedSecurityGroups",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AssociatePublicIpAddress() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"associatePublicIpAddress",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupDefaultCooldownOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupDefaultCooldownOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupDesiredCapacityOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupDesiredCapacityOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupHealthCheckGracePeriodOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupHealthCheckGracePeriodOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupHealthCheckTypeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupHealthCheckTypeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupMaxSizeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupMaxSizeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupMinSizeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupMinSizeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupTags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"autoscalingGroupTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingGroupTagsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupTagsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AutoscalingPoliciesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"autoscalingPoliciesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) AwsIamInstanceProfileName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"awsIamInstanceProfileName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) BeforeClusterJoiningUserdata() *string {
	var returns *string
	_jsii_.Get(
		j,
		"beforeClusterJoiningUserdata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) BlockDeviceMappings() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"blockDeviceMappings",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) BootstrapExtraArgs() *string {
	var returns *string
	_jsii_.Get(
		j,
		"bootstrapExtraArgs",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ClusterCertificateAuthorityData() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterCertificateAuthorityData",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ClusterEndpoint() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEndpoint",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ClusterName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ClusterSecurityGroupId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterSecurityGroupId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ClusterSecurityGroupIngressEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"clusterSecurityGroupIngressEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationHighEvaluationPeriods() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighEvaluationPeriods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationHighPeriodSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighPeriodSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationHighStatistic() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cpuUtilizationHighStatistic",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationHighThresholdPercent() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighThresholdPercent",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationLowEvaluationPeriods() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowEvaluationPeriods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationLowPeriodSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowPeriodSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationLowStatistic() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cpuUtilizationLowStatistic",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CpuUtilizationLowThresholdPercent() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowThresholdPercent",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) CreditSpecification() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"creditSpecification",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) DefaultCooldown() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"defaultCooldown",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) DisableApiTermination() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"disableApiTermination",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) EbsOptimized() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ebsOptimized",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) EksWorkerAmiNameFilter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksWorkerAmiNameFilter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) EksWorkerAmiNameRegex() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksWorkerAmiNameRegex",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ElasticGpuSpecifications() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"elasticGpuSpecifications",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) EnabledMetrics() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"enabledMetrics",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) EnableMonitoring() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enableMonitoring",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ForceDelete() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"forceDelete",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) HealthCheckGracePeriod() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"healthCheckGracePeriod",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) HealthCheckType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"healthCheckType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ImageId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"imageId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) InstanceInitiatedShutdownBehavior() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceInitiatedShutdownBehavior",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) InstanceMarketOptions() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"instanceMarketOptions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) InstanceType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) KeyName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"keyName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) KubeletExtraArgs() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubeletExtraArgs",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LaunchTemplateArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"launchTemplateArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LaunchTemplateIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"launchTemplateIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) LoadBalancers() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"loadBalancers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MaxSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MetadataHttpEndpointEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpEndpointEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MetadataHttpPutResponseHopLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"metadataHttpPutResponseHopLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MetadataHttpTokensRequired() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpTokensRequired",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MetricsGranularity() *string {
	var returns *string
	_jsii_.Get(
		j,
		"metricsGranularity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MinElbCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minElbCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MinSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) MixedInstancesPolicy() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"mixedInstancesPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Placement() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"placement",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) PlacementGroup() *string {
	var returns *string
	_jsii_.Get(
		j,
		"placementGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ProtectFromScaleIn() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"protectFromScaleIn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleDownAdjustmentType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleDownAdjustmentType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleDownCooldownSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleDownCooldownSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleDownPolicyType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleDownPolicyType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleDownScalingAdjustment() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleDownScalingAdjustment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleUpAdjustmentType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleUpAdjustmentType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleUpCooldownSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleUpCooldownSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleUpPolicyType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleUpPolicyType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ScaleUpScalingAdjustment() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleUpScalingAdjustment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SecurityGroupArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SecurityGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SecurityGroupNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) ServiceLinkedRoleArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceLinkedRoleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SubnetIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"subnetIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SuspendedProcesses() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"suspendedProcesses",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) TargetGroupArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"targetGroupArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) TerminationPolicies() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"terminationPolicies",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) UseCustomImageId() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"useCustomImageId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) UseExistingAwsIamInstanceProfile() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"useExistingAwsIamInstanceProfile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) UseExistingSecurityGroup() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"useExistingSecurityGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) VpcId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WaitForCapacityTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"waitForCapacityTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WaitForElbCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"waitForElbCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WorkersRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"workersRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WorkersRoleNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"workersRoleNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WorkersRolePolicyArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"workersRolePolicyArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WorkersRolePolicyArnsCount() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"workersRolePolicyArnsCount",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksWorkers) WorkersSecurityGroupId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"workersSecurityGroupId",
		&returns,
	)
	return returns
}

func NewTerraformAwsEksWorkers(scope constructs.Construct, id *string, config *TerraformAwsEksWorkersConfig) TerraformAwsEksWorkers {
	_init_.Initialize()

	if err := validateNewTerraformAwsEksWorkersParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsEksWorkers{}

	_jsii_.Create(
		"terraform_aws_eks_workers.TerraformAwsEksWorkers",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsEksWorkers_Override(t TerraformAwsEksWorkers, scope constructs.Construct, id *string, config *TerraformAwsEksWorkersConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_eks_workers.TerraformAwsEksWorkers",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAdditionalSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"additionalSecurityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAfterClusterJoiningUserdata(val *string) {
	_jsii_.Set(
		j,
		"afterClusterJoiningUserdata",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAllowedCidrBlocks(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedCidrBlocks",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAllowedSecurityGroups(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedSecurityGroups",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAssociatePublicIpAddress(val *bool) {
	_jsii_.Set(
		j,
		"associatePublicIpAddress",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAutoscalingGroupTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"autoscalingGroupTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAutoscalingPoliciesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"autoscalingPoliciesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetAwsIamInstanceProfileName(val *string) {
	_jsii_.Set(
		j,
		"awsIamInstanceProfileName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetBeforeClusterJoiningUserdata(val *string) {
	_jsii_.Set(
		j,
		"beforeClusterJoiningUserdata",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetBlockDeviceMappings(val interface{}) {
	if err := j.validateSetBlockDeviceMappingsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"blockDeviceMappings",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetBootstrapExtraArgs(val *string) {
	_jsii_.Set(
		j,
		"bootstrapExtraArgs",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetClusterCertificateAuthorityData(val *string) {
	if err := j.validateSetClusterCertificateAuthorityDataParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterCertificateAuthorityData",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetClusterEndpoint(val *string) {
	if err := j.validateSetClusterEndpointParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterEndpoint",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetClusterName(val *string) {
	if err := j.validateSetClusterNameParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetClusterSecurityGroupId(val *string) {
	if err := j.validateSetClusterSecurityGroupIdParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterSecurityGroupId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetClusterSecurityGroupIngressEnabled(val *bool) {
	_jsii_.Set(
		j,
		"clusterSecurityGroupIngressEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationHighEvaluationPeriods(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighEvaluationPeriods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationHighPeriodSeconds(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighPeriodSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationHighStatistic(val *string) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighStatistic",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationHighThresholdPercent(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighThresholdPercent",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationLowEvaluationPeriods(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowEvaluationPeriods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationLowPeriodSeconds(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowPeriodSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationLowStatistic(val *string) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowStatistic",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCpuUtilizationLowThresholdPercent(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowThresholdPercent",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetCreditSpecification(val interface{}) {
	if err := j.validateSetCreditSpecificationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"creditSpecification",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetDefaultCooldown(val *float64) {
	_jsii_.Set(
		j,
		"defaultCooldown",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetDisableApiTermination(val *bool) {
	_jsii_.Set(
		j,
		"disableApiTermination",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEbsOptimized(val *bool) {
	_jsii_.Set(
		j,
		"ebsOptimized",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEksWorkerAmiNameFilter(val *string) {
	_jsii_.Set(
		j,
		"eksWorkerAmiNameFilter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEksWorkerAmiNameRegex(val *string) {
	_jsii_.Set(
		j,
		"eksWorkerAmiNameRegex",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetElasticGpuSpecifications(val interface{}) {
	if err := j.validateSetElasticGpuSpecificationsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"elasticGpuSpecifications",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEnabledMetrics(val *[]*string) {
	_jsii_.Set(
		j,
		"enabledMetrics",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEnableMonitoring(val *bool) {
	_jsii_.Set(
		j,
		"enableMonitoring",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetForceDelete(val *bool) {
	_jsii_.Set(
		j,
		"forceDelete",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetHealthCheckGracePeriod(val *float64) {
	_jsii_.Set(
		j,
		"healthCheckGracePeriod",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetHealthCheckType(val *string) {
	_jsii_.Set(
		j,
		"healthCheckType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetImageId(val *string) {
	_jsii_.Set(
		j,
		"imageId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetInstanceInitiatedShutdownBehavior(val *string) {
	_jsii_.Set(
		j,
		"instanceInitiatedShutdownBehavior",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetInstanceMarketOptions(val interface{}) {
	if err := j.validateSetInstanceMarketOptionsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceMarketOptions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetInstanceType(val *string) {
	if err := j.validateSetInstanceTypeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetKeyName(val *string) {
	_jsii_.Set(
		j,
		"keyName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetKubeletExtraArgs(val *string) {
	_jsii_.Set(
		j,
		"kubeletExtraArgs",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetLoadBalancers(val *[]*string) {
	_jsii_.Set(
		j,
		"loadBalancers",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMaxSize(val *float64) {
	if err := j.validateSetMaxSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"maxSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMetadataHttpEndpointEnabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpEndpointEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMetadataHttpPutResponseHopLimit(val *float64) {
	_jsii_.Set(
		j,
		"metadataHttpPutResponseHopLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMetadataHttpTokensRequired(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpTokensRequired",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMetricsGranularity(val *string) {
	_jsii_.Set(
		j,
		"metricsGranularity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMinElbCapacity(val *float64) {
	_jsii_.Set(
		j,
		"minElbCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMinSize(val *float64) {
	if err := j.validateSetMinSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"minSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetMixedInstancesPolicy(val interface{}) {
	if err := j.validateSetMixedInstancesPolicyParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"mixedInstancesPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetPlacement(val interface{}) {
	if err := j.validateSetPlacementParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"placement",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetPlacementGroup(val *string) {
	_jsii_.Set(
		j,
		"placementGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetProtectFromScaleIn(val *bool) {
	_jsii_.Set(
		j,
		"protectFromScaleIn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleDownAdjustmentType(val *string) {
	_jsii_.Set(
		j,
		"scaleDownAdjustmentType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleDownCooldownSeconds(val *float64) {
	_jsii_.Set(
		j,
		"scaleDownCooldownSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleDownPolicyType(val *string) {
	_jsii_.Set(
		j,
		"scaleDownPolicyType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleDownScalingAdjustment(val *float64) {
	_jsii_.Set(
		j,
		"scaleDownScalingAdjustment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleUpAdjustmentType(val *string) {
	_jsii_.Set(
		j,
		"scaleUpAdjustmentType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleUpCooldownSeconds(val *float64) {
	_jsii_.Set(
		j,
		"scaleUpCooldownSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleUpPolicyType(val *string) {
	_jsii_.Set(
		j,
		"scaleUpPolicyType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetScaleUpScalingAdjustment(val *float64) {
	_jsii_.Set(
		j,
		"scaleUpScalingAdjustment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetServiceLinkedRoleArn(val *string) {
	_jsii_.Set(
		j,
		"serviceLinkedRoleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetSubnetIds(val *[]*string) {
	if err := j.validateSetSubnetIdsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"subnetIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetSuspendedProcesses(val *[]*string) {
	_jsii_.Set(
		j,
		"suspendedProcesses",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetTargetGroupArns(val *[]*string) {
	_jsii_.Set(
		j,
		"targetGroupArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetTerminationPolicies(val *[]*string) {
	_jsii_.Set(
		j,
		"terminationPolicies",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetUseCustomImageId(val *bool) {
	_jsii_.Set(
		j,
		"useCustomImageId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetUseExistingAwsIamInstanceProfile(val *bool) {
	_jsii_.Set(
		j,
		"useExistingAwsIamInstanceProfile",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetUseExistingSecurityGroup(val *bool) {
	_jsii_.Set(
		j,
		"useExistingSecurityGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetVpcId(val *string) {
	if err := j.validateSetVpcIdParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"vpcId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetWaitForCapacityTimeout(val *string) {
	_jsii_.Set(
		j,
		"waitForCapacityTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetWaitForElbCapacity(val *float64) {
	_jsii_.Set(
		j,
		"waitForElbCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetWorkersRolePolicyArns(val *[]*string) {
	_jsii_.Set(
		j,
		"workersRolePolicyArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetWorkersRolePolicyArnsCount(val *float64) {
	_jsii_.Set(
		j,
		"workersRolePolicyArnsCount",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksWorkers) SetWorkersSecurityGroupId(val *string) {
	_jsii_.Set(
		j,
		"workersSecurityGroupId",
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
func TerraformAwsEksWorkers_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksWorkers_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_workers.TerraformAwsEksWorkers",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsEksWorkers_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksWorkers_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_workers.TerraformAwsEksWorkers",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsEksWorkers) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsEksWorkers) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsEksWorkers) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsEksWorkers) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsEksWorkers) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsEksWorkers) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksWorkers) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}
