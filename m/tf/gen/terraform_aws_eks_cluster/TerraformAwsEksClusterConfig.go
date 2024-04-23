package terraform_aws_eks_cluster

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsEksClusterConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// A list of subnet IDs to launch the cluster in.
	SubnetIds *[]*string `field:"required" json:"subnetIds" yaml:"subnetIds"`
	// Access configuration for the EKS cluster.
	AccessConfig interface{} `field:"optional" json:"accessConfig" yaml:"accessConfig"`
	// List of IAM principles to allow to access the EKS cluster.
	//
	// It is recommended to use the default `user_name` because the default includes
	// the IAM role or user name and the session name for assumed roles.
	// Use when Principal ARN is not known at plan time.
	AccessEntries interface{} `field:"optional" json:"accessEntries" yaml:"accessEntries"`
	// Map of list of IAM roles for the EKS non-managed worker nodes.
	//
	// The map key is the node type, either `EC2_LINUX` or `EC2_WINDOWS`,
	// and the list contains the IAM roles of the nodes of that type.
	// There is no need for or utility in creating Fargate access entries, as those
	// are always created automatically by AWS, just as with managed nodes.
	// Use when Principal ARN is not known at plan time.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AccessEntriesForNodes *map[string]*[]*string `field:"optional" json:"accessEntriesForNodes" yaml:"accessEntriesForNodes"`
	// Map of IAM Principal ARNs to access configuration.
	//
	// Preferred over other inputs as this configuration remains stable
	// when elements are added or removed, but it requires that the Principal ARNs
	// and Policy ARNs are known at plan time.
	// Can be used along with other `access_*` inputs, but do not duplicate entries.
	// Map `access_policy_associations` keys are policy ARNs, policy
	// full name (AmazonEKSViewPolicy), or short name (View).
	// It is recommended to use the default `user_name` because the default includes
	// IAM role or user name and the session name for assumed roles.
	// As a special case in support of backwards compatibility, membership in the
	// `system:masters` group is is translated to an association with the ClusterAdmin policy.
	// In all other cases, including any `system:*` group in `kubernetes_groups` is prohibited.
	AccessEntryMap interface{} `field:"optional" json:"accessEntryMap" yaml:"accessEntryMap"`
	// List of AWS managed EKS access policies to associate with IAM principles.
	//
	// Use when Principal ARN or Policy ARN is not known at plan time.
	// `policy_arn` can be the full ARN, the full name (AmazonEKSViewPolicy) or short name (View).
	AccessPolicyAssociations interface{} `field:"optional" json:"accessPolicyAssociations" yaml:"accessPolicyAssociations"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// Manages [`aws_eks_addon`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) resources. Note: `resolve_conflicts` is deprecated. If `resolve_conflicts` is set and `resolve_conflicts_on_create` or `resolve_conflicts_on_update` is not set, `resolve_conflicts` will be used instead. If `resolve_conflicts_on_create` is not set and `resolve_conflicts` is `PRESERVE`, `resolve_conflicts_on_create` will be set to `NONE`.
	Addons interface{} `field:"optional" json:"addons" yaml:"addons"`
	// If provided, all addons will depend on this object, and therefore not be installed until this object is finalized.
	//
	// This is useful if you want to ensure that addons are not applied before some other condition is met, e.g. node groups are created.
	// See [issue #170](https://github.com/cloudposse/terraform-aws-eks-cluster/issues/170) for more details.
	AddonsDependsOn interface{} `field:"optional" json:"addonsDependsOn" yaml:"addonsDependsOn"`
	// A list of IPv4 CIDRs to allow access to the cluster.
	//
	// The length of this list must be known at "plan" time.
	AllowedCidrBlocks *[]*string `field:"optional" json:"allowedCidrBlocks" yaml:"allowedCidrBlocks"`
	// A list of IDs of Security Groups to allow access to the cluster.
	AllowedSecurityGroupIds *[]*string `field:"optional" json:"allowedSecurityGroupIds" yaml:"allowedSecurityGroupIds"`
	// A list of IDs of Security Groups to associate the cluster with.
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
	// If provided, the KMS Key ID to use to encrypt AWS CloudWatch logs.
	CloudwatchLogGroupKmsKeyId *string `field:"optional" json:"cloudwatchLogGroupKmsKeyId" yaml:"cloudwatchLogGroupKmsKeyId"`
	// Override label module default cluster attributes cluster.
	ClusterAttributes *[]*string `field:"optional" json:"clusterAttributes" yaml:"clusterAttributes"`
	// If provided, the EKS will depend on this object, and therefore not be created until this object is finalized.
	//
	// This is useful if you want to ensure that the cluster is not created before some other condition is met, e.g. VPNs into the subnet are created.
	ClusterDependsOn interface{} `field:"optional" json:"clusterDependsOn" yaml:"clusterDependsOn"`
	// Set to `true` to enable Cluster Encryption Configuration true.
	ClusterEncryptionConfigEnabled *bool `field:"optional" json:"clusterEncryptionConfigEnabled" yaml:"clusterEncryptionConfigEnabled"`
	// Cluster Encryption Config KMS Key Resource argument - key deletion windows in days post destruction 10.
	ClusterEncryptionConfigKmsKeyDeletionWindowInDays *float64 `field:"optional" json:"clusterEncryptionConfigKmsKeyDeletionWindowInDays" yaml:"clusterEncryptionConfigKmsKeyDeletionWindowInDays"`
	// Cluster Encryption Config KMS Key Resource argument - enable kms key rotation true.
	ClusterEncryptionConfigKmsKeyEnableKeyRotation *bool `field:"optional" json:"clusterEncryptionConfigKmsKeyEnableKeyRotation" yaml:"clusterEncryptionConfigKmsKeyEnableKeyRotation"`
	// KMS Key ID to use for cluster encryption config.
	ClusterEncryptionConfigKmsKeyId *string `field:"optional" json:"clusterEncryptionConfigKmsKeyId" yaml:"clusterEncryptionConfigKmsKeyId"`
	// Cluster Encryption Config KMS Key Resource argument - key policy.
	ClusterEncryptionConfigKmsKeyPolicy *string `field:"optional" json:"clusterEncryptionConfigKmsKeyPolicy" yaml:"clusterEncryptionConfigKmsKeyPolicy"`
	// Cluster Encryption Config Resources to encrypt, e.g. ['secrets'] secrets.
	ClusterEncryptionConfigResources *[]interface{} `field:"optional" json:"clusterEncryptionConfigResources" yaml:"clusterEncryptionConfigResources"`
	// Number of days to retain cluster logs.
	//
	// Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html.
	ClusterLogRetentionPeriod *float64 `field:"optional" json:"clusterLogRetentionPeriod" yaml:"clusterLogRetentionPeriod"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// Set `false` to use existing `eks_cluster_service_role_arn` instead of creating one true.
	CreateEksServiceRole *bool `field:"optional" json:"createEksServiceRole" yaml:"createEksServiceRole"`
	// A List of Objects, which are custom security group rules that.
	CustomIngressRules interface{} `field:"optional" json:"customIngressRules" yaml:"customIngressRules"`
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
	// The ARN of an IAM role for the EKS cluster to use that provides permissions for the Kubernetes control plane to perform needed AWS API operations.
	//
	// Required if `create_eks_service_role` is `false`, ignored otherwise.
	EksClusterServiceRoleArn *string `field:"optional" json:"eksClusterServiceRoleArn" yaml:"eksClusterServiceRoleArn"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// A list of the desired control plane logging to enable.
	//
	// For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]
	EnabledClusterLogTypes *[]*string `field:"optional" json:"enabledClusterLogTypes" yaml:"enabledClusterLogTypes"`
	// Indicates whether or not the Amazon EKS private API server endpoint is enabled.
	//
	// Default to AWS EKS resource and it is false.
	EndpointPrivateAccess *bool `field:"optional" json:"endpointPrivateAccess" yaml:"endpointPrivateAccess"`
	// Indicates whether or not the Amazon EKS public API server endpoint is enabled.
	//
	// Default to AWS EKS resource and it is true
	// true.
	EndpointPublicAccess *bool `field:"optional" json:"endpointPublicAccess" yaml:"endpointPublicAccess"`
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
	// Set true to use IPv6 addresses for Kubernetes pods and services.
	KubernetesNetworkIpv6Enabled *bool `field:"optional" json:"kubernetesNetworkIpv6Enabled" yaml:"kubernetesNetworkIpv6Enabled"`
	// Desired Kubernetes master version.
	//
	// If you do not specify a value, the latest available version is used
	// 1.21
	KubernetesVersion *string `field:"optional" json:"kubernetesVersion" yaml:"kubernetesVersion"`
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
	// Flag to enable/disable the ingress and egress rules for the EKS managed Security Group true.
	ManagedSecurityGroupRulesEnabled *bool `field:"optional" json:"managedSecurityGroupRulesEnabled" yaml:"managedSecurityGroupRulesEnabled"`
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
	// Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam.
	//
	// For more information,
	// see [EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html).
	OidcProviderEnabled *bool `field:"optional" json:"oidcProviderEnabled" yaml:"oidcProviderEnabled"`
	// If provided, all IAM roles will be created with this permissions boundary attached.
	PermissionsBoundary *string `field:"optional" json:"permissionsBoundary" yaml:"permissionsBoundary"`
	// Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled.
	//
	// EKS defaults this to a list with 0.0.0.0/0.
	// 0.0.0.0/0
	PublicAccessCidrs *[]*string `field:"optional" json:"publicAccessCidrs" yaml:"publicAccessCidrs"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// OBSOLETE (not needed): AWS Region.
	Region *string `field:"optional" json:"region" yaml:"region"`
	// The CIDR block to assign Kubernetes service IP addresses from.
	//
	// You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created.
	ServiceIpv4Cidr *string `field:"optional" json:"serviceIpv4Cidr" yaml:"serviceIpv4Cidr"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
}

