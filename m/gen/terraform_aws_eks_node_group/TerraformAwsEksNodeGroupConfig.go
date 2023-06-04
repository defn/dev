package terraform_aws_eks_node_group

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEksNodeGroupConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// The name of the EKS cluster.
	ClusterName *string `field:"required" json:"clusterName" yaml:"clusterName"`
	// Initial desired number of worker nodes (external changes ignored).
	DesiredSize *float64 `field:"required" json:"desiredSize" yaml:"desiredSize"`
	// Maximum number of worker nodes.
	MaxSize *float64 `field:"required" json:"maxSize" yaml:"maxSize"`
	// Minimum number of worker nodes.
	MinSize *float64 `field:"required" json:"minSize" yaml:"minSize"`
	// A list of subnet IDs to launch resources in.
	SubnetIds *[]*string `field:"required" json:"subnetIds" yaml:"subnetIds"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// Additional `bash` commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production.
	AfterClusterJoiningUserdata *[]*string `field:"optional" json:"afterClusterJoiningUserdata" yaml:"afterClusterJoiningUserdata"`
	// AMI to use.
	//
	// Ignored if `launch_template_id` is supplied.
	AmiImageId *[]*string `field:"optional" json:"amiImageId" yaml:"amiImageId"`
	// EKS AMI version to use, e.g. For AL2 "1.16.13-20200821" or for bottlerocket "1.2.0-ccf1b754" (no "v") or  for Windows "2023.02.14". For AL2, bottlerocket and Windows, it defaults to latest version for Kubernetes version.
	AmiReleaseVersion *[]*string `field:"optional" json:"amiReleaseVersion" yaml:"amiReleaseVersion"`
	// Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
	//
	// Defaults to `AL2_x86_64`. Valid values: `AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM, BOTTLEROCKET_ARM_64, BOTTLEROCKET_x86_64, BOTTLEROCKET_ARM_64_NVIDIA, BOTTLEROCKET_x86_64_NVIDIA, WINDOWS_CORE_2019_x86_64, WINDOWS_FULL_2019_x86_64, WINDOWS_CORE_2022_x86_64, WINDOWS_FULL_2022_x86_64`.
	AmiType *string `field:"optional" json:"amiType" yaml:"amiType"`
	// When true, associate the default cluster security group to the nodes.
	//
	// If disabled the EKS managed security group will not
	// be associated to the nodes, therefore the communications between pods and nodes will not work. Be aware that if no `associated_security_group_ids`
	// nor `ssh_access_security_group_ids` are provided then the nodes will have no inbound or outbound rules.
	AssociateClusterSecurityGroup *bool `field:"optional" json:"associateClusterSecurityGroup" yaml:"associateClusterSecurityGroup"`
	// A list of IDs of Security Groups to associate the node group with, in addition to the EKS' created security group.
	//
	// These security groups will not be modified.
	AssociatedSecurityGroupIds *[]*string `field:"optional" json:"associatedSecurityGroupIds" yaml:"associatedSecurityGroupIds"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// Additional `bash` commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production.
	BeforeClusterJoiningUserdata *[]*string `field:"optional" json:"beforeClusterJoiningUserdata" yaml:"beforeClusterJoiningUserdata"`
	// List of block device mappings for the launch template.
	//
	// Each list element is an object with a `device_name` key and
	// any keys supported by the `ebs` block of `launch_template`.
	BlockDeviceMappings *[]interface{} `field:"optional" json:"blockDeviceMappings" yaml:"blockDeviceMappings"`
	// Additional options to bootstrap.sh. DO NOT include `--kubelet-additional-args`, use `kubelet_additional_args` var instead.
	BootstrapAdditionalOptions *[]*string `field:"optional" json:"bootstrapAdditionalOptions" yaml:"bootstrapAdditionalOptions"`
	// Type of capacity associated with the EKS Node Group.
	//
	// Valid values: "ON_DEMAND", "SPOT", or `null`.
	// Terraform will only perform drift detection if a configuration value is provided.
	CapacityType *string `field:"optional" json:"capacityType" yaml:"capacityType"`
	// Set true to label the node group so that the [Kubernetes Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#auto-discovery-setup) will discover and autoscale it.
	ClusterAutoscalerEnabled *bool `field:"optional" json:"clusterAutoscalerEnabled" yaml:"clusterAutoscalerEnabled"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// Set true in order to create the new node group before destroying the old one.
	//
	// If false, the old node group will be destroyed first, causing downtime.
	// Changing this setting will always cause node group to be replaced.
	CreateBeforeDestroy *bool `field:"optional" json:"createBeforeDestroy" yaml:"createBeforeDestroy"`
	// Delimiter to be used between ID elements.
	//
	// Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
	Delimiter *string `field:"optional" json:"delimiter" yaml:"delimiter"`
	// Describe additional descriptors to be output in the `descriptors` output map.
	//
	// Map of maps. Keys are names of descriptors. Values are maps of the form
	// `{
	// format = string
	// labels = list(string)
	// }`
	// (Type is `any` so the map values can later be enhanced to provide additional options.)
	// `format` is a Terraform format string to be passed to the `format()` function.
	// `labels` is a list of labels, in order, to pass to `format()` function.
	// Label values will be normalized before being passed to `format()` so they will be
	// identical to how they appear in `id`.
	// Default is `{}` (`descriptors` output will be empty).
	DescriptorFormats interface{} `field:"optional" json:"descriptorFormats" yaml:"descriptorFormats"`
	// The launched EC2 instance will have detailed monitoring enabled.
	//
	// Defaults to false.
	DetailedMonitoringEnabled *bool `field:"optional" json:"detailedMonitoringEnabled" yaml:"detailedMonitoringEnabled"`
	// Set `false` to disable EBS optimization.
	EbsOptimized *bool `field:"optional" json:"ebsOptimized" yaml:"ebsOptimized"`
	// SSH key pair name to use to access the worker nodes.
	Ec2SshKeyName *[]*string `field:"optional" json:"ec2SshKeyName" yaml:"ec2SshKeyName"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// Set to `true` to enable Nitro Enclaves on the instance.
	EnclaveEnabled *bool `field:"optional" json:"enclaveEnabled" yaml:"enclaveEnabled"`
	// ID element.
	//
	// Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'
	Environment *string `field:"optional" json:"environment" yaml:"environment"`
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for keep the existing setting, which defaults to `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// Instance types to use for this node group (up to 20).
	//
	// Defaults to ["t3.medium"].
	// Must be empty if the launch template configured by `launch_template_id` specifies an instance type.
	InstanceTypes *[]*string `field:"optional" json:"instanceTypes" yaml:"instanceTypes"`
	// Additional flags to pass to kubelet.
	//
	// DO NOT include `--node-labels` or `--node-taints`,
	// use `kubernetes_labels` and `kubernetes_taints` to specify those."
	KubeletAdditionalOptions *[]*string `field:"optional" json:"kubeletAdditionalOptions" yaml:"kubeletAdditionalOptions"`
	// Key-value mapping of Kubernetes labels.
	//
	// Only labels that are applied with the EKS API are managed by this argument.
	// Other Kubernetes labels applied to the EKS Node Group will not be managed.
	KubernetesLabels *map[string]*string `field:"optional" json:"kubernetesLabels" yaml:"kubernetesLabels"`
	// List of `key`, `value`, `effect` objects representing Kubernetes taints.
	//
	// `effect` must be one of `NO_SCHEDULE`, `NO_EXECUTE`, or `PREFER_NO_SCHEDULE`.
	// `key` and `effect` are required, `value` may be null.
	KubernetesTaints interface{} `field:"optional" json:"kubernetesTaints" yaml:"kubernetesTaints"`
	// Kubernetes version.
	//
	// Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided
	KubernetesVersion *[]*string `field:"optional" json:"kubernetesVersion" yaml:"kubernetesVersion"`
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
	// *Notes:**
	// The value of the `name` tag, if included, will be the `id`, not the `name`.
	// Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be
	// changed in later chained modules. Attempts to change it will be silently ignored.
	LabelsAsTags *[]*string `field:"optional" json:"labelsAsTags" yaml:"labelsAsTags"`
	// Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually.
	//
	// Does not affect values of tags passed in via the `tags` input.
	// Possible values: `lower`, `title`, `upper` and `none` (no transformation).
	// Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.
	// Default value: `lower`.
	LabelValueCase *string `field:"optional" json:"labelValueCase" yaml:"labelValueCase"`
	// The ID (not name) of a custom launch template to use for the EKS node group.
	//
	// If provided, it must specify the AMI image ID.
	LaunchTemplateId *[]*string `field:"optional" json:"launchTemplateId" yaml:"launchTemplateId"`
	// The version of the specified launch template to use.
	//
	// Defaults to latest version.
	LaunchTemplateVersion *[]*string `field:"optional" json:"launchTemplateVersion" yaml:"launchTemplateVersion"`
	// Set false to disable the Instance Metadata Service.
	MetadataHttpEndpointEnabled *bool `field:"optional" json:"metadataHttpEndpointEnabled" yaml:"metadataHttpEndpointEnabled"`
	// The desired HTTP PUT response hop limit (between 1 and 64) for Instance Metadata Service requests.
	//
	// The default is `2` to allows containerized workloads assuming the instance profile, but it's not really recomended. You should use OIDC service accounts instead.
	MetadataHttpPutResponseHopLimit *float64 `field:"optional" json:"metadataHttpPutResponseHopLimit" yaml:"metadataHttpPutResponseHopLimit"`
	// Set true to require IMDS session tokens, disabling Instance Metadata Service Version 1.
	MetadataHttpTokensRequired *bool `field:"optional" json:"metadataHttpTokensRequired" yaml:"metadataHttpTokensRequired"`
	// Can be any value desired.
	//
	// Module will wait for this value to be computed before creating node group.
	ModuleDependsOn interface{} `field:"optional" json:"moduleDependsOn" yaml:"moduleDependsOn"`
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
	// Configuration for the Terraform [`timeouts` Configuration Block](https://www.terraform.io/docs/language/resources/syntax.html#operation-timeouts) of the node group resource. Leave list empty for defaults. Pass list with single object with attributes matching the `timeouts` block to configure it. Leave attribute values `null` to preserve individual defaults while setting others.
	NodeGroupTerraformTimeouts interface{} `field:"optional" json:"nodeGroupTerraformTimeouts" yaml:"nodeGroupTerraformTimeouts"`
	// If provided, assign workers the given role, which this module will not modify.
	NodeRoleArn *[]*string `field:"optional" json:"nodeRoleArn" yaml:"nodeRoleArn"`
	// When true, the `AmazonEKS_CNI_Policy` will be attached to the node IAM role.
	//
	// This used to be required, but it is [now recommended](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html) that this policy be
	// attached only to the `aws-node` Kubernetes service account. However, that
	// is difficult to do with Terraform, so this module defaults to the old pattern.
	NodeRoleCniPolicyEnabled *bool `field:"optional" json:"nodeRoleCniPolicyEnabled" yaml:"nodeRoleCniPolicyEnabled"`
	// If provided, all IAM roles will be created with this permissions boundary attached.
	NodeRolePermissionsBoundary *string `field:"optional" json:"nodeRolePermissionsBoundary" yaml:"nodeRolePermissionsBoundary"`
	// List of policy ARNs to attach to the worker role this module creates in addition to the default ones.
	NodeRolePolicyArns *[]*string `field:"optional" json:"nodeRolePolicyArns" yaml:"nodeRolePolicyArns"`
	// Configuration for the [`placement` Configuration Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#placement) of the launch template. Leave list empty for defaults. Pass list with single object with attributes matching the `placement` block to configure it. Note that this configures the launch template only. Some elements will be ignored by the Auto Scaling Group that actually launches instances. Consult AWS documentation for details.
	Placement *[]interface{} `field:"optional" json:"placement" yaml:"placement"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// List of auto-launched resource types to tag.
	//
	// Valid types are "instance", "volume", "elastic-gpu", "spot-instances-request", "network-interface".
	ResourcesToTag *[]*string `field:"optional" json:"resourcesToTag" yaml:"resourcesToTag"`
	// Set of EC2 Security Group IDs to allow SSH access (port 22) to the worker nodes.
	//
	// If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)
	SshAccessSecurityGroupIds *[]*string `field:"optional" json:"sshAccessSecurityGroupIds" yaml:"sshAccessSecurityGroupIds"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
	// Configuration for the `eks_node_group` [`update_config` Configuration Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#update_config-configuration-block). Specify exactly one of `max_unavailable` (node count) or `max_unavailable_percentage` (percentage of nodes).
	UpdateConfig *[]*map[string]*float64 `field:"optional" json:"updateConfig" yaml:"updateConfig"`
	// Many features of this module rely on the `bootstrap.sh` provided with Amazon Linux, and this module may generate "user data" that expects to find that script. If you want to use an AMI that is not compatible with the Amazon Linux `bootstrap.sh` initialization, then use `userdata_override_base64` to provide your own (Base64 encoded) user data. Use "" to prevent any user data from being set.
	//
	// Setting `userdata_override_base64` disables `kubernetes_taints`, `kubelet_additional_options`,
	// `before_cluster_joining_userdata`, `after_cluster_joining_userdata`, and `bootstrap_additional_options`.
	UserdataOverrideBase64 *[]*string `field:"optional" json:"userdataOverrideBase64" yaml:"userdataOverrideBase64"`
}

