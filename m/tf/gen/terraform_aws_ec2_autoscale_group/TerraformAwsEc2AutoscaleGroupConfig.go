package terraform_aws_ec2_autoscale_group

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEc2AutoscaleGroupConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// Instance type to launch.
	InstanceType *string `field:"required" json:"instanceType" yaml:"instanceType"`
	// The maximum size of the autoscale group.
	MaxSize *float64 `field:"required" json:"maxSize" yaml:"maxSize"`
	// The minimum size of the autoscale group.
	MinSize *float64 `field:"required" json:"minSize" yaml:"minSize"`
	// A list of subnet IDs to launch resources in.
	SubnetIds *[]*string `field:"required" json:"subnetIds" yaml:"subnetIds"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// Associate a public IP address with an instance in a VPC.
	AssociatePublicIpAddress *bool `field:"optional" json:"associatePublicIpAddress" yaml:"associatePublicIpAddress"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling true.
	AutoscalingPoliciesEnabled *bool `field:"optional" json:"autoscalingPoliciesEnabled" yaml:"autoscalingPoliciesEnabled"`
	// Specify volumes to attach to the instance besides the volumes specified by the AMI.
	BlockDeviceMappings interface{} `field:"optional" json:"blockDeviceMappings" yaml:"blockDeviceMappings"`
	// Indicates whether capacity rebalance is enabled.
	//
	// Otherwise, capacity rebalance is disabled.
	CapacityRebalance *bool `field:"optional" json:"capacityRebalance" yaml:"capacityRebalance"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// The number of periods over which data is compared to the specified threshold 2.
	CpuUtilizationHighEvaluationPeriods *float64 `field:"optional" json:"cpuUtilizationHighEvaluationPeriods" yaml:"cpuUtilizationHighEvaluationPeriods"`
	// The period in seconds over which the specified statistic is applied 300.
	CpuUtilizationHighPeriodSeconds *float64 `field:"optional" json:"cpuUtilizationHighPeriodSeconds" yaml:"cpuUtilizationHighPeriodSeconds"`
	// The statistic to apply to the alarm's associated metric.
	//
	// Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum`
	// Average.
	CpuUtilizationHighStatistic *string `field:"optional" json:"cpuUtilizationHighStatistic" yaml:"cpuUtilizationHighStatistic"`
	// The value against which the specified statistic is compared 90.
	CpuUtilizationHighThresholdPercent *float64 `field:"optional" json:"cpuUtilizationHighThresholdPercent" yaml:"cpuUtilizationHighThresholdPercent"`
	// The number of periods over which data is compared to the specified threshold 2.
	CpuUtilizationLowEvaluationPeriods *float64 `field:"optional" json:"cpuUtilizationLowEvaluationPeriods" yaml:"cpuUtilizationLowEvaluationPeriods"`
	// The period in seconds over which the specified statistic is applied 300.
	CpuUtilizationLowPeriodSeconds *float64 `field:"optional" json:"cpuUtilizationLowPeriodSeconds" yaml:"cpuUtilizationLowPeriodSeconds"`
	// The statistic to apply to the alarm's associated metric.
	//
	// Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum`
	// Average.
	CpuUtilizationLowStatistic *string `field:"optional" json:"cpuUtilizationLowStatistic" yaml:"cpuUtilizationLowStatistic"`
	// The value against which the specified statistic is compared 10.
	CpuUtilizationLowThresholdPercent *float64 `field:"optional" json:"cpuUtilizationLowThresholdPercent" yaml:"cpuUtilizationLowThresholdPercent"`
	// Customize the credit specification of the instances.
	CreditSpecification interface{} `field:"optional" json:"creditSpecification" yaml:"creditSpecification"`
	// Map of custom CloudWatch alarms configurations.
	CustomAlarms interface{} `field:"optional" json:"customAlarms" yaml:"customAlarms"`
	// Enable or disable cpu and memory Cloudwatch alarms true.
	DefaultAlarmsEnabled *bool `field:"optional" json:"defaultAlarmsEnabled" yaml:"defaultAlarmsEnabled"`
	// The amount of time, in seconds, after a scaling activity completes before another scaling activity can start 300.
	DefaultCooldown *float64 `field:"optional" json:"defaultCooldown" yaml:"defaultCooldown"`
	// Delimiter to be used between ID elements.
	//
	// Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
	Delimiter *string `field:"optional" json:"delimiter" yaml:"delimiter"`
	// Describe additional descriptors to be output in the `descriptors` output map.
	//
	// Map of maps. Keys are names of descriptors. Values are maps of the form
	// `{
	//    format = string
	//    labels = list(string)
	// }`
	// (Type is `any` so the map values can later be enhanced to provide additional options.)
	// `format` is a Terraform format string to be passed to the `format()` function.
	// `labels` is a list of labels, in order, to pass to `format()` function.
	// Label values will be normalized before being passed to `format()` so they will be
	// identical to how they appear in `id`.
	// Default is `{}` (`descriptors` output will be empty).
	DescriptorFormats interface{} `field:"optional" json:"descriptorFormats" yaml:"descriptorFormats"`
	// The number of Amazon EC2 instances that should be running in the group, if not set will use `min_size` as value.
	DesiredCapacity *float64 `field:"optional" json:"desiredCapacity" yaml:"desiredCapacity"`
	// If `true`, enables EC2 Instance Termination Protection.
	DisableApiTermination *bool `field:"optional" json:"disableApiTermination" yaml:"disableApiTermination"`
	// If true, the launched EC2 instance will be EBS-optimized.
	EbsOptimized *bool `field:"optional" json:"ebsOptimized" yaml:"ebsOptimized"`
	// Specifications of Elastic GPU to attach to the instances.
	ElasticGpuSpecifications interface{} `field:"optional" json:"elasticGpuSpecifications" yaml:"elasticGpuSpecifications"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// A list of metrics to collect.
	//
	// The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`
	// GroupMinSize
	// GroupMaxSize
	// GroupDesiredCapacity
	// GroupInServiceInstances
	// GroupPendingInstances
	// GroupStandbyInstances
	// GroupTerminatingInstances
	// GroupTotalInstances.
	EnabledMetrics *[]*string `field:"optional" json:"enabledMetrics" yaml:"enabledMetrics"`
	// Enable/disable detailed monitoring true.
	EnableMonitoring *bool `field:"optional" json:"enableMonitoring" yaml:"enableMonitoring"`
	// ID element.
	//
	// Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'
	Environment *string `field:"optional" json:"environment" yaml:"environment"`
	// Allows deleting the autoscaling group without waiting for all instances in the pool to terminate.
	//
	// You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling
	ForceDelete *bool `field:"optional" json:"forceDelete" yaml:"forceDelete"`
	// Time (in seconds) after instance comes into service before checking health 300.
	HealthCheckGracePeriod *float64 `field:"optional" json:"healthCheckGracePeriod" yaml:"healthCheckGracePeriod"`
	// Controls how health checking is done.
	//
	// Valid values are `EC2` or `ELB`
	// EC2.
	HealthCheckType *string `field:"optional" json:"healthCheckType" yaml:"healthCheckType"`
	// The IAM instance profile name to associate with launched instances.
	IamInstanceProfileName *string `field:"optional" json:"iamInstanceProfileName" yaml:"iamInstanceProfileName"`
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for keep the existing setting, which defaults to `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// The EC2 image ID to launch.
	ImageId *string `field:"optional" json:"imageId" yaml:"imageId"`
	// Shutdown behavior for the instances.
	//
	// Can be `stop` or `terminate`
	// terminate.
	InstanceInitiatedShutdownBehavior *string `field:"optional" json:"instanceInitiatedShutdownBehavior" yaml:"instanceInitiatedShutdownBehavior"`
	// The market (purchasing) option for the instances.
	InstanceMarketOptions interface{} `field:"optional" json:"instanceMarketOptions" yaml:"instanceMarketOptions"`
	// The instance refresh definition.
	InstanceRefresh interface{} `field:"optional" json:"instanceRefresh" yaml:"instanceRefresh"`
	// If warm pool and this block are configured, instances in the Auto Scaling group can be returned to the warm pool on scale in.
	//
	// The default is to terminate instances in the Auto Scaling group when the group scales in.
	InstanceReusePolicy interface{} `field:"optional" json:"instanceReusePolicy" yaml:"instanceReusePolicy"`
	// The SSH key name that should be used for the instance.
	KeyName *string `field:"optional" json:"keyName" yaml:"keyName"`
	// Controls the letter case of the `tags` keys (label names) for tags generated by this module.
	//
	// Does not affect keys of tags passed in via the `tags` input.
	// Possible values: `lower`, `title`, `upper`.
	// Default value: `title`.
	LabelKeyCase *string `field:"optional" json:"labelKeyCase" yaml:"labelKeyCase"`
	// The order in which the labels (ID elements) appear in the `id`.
	//
	// Defaults to ["namespace", "environment", "stage", "name", "attributes"].
	// You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
	LabelOrder *[]*string `field:"optional" json:"labelOrder" yaml:"labelOrder"`
	// Set of labels (ID elements) to include as tags in the `tags` output.
	//
	// Default is to include all labels.
	// Tags with empty values will not be included in the `tags` output.
	// Set to `[]` to suppress all generated tags.
	// **Notes:**
	//   The value of the `name` tag, if included, will be the `id`, not the `name`.
	//   Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be
	//   changed in later chained modules. Attempts to change it will be silently ignored.
	//
	// default.
	LabelsAsTags *[]*string `field:"optional" json:"labelsAsTags" yaml:"labelsAsTags"`
	// Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually.
	//
	// Does not affect values of tags passed in via the `tags` input.
	// Possible values: `lower`, `title`, `upper` and `none` (no transformation).
	// Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.
	// Default value: `lower`.
	LabelValueCase *string `field:"optional" json:"labelValueCase" yaml:"labelValueCase"`
	// Launch template version.
	//
	// Can be version number, `$Latest` or `$Default`
	// $Latest.
	LaunchTemplateVersion *string `field:"optional" json:"launchTemplateVersion" yaml:"launchTemplateVersion"`
	// A list of elastic load balancer names to add to the autoscaling group names.
	//
	// Only valid for classic load balancers. For ALBs, use `target_group_arns` instead
	LoadBalancers *[]*string `field:"optional" json:"loadBalancers" yaml:"loadBalancers"`
	// The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds.
	MaxInstanceLifetime *float64 `field:"optional" json:"maxInstanceLifetime" yaml:"maxInstanceLifetime"`
	// Set false to disable the Instance Metadata Service.
	//
	// true.
	MetadataHttpEndpointEnabled *bool `field:"optional" json:"metadataHttpEndpointEnabled" yaml:"metadataHttpEndpointEnabled"`
	// Set true to enable IPv6 in the launch template.
	MetadataHttpProtocolIpv6Enabled *bool `field:"optional" json:"metadataHttpProtocolIpv6Enabled" yaml:"metadataHttpProtocolIpv6Enabled"`
	// The desired HTTP PUT response hop limit (between 1 and 64) for Instance Metadata Service requests.
	//
	// The default is `2` to support containerized workloads.
	//
	// 2.
	MetadataHttpPutResponseHopLimit *float64 `field:"optional" json:"metadataHttpPutResponseHopLimit" yaml:"metadataHttpPutResponseHopLimit"`
	// Set true to require IMDS session tokens, disabling Instance Metadata Service Version 1.
	//
	// true.
	MetadataHttpTokensRequired *bool `field:"optional" json:"metadataHttpTokensRequired" yaml:"metadataHttpTokensRequired"`
	// Set true to enable metadata tags in the launch template.
	MetadataInstanceMetadataTagsEnabled *bool `field:"optional" json:"metadataInstanceMetadataTagsEnabled" yaml:"metadataInstanceMetadataTagsEnabled"`
	// The granularity to associate with the metrics to collect.
	//
	// The only valid value is 1Minute
	// 1Minute.
	MetricsGranularity *string `field:"optional" json:"metricsGranularity" yaml:"metricsGranularity"`
	// Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation.
	//
	// Updates will not wait on ELB instance number changes.
	MinElbCapacity *float64 `field:"optional" json:"minElbCapacity" yaml:"minElbCapacity"`
	// policy to used mixed group of on demand/spot of differing types.
	//
	// Launch template is automatically generated. https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#mixed_instances_policy-1
	MixedInstancesPolicy interface{} `field:"optional" json:"mixedInstancesPolicy" yaml:"mixedInstancesPolicy"`
	// ID element.
	//
	// Usually the component or solution name, e.g. 'app' or 'jenkins'.
	// This is the only ID element not also included as a `tag`.
	// The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.
	Name *string `field:"optional" json:"name" yaml:"name"`
	// ID element.
	//
	// Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique
	Namespace *string `field:"optional" json:"namespace" yaml:"namespace"`
	// The placement specifications of the instances.
	Placement interface{} `field:"optional" json:"placement" yaml:"placement"`
	// The name of the placement group into which you'll launch your instances, if any.
	PlacementGroup *string `field:"optional" json:"placementGroup" yaml:"placementGroup"`
	// Allows setting instance protection.
	//
	// The autoscaling group will not select instances with this setting for terminination during scale in events.
	ProtectFromScaleIn *bool `field:"optional" json:"protectFromScaleIn" yaml:"protectFromScaleIn"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// Specifies whether the adjustment is an absolute number or a percentage of the current capacity.
	//
	// Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`
	// ChangeInCapacity.
	ScaleDownAdjustmentType *string `field:"optional" json:"scaleDownAdjustmentType" yaml:"scaleDownAdjustmentType"`
	// The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start 300.
	ScaleDownCooldownSeconds *float64 `field:"optional" json:"scaleDownCooldownSeconds" yaml:"scaleDownCooldownSeconds"`
	// The scaling policy type.
	//
	// Currently only `SimpleScaling` is supported
	// SimpleScaling.
	ScaleDownPolicyType *string `field:"optional" json:"scaleDownPolicyType" yaml:"scaleDownPolicyType"`
	// The number of instances by which to scale.
	//
	// `scale_down_scaling_adjustment` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity
	// -1.
	ScaleDownScalingAdjustment *float64 `field:"optional" json:"scaleDownScalingAdjustment" yaml:"scaleDownScalingAdjustment"`
	// Specifies whether the adjustment is an absolute number or a percentage of the current capacity.
	//
	// Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`
	// ChangeInCapacity.
	ScaleUpAdjustmentType *string `field:"optional" json:"scaleUpAdjustmentType" yaml:"scaleUpAdjustmentType"`
	// The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start 300.
	ScaleUpCooldownSeconds *float64 `field:"optional" json:"scaleUpCooldownSeconds" yaml:"scaleUpCooldownSeconds"`
	// The scaling policy type.
	//
	// Currently only `SimpleScaling` is supported
	// SimpleScaling.
	ScaleUpPolicyType *string `field:"optional" json:"scaleUpPolicyType" yaml:"scaleUpPolicyType"`
	// The number of instances by which to scale.
	//
	// `scale_up_adjustment_type` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity
	// 1.
	ScaleUpScalingAdjustment *float64 `field:"optional" json:"scaleUpScalingAdjustment" yaml:"scaleUpScalingAdjustment"`
	// A list of associated security group IDs.
	SecurityGroupIds *[]*string `field:"optional" json:"securityGroupIds" yaml:"securityGroupIds"`
	// The ARN of the service-linked role that the ASG will use to call other AWS services.
	ServiceLinkedRoleArn *string `field:"optional" json:"serviceLinkedRoleArn" yaml:"serviceLinkedRoleArn"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// A list of processes to suspend for the AutoScaling Group.
	//
	// The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your autoscaling group from functioning properly.
	SuspendedProcesses *[]*string `field:"optional" json:"suspendedProcesses" yaml:"suspendedProcesses"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// List of tag specification resource types to tag.
	//
	// Valid values are instance, volume, elastic-gpu and spot-instances-request.
	// instance
	// volume.
	TagSpecificationsResourceTypes *[]*string `field:"optional" json:"tagSpecificationsResourceTypes" yaml:"tagSpecificationsResourceTypes"`
	// A list of aws_alb_target_group ARNs, for use with Application Load Balancing.
	TargetGroupArns *[]*string `field:"optional" json:"targetGroupArns" yaml:"targetGroupArns"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
	// A list of policies to decide how the instances in the auto scale group should be terminated.
	//
	// The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default`
	// Default.
	TerminationPolicies *[]*string `field:"optional" json:"terminationPolicies" yaml:"terminationPolicies"`
	// Whether to update Default version of Launch template each update.
	UpdateDefaultVersion *bool `field:"optional" json:"updateDefaultVersion" yaml:"updateDefaultVersion"`
	// The Base64-encoded user data to provide when launching the instances.
	UserDataBase64 *string `field:"optional" json:"userDataBase64" yaml:"userDataBase64"`
	// A maximum duration that Terraform should wait for ASG instances to be healthy before timing out.
	//
	// Setting this to '0' causes Terraform to skip all Capacity Waiting behavior
	// 10m.
	WaitForCapacityTimeout *string `field:"optional" json:"waitForCapacityTimeout" yaml:"waitForCapacityTimeout"`
	// Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations.
	//
	// Takes precedence over `min_elb_capacity` behavior.
	WaitForElbCapacity *float64 `field:"optional" json:"waitForElbCapacity" yaml:"waitForElbCapacity"`
	// If this block is configured, add a Warm Pool to the specified Auto Scaling group.
	//
	// See [warm_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#warm_pool).
	WarmPool interface{} `field:"optional" json:"warmPool" yaml:"warmPool"`
}

