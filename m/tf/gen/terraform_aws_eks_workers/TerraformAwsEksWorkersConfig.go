package terraform_aws_eks_workers

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEksWorkersConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// The base64 encoded certificate data required to communicate with the cluster.
	ClusterCertificateAuthorityData *string `field:"required" json:"clusterCertificateAuthorityData" yaml:"clusterCertificateAuthorityData"`
	// EKS cluster endpoint.
	ClusterEndpoint *string `field:"required" json:"clusterEndpoint" yaml:"clusterEndpoint"`
	// The name of the EKS cluster.
	ClusterName *string `field:"required" json:"clusterName" yaml:"clusterName"`
	// Security Group ID of the EKS cluster.
	ClusterSecurityGroupId *string `field:"required" json:"clusterSecurityGroupId" yaml:"clusterSecurityGroupId"`
	// Instance type to launch.
	InstanceType *string `field:"required" json:"instanceType" yaml:"instanceType"`
	// The maximum size of the autoscale group.
	MaxSize *float64 `field:"required" json:"maxSize" yaml:"maxSize"`
	// The minimum size of the autoscale group.
	MinSize *float64 `field:"required" json:"minSize" yaml:"minSize"`
	// A list of subnet IDs to launch resources in.
	SubnetIds *[]*string `field:"required" json:"subnetIds" yaml:"subnetIds"`
	// VPC ID for the EKS cluster.
	VpcId *string `field:"required" json:"vpcId" yaml:"vpcId"`
	// Additional list of security groups that will be attached to the autoscaling group.
	AdditionalSecurityGroupIds *[]*string `field:"optional" json:"additionalSecurityGroupIds" yaml:"additionalSecurityGroupIds"`
	// Additional tags for appending to tags_as_list_of_maps.
	//
	// Not added to `tags`.
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// Additional commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script). For mot info, see https://kubedex.com/90-days-of-aws-eks-in-production.
	AfterClusterJoiningUserdata *string `field:"optional" json:"afterClusterJoiningUserdata" yaml:"afterClusterJoiningUserdata"`
	// List of CIDR blocks to be allowed to connect to the worker nodes.
	AllowedCidrBlocks *[]*string `field:"optional" json:"allowedCidrBlocks" yaml:"allowedCidrBlocks"`
	// List of Security Group IDs to be allowed to connect to the worker nodes.
	AllowedSecurityGroups *[]*string `field:"optional" json:"allowedSecurityGroups" yaml:"allowedSecurityGroups"`
	// Associate a public IP address with an instance in a VPC.
	AssociatePublicIpAddress *bool `field:"optional" json:"associatePublicIpAddress" yaml:"associatePublicIpAddress"`
	// Additional attributes (e.g. `1`).
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// Additional tags only for the autoscaling group, e.g. "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "ci-cd:NoSchedule". The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}.
	AutoscalingGroupTags *map[string]*string `field:"optional" json:"autoscalingGroupTags" yaml:"autoscalingGroupTags"`
	// Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling true.
	AutoscalingPoliciesEnabled *bool `field:"optional" json:"autoscalingPoliciesEnabled" yaml:"autoscalingPoliciesEnabled"`
	// The name of the existing instance profile that will be used in autoscaling group for EKS workers.
	//
	// If empty will create a new instance profile.
	AwsIamInstanceProfileName *string `field:"optional" json:"awsIamInstanceProfileName" yaml:"awsIamInstanceProfileName"`
	// Additional commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script). For mot info, see https://kubedex.com/90-days-of-aws-eks-in-production.
	BeforeClusterJoiningUserdata *string `field:"optional" json:"beforeClusterJoiningUserdata" yaml:"beforeClusterJoiningUserdata"`
	// Specify volumes to attach to the instance besides the volumes specified by the AMI.
	BlockDeviceMappings interface{} `field:"optional" json:"blockDeviceMappings" yaml:"blockDeviceMappings"`
	// Extra arguments to the `bootstrap.sh` script to enable `--enable-docker-bridge` or `--use-max-pods`.
	BootstrapExtraArgs *string `field:"optional" json:"bootstrapExtraArgs" yaml:"bootstrapExtraArgs"`
	// Whether to enable the EKS cluster Security Group as ingress to workers Security Group true.
	ClusterSecurityGroupIngressEnabled *bool `field:"optional" json:"clusterSecurityGroupIngressEnabled" yaml:"clusterSecurityGroupIngressEnabled"`
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
	// The amount of time, in seconds, after a scaling activity completes before another scaling activity can start 300.
	DefaultCooldown *float64 `field:"optional" json:"defaultCooldown" yaml:"defaultCooldown"`
	// Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.
	//
	// Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
	Delimiter *string `field:"optional" json:"delimiter" yaml:"delimiter"`
	// If `true`, enables EC2 Instance Termination Protection.
	DisableApiTermination *bool `field:"optional" json:"disableApiTermination" yaml:"disableApiTermination"`
	// If true, the launched EC2 instance will be EBS-optimized.
	EbsOptimized *bool `field:"optional" json:"ebsOptimized" yaml:"ebsOptimized"`
	// AMI name filter to lookup the most recent EKS AMI if `image_id` is not provided amazon-eks-node-*.
	EksWorkerAmiNameFilter *string `field:"optional" json:"eksWorkerAmiNameFilter" yaml:"eksWorkerAmiNameFilter"`
	// A regex string to apply to the AMI list returned by AWS ^amazon-eks-node-[1-9,.]+-v[0-9]{8}$.
	EksWorkerAmiNameRegex *string `field:"optional" json:"eksWorkerAmiNameRegex" yaml:"eksWorkerAmiNameRegex"`
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
	// Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'.
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
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for default, which is `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// EC2 image ID to launch.
	//
	// If not provided, the module will lookup the most recent EKS AMI. See https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html for more details on EKS-optimized images
	ImageId *string `field:"optional" json:"imageId" yaml:"imageId"`
	// Shutdown behavior for the instances.
	//
	// Can be `stop` or `terminate`
	// terminate.
	InstanceInitiatedShutdownBehavior *string `field:"optional" json:"instanceInitiatedShutdownBehavior" yaml:"instanceInitiatedShutdownBehavior"`
	// The market (purchasing) option for the instances.
	InstanceMarketOptions interface{} `field:"optional" json:"instanceMarketOptions" yaml:"instanceMarketOptions"`
	// SSH key name that should be used for the instance.
	KeyName *string `field:"optional" json:"keyName" yaml:"keyName"`
	// Extra arguments to pass to kubelet, like "--register-with-taints=dedicated=ci-cd:NoSchedule --node-labels=purpose=ci-worker".
	KubeletExtraArgs *string `field:"optional" json:"kubeletExtraArgs" yaml:"kubeletExtraArgs"`
	// The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`. Possible values: `lower`, `title`, `upper`. Default value: `title`.
	LabelKeyCase *string `field:"optional" json:"labelKeyCase" yaml:"labelKeyCase"`
	// The naming order of the id output and Name tag.
	//
	// Defaults to ["namespace", "environment", "stage", "name", "attributes"].
	// You can omit any of the 5 elements, but at least one must be present.
	LabelOrder *[]*string `field:"optional" json:"labelOrder" yaml:"labelOrder"`
	// The letter case of output label values (also used in `tags` and `id`).
	//
	// Possible values: `lower`, `title`, `upper` and `none` (no transformation).
	// Default value: `lower`.
	LabelValueCase *string `field:"optional" json:"labelValueCase" yaml:"labelValueCase"`
	// A list of elastic load balancer names to add to the autoscaling group.
	//
	// Only valid for classic load balancers. For ALBs, use `target_group_arns` instead
	LoadBalancers *[]*string `field:"optional" json:"loadBalancers" yaml:"loadBalancers"`
	// Set false to disable the Instance Metadata Service.
	//
	// true.
	MetadataHttpEndpointEnabled *bool `field:"optional" json:"metadataHttpEndpointEnabled" yaml:"metadataHttpEndpointEnabled"`
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
	// Solution name, e.g. 'app' or 'jenkins'.
	Name *string `field:"optional" json:"name" yaml:"name"`
	// Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'.
	Namespace *string `field:"optional" json:"namespace" yaml:"namespace"`
	// The placement specifications of the instances.
	Placement interface{} `field:"optional" json:"placement" yaml:"placement"`
	// The name of the placement group into which you'll launch your instances, if any.
	PlacementGroup *string `field:"optional" json:"placementGroup" yaml:"placementGroup"`
	// Allows setting instance protection.
	//
	// The autoscaling group will not select instances with this setting for terminination during scale in events.
	ProtectFromScaleIn *bool `field:"optional" json:"protectFromScaleIn" yaml:"protectFromScaleIn"`
	// Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.
	//
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// Specifies whether the adjustment is an absolute number or a percentage of the current capacity.
	//
	// Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`
	// ChangeInCapacity.
	ScaleDownAdjustmentType *string `field:"optional" json:"scaleDownAdjustmentType" yaml:"scaleDownAdjustmentType"`
	// The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start 300.
	ScaleDownCooldownSeconds *float64 `field:"optional" json:"scaleDownCooldownSeconds" yaml:"scaleDownCooldownSeconds"`
	// The scalling policy type, either `SimpleScaling`, `StepScaling` or `TargetTrackingScaling` SimpleScaling.
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
	// The scalling policy type, either `SimpleScaling`, `StepScaling` or `TargetTrackingScaling` SimpleScaling.
	ScaleUpPolicyType *string `field:"optional" json:"scaleUpPolicyType" yaml:"scaleUpPolicyType"`
	// The number of instances by which to scale.
	//
	// `scale_up_adjustment_type` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity
	// 1.
	ScaleUpScalingAdjustment *float64 `field:"optional" json:"scaleUpScalingAdjustment" yaml:"scaleUpScalingAdjustment"`
	// The ARN of the service-linked role that the ASG will use to call other AWS services.
	ServiceLinkedRoleArn *string `field:"optional" json:"serviceLinkedRoleArn" yaml:"serviceLinkedRoleArn"`
	// Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'.
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// A list of processes to suspend for the AutoScaling Group.
	//
	// The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your autoscaling group from functioning properly.
	SuspendedProcesses *[]*string `field:"optional" json:"suspendedProcesses" yaml:"suspendedProcesses"`
	// Additional tags (e.g. `map('BusinessUnit','XYZ')` The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}.
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// A list of aws_alb_target_group ARNs, for use with Application Load Balancing.
	TargetGroupArns *[]*string `field:"optional" json:"targetGroupArns" yaml:"targetGroupArns"`
	// A list of policies to decide how the instances in the auto scale group should be terminated.
	//
	// The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default`
	// Default.
	TerminationPolicies *[]*string `field:"optional" json:"terminationPolicies" yaml:"terminationPolicies"`
	// If set to `true`, will use variable `image_id` for the EKS workers inside autoscaling group.
	UseCustomImageId *bool `field:"optional" json:"useCustomImageId" yaml:"useCustomImageId"`
	// If set to `true`, will use variable `aws_iam_instance_profile_name` to run EKS workers using an existing AWS instance profile that was created outside of this module, workaround for error like `count cannot be computed`.
	UseExistingAwsIamInstanceProfile *bool `field:"optional" json:"useExistingAwsIamInstanceProfile" yaml:"useExistingAwsIamInstanceProfile"`
	// If set to `true`, will use variable `workers_security_group_id` to run EKS workers using an existing security group that was created outside of this module, workaround for errors like `count cannot be computed`.
	UseExistingSecurityGroup *bool `field:"optional" json:"useExistingSecurityGroup" yaml:"useExistingSecurityGroup"`
	// A maximum duration that Terraform should wait for ASG instances to be healthy before timing out.
	//
	// Setting this to '0' causes Terraform to skip all Capacity Waiting behavior
	// 10m.
	WaitForCapacityTimeout *string `field:"optional" json:"waitForCapacityTimeout" yaml:"waitForCapacityTimeout"`
	// Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations.
	//
	// Takes precedence over `min_elb_capacity` behavior.
	WaitForElbCapacity *float64 `field:"optional" json:"waitForElbCapacity" yaml:"waitForElbCapacity"`
	// List of policy ARNs that will be attached to the workers default role on creation.
	WorkersRolePolicyArns *[]*string `field:"optional" json:"workersRolePolicyArns" yaml:"workersRolePolicyArns"`
	// Count of policy ARNs that will be attached to the workers default role on creation.
	//
	// Needed to prevent Terraform error `count can't be computed`.
	WorkersRolePolicyArnsCount *float64 `field:"optional" json:"workersRolePolicyArnsCount" yaml:"workersRolePolicyArnsCount"`
	// The name of the existing security group that will be used in autoscaling group for EKS workers.
	//
	// If empty, a new security group will be created.
	WorkersSecurityGroupId *string `field:"optional" json:"workersSecurityGroupId" yaml:"workersSecurityGroupId"`
}

