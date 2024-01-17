package terraform_aws_ec2_autoscale_group

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_aws_ec2_autoscale_group/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_aws_ec2_autoscale_group/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsEc2AutoscaleGroup based on a Terraform module.
//
// Source at ./tf/mod/terraform-aws-ec2-autoscale-group
type TerraformAwsEc2AutoscaleGroup interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
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
	AutoscalingGroupTagsOutput() *string
	AutoscalingPoliciesEnabled() *bool
	SetAutoscalingPoliciesEnabled(val *bool)
	AutoscalingPolicyScaleDownArnOutput() *string
	AutoscalingPolicyScaleUpArnOutput() *string
	BlockDeviceMappings() interface{}
	SetBlockDeviceMappings(val interface{})
	CapacityRebalance() *bool
	SetCapacityRebalance(val *bool)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
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
	CustomAlarms() interface{}
	SetCustomAlarms(val interface{})
	DefaultAlarmsEnabled() *bool
	SetDefaultAlarmsEnabled(val *bool)
	DefaultCooldown() *float64
	SetDefaultCooldown(val *float64)
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DesiredCapacity() *float64
	SetDesiredCapacity(val *float64)
	DisableApiTermination() *bool
	SetDisableApiTermination(val *bool)
	EbsOptimized() *bool
	SetEbsOptimized(val *bool)
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
	IamInstanceProfileName() *string
	SetIamInstanceProfileName(val *string)
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	ImageId() *string
	SetImageId(val *string)
	InstanceInitiatedShutdownBehavior() *string
	SetInstanceInitiatedShutdownBehavior(val *string)
	InstanceMarketOptions() interface{}
	SetInstanceMarketOptions(val interface{})
	InstanceRefresh() interface{}
	SetInstanceRefresh(val interface{})
	InstanceReusePolicy() interface{}
	SetInstanceReusePolicy(val interface{})
	InstanceType() *string
	SetInstanceType(val *string)
	KeyName() *string
	SetKeyName(val *string)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LaunchTemplateArnOutput() *string
	LaunchTemplateIdOutput() *string
	LaunchTemplateVersion() *string
	SetLaunchTemplateVersion(val *string)
	LoadBalancers() *[]*string
	SetLoadBalancers(val *[]*string)
	MaxInstanceLifetime() *float64
	SetMaxInstanceLifetime(val *float64)
	MaxSize() *float64
	SetMaxSize(val *float64)
	MetadataHttpEndpointEnabled() *bool
	SetMetadataHttpEndpointEnabled(val *bool)
	MetadataHttpProtocolIpv6Enabled() *bool
	SetMetadataHttpProtocolIpv6Enabled(val *bool)
	MetadataHttpPutResponseHopLimit() *float64
	SetMetadataHttpPutResponseHopLimit(val *float64)
	MetadataHttpTokensRequired() *bool
	SetMetadataHttpTokensRequired(val *bool)
	MetadataInstanceMetadataTagsEnabled() *bool
	SetMetadataInstanceMetadataTagsEnabled(val *bool)
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
	SecurityGroupIds() *[]*string
	SetSecurityGroupIds(val *[]*string)
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
	TagSpecificationsResourceTypes() *[]*string
	SetTagSpecificationsResourceTypes(val *[]*string)
	TargetGroupArns() *[]*string
	SetTargetGroupArns(val *[]*string)
	Tenant() *string
	SetTenant(val *string)
	TerminationPolicies() *[]*string
	SetTerminationPolicies(val *[]*string)
	UpdateDefaultVersion() *bool
	SetUpdateDefaultVersion(val *bool)
	UserDataBase64() *string
	SetUserDataBase64(val *string)
	// Experimental.
	Version() *string
	WaitForCapacityTimeout() *string
	SetWaitForCapacityTimeout(val *string)
	WaitForElbCapacity() *float64
	SetWaitForElbCapacity(val *float64)
	WarmPool() interface{}
	SetWarmPool(val interface{})
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

// The jsii proxy struct for TerraformAwsEc2AutoscaleGroup
type jsiiProxy_TerraformAwsEc2AutoscaleGroup struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AssociatePublicIpAddress() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"associatePublicIpAddress",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupDefaultCooldownOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupDefaultCooldownOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupDesiredCapacityOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupDesiredCapacityOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupHealthCheckGracePeriodOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupHealthCheckGracePeriodOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupHealthCheckTypeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupHealthCheckTypeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupMaxSizeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupMaxSizeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupMinSizeOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupMinSizeOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingGroupTagsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingGroupTagsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingPoliciesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"autoscalingPoliciesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingPolicyScaleDownArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingPolicyScaleDownArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AutoscalingPolicyScaleUpArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"autoscalingPolicyScaleUpArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) BlockDeviceMappings() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"blockDeviceMappings",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CapacityRebalance() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"capacityRebalance",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationHighEvaluationPeriods() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighEvaluationPeriods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationHighPeriodSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighPeriodSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationHighStatistic() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cpuUtilizationHighStatistic",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationHighThresholdPercent() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationHighThresholdPercent",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationLowEvaluationPeriods() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowEvaluationPeriods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationLowPeriodSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowPeriodSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationLowStatistic() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cpuUtilizationLowStatistic",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CpuUtilizationLowThresholdPercent() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"cpuUtilizationLowThresholdPercent",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CreditSpecification() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"creditSpecification",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) CustomAlarms() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"customAlarms",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DefaultAlarmsEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"defaultAlarmsEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DefaultCooldown() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"defaultCooldown",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DesiredCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"desiredCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) DisableApiTermination() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"disableApiTermination",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) EbsOptimized() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ebsOptimized",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ElasticGpuSpecifications() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"elasticGpuSpecifications",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) EnabledMetrics() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"enabledMetrics",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) EnableMonitoring() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enableMonitoring",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ForceDelete() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"forceDelete",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) HealthCheckGracePeriod() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"healthCheckGracePeriod",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) HealthCheckType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"healthCheckType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) IamInstanceProfileName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"iamInstanceProfileName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ImageId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"imageId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InstanceInitiatedShutdownBehavior() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceInitiatedShutdownBehavior",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InstanceMarketOptions() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"instanceMarketOptions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InstanceRefresh() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"instanceRefresh",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InstanceReusePolicy() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"instanceReusePolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InstanceType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"instanceType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) KeyName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"keyName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LaunchTemplateArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"launchTemplateArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LaunchTemplateIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"launchTemplateIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LaunchTemplateVersion() *string {
	var returns *string
	_jsii_.Get(
		j,
		"launchTemplateVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) LoadBalancers() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"loadBalancers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MaxInstanceLifetime() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxInstanceLifetime",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MaxSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetadataHttpEndpointEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpEndpointEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetadataHttpProtocolIpv6Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpProtocolIpv6Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetadataHttpPutResponseHopLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"metadataHttpPutResponseHopLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetadataHttpTokensRequired() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataHttpTokensRequired",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetadataInstanceMetadataTagsEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"metadataInstanceMetadataTagsEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MetricsGranularity() *string {
	var returns *string
	_jsii_.Get(
		j,
		"metricsGranularity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MinElbCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minElbCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MinSize() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minSize",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) MixedInstancesPolicy() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"mixedInstancesPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Placement() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"placement",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) PlacementGroup() *string {
	var returns *string
	_jsii_.Get(
		j,
		"placementGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ProtectFromScaleIn() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"protectFromScaleIn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleDownAdjustmentType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleDownAdjustmentType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleDownCooldownSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleDownCooldownSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleDownPolicyType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleDownPolicyType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleDownScalingAdjustment() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleDownScalingAdjustment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleUpAdjustmentType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleUpAdjustmentType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleUpCooldownSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleUpCooldownSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleUpPolicyType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"scaleUpPolicyType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ScaleUpScalingAdjustment() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"scaleUpScalingAdjustment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"securityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ServiceLinkedRoleArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceLinkedRoleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SubnetIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"subnetIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SuspendedProcesses() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"suspendedProcesses",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) TagSpecificationsResourceTypes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"tagSpecificationsResourceTypes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) TargetGroupArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"targetGroupArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) TerminationPolicies() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"terminationPolicies",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) UpdateDefaultVersion() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"updateDefaultVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) UserDataBase64() *string {
	var returns *string
	_jsii_.Get(
		j,
		"userDataBase64",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) WaitForCapacityTimeout() *string {
	var returns *string
	_jsii_.Get(
		j,
		"waitForCapacityTimeout",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) WaitForElbCapacity() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"waitForElbCapacity",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup) WarmPool() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"warmPool",
		&returns,
	)
	return returns
}


func NewTerraformAwsEc2AutoscaleGroup(scope constructs.Construct, id *string, config *TerraformAwsEc2AutoscaleGroupConfig) TerraformAwsEc2AutoscaleGroup {
	_init_.Initialize()

	if err := validateNewTerraformAwsEc2AutoscaleGroupParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsEc2AutoscaleGroup{}

	_jsii_.Create(
		"terraform_aws_ec2_autoscale_group.TerraformAwsEc2AutoscaleGroup",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsEc2AutoscaleGroup_Override(t TerraformAwsEc2AutoscaleGroup, scope constructs.Construct, id *string, config *TerraformAwsEc2AutoscaleGroupConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_ec2_autoscale_group.TerraformAwsEc2AutoscaleGroup",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetAssociatePublicIpAddress(val *bool) {
	_jsii_.Set(
		j,
		"associatePublicIpAddress",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetAutoscalingPoliciesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"autoscalingPoliciesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetBlockDeviceMappings(val interface{}) {
	if err := j.validateSetBlockDeviceMappingsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"blockDeviceMappings",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCapacityRebalance(val *bool) {
	_jsii_.Set(
		j,
		"capacityRebalance",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationHighEvaluationPeriods(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighEvaluationPeriods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationHighPeriodSeconds(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighPeriodSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationHighStatistic(val *string) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighStatistic",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationHighThresholdPercent(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationHighThresholdPercent",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationLowEvaluationPeriods(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowEvaluationPeriods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationLowPeriodSeconds(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowPeriodSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationLowStatistic(val *string) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowStatistic",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCpuUtilizationLowThresholdPercent(val *float64) {
	_jsii_.Set(
		j,
		"cpuUtilizationLowThresholdPercent",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCreditSpecification(val interface{}) {
	if err := j.validateSetCreditSpecificationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"creditSpecification",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetCustomAlarms(val interface{}) {
	if err := j.validateSetCustomAlarmsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"customAlarms",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDefaultAlarmsEnabled(val *bool) {
	_jsii_.Set(
		j,
		"defaultAlarmsEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDefaultCooldown(val *float64) {
	_jsii_.Set(
		j,
		"defaultCooldown",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDesiredCapacity(val *float64) {
	_jsii_.Set(
		j,
		"desiredCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetDisableApiTermination(val *bool) {
	_jsii_.Set(
		j,
		"disableApiTermination",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetEbsOptimized(val *bool) {
	_jsii_.Set(
		j,
		"ebsOptimized",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetElasticGpuSpecifications(val interface{}) {
	if err := j.validateSetElasticGpuSpecificationsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"elasticGpuSpecifications",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetEnabledMetrics(val *[]*string) {
	_jsii_.Set(
		j,
		"enabledMetrics",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetEnableMonitoring(val *bool) {
	_jsii_.Set(
		j,
		"enableMonitoring",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetForceDelete(val *bool) {
	_jsii_.Set(
		j,
		"forceDelete",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetHealthCheckGracePeriod(val *float64) {
	_jsii_.Set(
		j,
		"healthCheckGracePeriod",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetHealthCheckType(val *string) {
	_jsii_.Set(
		j,
		"healthCheckType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetIamInstanceProfileName(val *string) {
	_jsii_.Set(
		j,
		"iamInstanceProfileName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetImageId(val *string) {
	_jsii_.Set(
		j,
		"imageId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetInstanceInitiatedShutdownBehavior(val *string) {
	_jsii_.Set(
		j,
		"instanceInitiatedShutdownBehavior",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetInstanceMarketOptions(val interface{}) {
	if err := j.validateSetInstanceMarketOptionsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceMarketOptions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetInstanceRefresh(val interface{}) {
	if err := j.validateSetInstanceRefreshParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceRefresh",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetInstanceReusePolicy(val interface{}) {
	if err := j.validateSetInstanceReusePolicyParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceReusePolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetInstanceType(val *string) {
	if err := j.validateSetInstanceTypeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"instanceType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetKeyName(val *string) {
	_jsii_.Set(
		j,
		"keyName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLaunchTemplateVersion(val *string) {
	_jsii_.Set(
		j,
		"launchTemplateVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetLoadBalancers(val *[]*string) {
	_jsii_.Set(
		j,
		"loadBalancers",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMaxInstanceLifetime(val *float64) {
	_jsii_.Set(
		j,
		"maxInstanceLifetime",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMaxSize(val *float64) {
	if err := j.validateSetMaxSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"maxSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetadataHttpEndpointEnabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpEndpointEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetadataHttpProtocolIpv6Enabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpProtocolIpv6Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetadataHttpPutResponseHopLimit(val *float64) {
	_jsii_.Set(
		j,
		"metadataHttpPutResponseHopLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetadataHttpTokensRequired(val *bool) {
	_jsii_.Set(
		j,
		"metadataHttpTokensRequired",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetadataInstanceMetadataTagsEnabled(val *bool) {
	_jsii_.Set(
		j,
		"metadataInstanceMetadataTagsEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMetricsGranularity(val *string) {
	_jsii_.Set(
		j,
		"metricsGranularity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMinElbCapacity(val *float64) {
	_jsii_.Set(
		j,
		"minElbCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMinSize(val *float64) {
	if err := j.validateSetMinSizeParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"minSize",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetMixedInstancesPolicy(val interface{}) {
	if err := j.validateSetMixedInstancesPolicyParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"mixedInstancesPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetPlacement(val interface{}) {
	if err := j.validateSetPlacementParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"placement",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetPlacementGroup(val *string) {
	_jsii_.Set(
		j,
		"placementGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetProtectFromScaleIn(val *bool) {
	_jsii_.Set(
		j,
		"protectFromScaleIn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleDownAdjustmentType(val *string) {
	_jsii_.Set(
		j,
		"scaleDownAdjustmentType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleDownCooldownSeconds(val *float64) {
	_jsii_.Set(
		j,
		"scaleDownCooldownSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleDownPolicyType(val *string) {
	_jsii_.Set(
		j,
		"scaleDownPolicyType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleDownScalingAdjustment(val *float64) {
	_jsii_.Set(
		j,
		"scaleDownScalingAdjustment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleUpAdjustmentType(val *string) {
	_jsii_.Set(
		j,
		"scaleUpAdjustmentType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleUpCooldownSeconds(val *float64) {
	_jsii_.Set(
		j,
		"scaleUpCooldownSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleUpPolicyType(val *string) {
	_jsii_.Set(
		j,
		"scaleUpPolicyType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetScaleUpScalingAdjustment(val *float64) {
	_jsii_.Set(
		j,
		"scaleUpScalingAdjustment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"securityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetServiceLinkedRoleArn(val *string) {
	_jsii_.Set(
		j,
		"serviceLinkedRoleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetSubnetIds(val *[]*string) {
	if err := j.validateSetSubnetIdsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"subnetIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetSuspendedProcesses(val *[]*string) {
	_jsii_.Set(
		j,
		"suspendedProcesses",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetTagSpecificationsResourceTypes(val *[]*string) {
	_jsii_.Set(
		j,
		"tagSpecificationsResourceTypes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetTargetGroupArns(val *[]*string) {
	_jsii_.Set(
		j,
		"targetGroupArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetTerminationPolicies(val *[]*string) {
	_jsii_.Set(
		j,
		"terminationPolicies",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetUpdateDefaultVersion(val *bool) {
	_jsii_.Set(
		j,
		"updateDefaultVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetUserDataBase64(val *string) {
	_jsii_.Set(
		j,
		"userDataBase64",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetWaitForCapacityTimeout(val *string) {
	_jsii_.Set(
		j,
		"waitForCapacityTimeout",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetWaitForElbCapacity(val *float64) {
	_jsii_.Set(
		j,
		"waitForElbCapacity",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEc2AutoscaleGroup)SetWarmPool(val interface{}) {
	if err := j.validateSetWarmPoolParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"warmPool",
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
func TerraformAwsEc2AutoscaleGroup_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEc2AutoscaleGroup_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_ec2_autoscale_group.TerraformAwsEc2AutoscaleGroup",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsEc2AutoscaleGroup_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEc2AutoscaleGroup_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_ec2_autoscale_group.TerraformAwsEc2AutoscaleGroup",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEc2AutoscaleGroup) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

