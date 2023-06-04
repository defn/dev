package terraform_aws_vpc

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsVpcConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// When `true`, assign AWS generated IPv6 CIDR block to the VPC.
	//
	// Conflicts with `ipv6_ipam_pool_id`.
	AssignGeneratedIpv6CidrBlock *bool `field:"optional" json:"assignGeneratedIpv6CidrBlock" yaml:"assignGeneratedIpv6CidrBlock"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// When `true`, manage the default network acl and remove all rules, disabling all ingress and egress.
	//
	// When `false`, do not mange the default networking acl, allowing it to be managed by another component.
	DefaultNetworkAclDenyAll *bool `field:"optional" json:"defaultNetworkAclDenyAll" yaml:"defaultNetworkAclDenyAll"`
	// When `true`, manage the default route table and remove all routes, disabling all ingress and egress.
	//
	// When `false`, do not mange the default route table, allowing it to be managed by another component.
	// Conflicts with Terraform resource `aws_main_route_table_association`.
	DefaultRouteTableNoRoutes *bool `field:"optional" json:"defaultRouteTableNoRoutes" yaml:"defaultRouteTableNoRoutes"`
	// When `true`, manage the default security group and remove all rules, disabling all ingress and egress.
	//
	// When `false`, do not manage the default security group, allowing it to be managed by another component.
	DefaultSecurityGroupDenyAll *bool `field:"optional" json:"defaultSecurityGroupDenyAll" yaml:"defaultSecurityGroupDenyAll"`
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
	// Set `true` to enable [DNS hostnames](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames) in the VPC.
	DnsHostnamesEnabled *bool `field:"optional" json:"dnsHostnamesEnabled" yaml:"dnsHostnamesEnabled"`
	// Set `true` to enable DNS resolution in the VPC through the Amazon provided DNS server.
	DnsSupportEnabled *bool `field:"optional" json:"dnsSupportEnabled" yaml:"dnsSupportEnabled"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
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
	// A tenancy option for instances launched into the VPC.
	InstanceTenancy *string `field:"optional" json:"instanceTenancy" yaml:"instanceTenancy"`
	// Set `true` to create an Internet Gateway for the VPC.
	InternetGatewayEnabled *bool `field:"optional" json:"internetGatewayEnabled" yaml:"internetGatewayEnabled"`
	// IPv4 CIDR blocks to assign to the VPC.
	//
	// `ipv4_cidr_block` can be set explicitly, or set to `null` with the CIDR block derived from `ipv4_ipam_pool_id` using `ipv4_netmask_length`.
	// Map keys must be known at `plan` time, and are only used to track changes.
	Ipv4AdditionalCidrBlockAssociations interface{} `field:"optional" json:"ipv4AdditionalCidrBlockAssociations" yaml:"ipv4AdditionalCidrBlockAssociations"`
	// Timeouts (in `go` duration format) for creating and destroying IPv4 CIDR block associations.
	Ipv4CidrBlockAssociationTimeouts interface{} `field:"optional" json:"ipv4CidrBlockAssociationTimeouts" yaml:"ipv4CidrBlockAssociationTimeouts"`
	// The primary IPv4 CIDR block for the VPC.
	//
	// Either `ipv4_primary_cidr_block` or `ipv4_primary_cidr_block_association` must be set, but not both.
	Ipv4PrimaryCidrBlock *string `field:"optional" json:"ipv4PrimaryCidrBlock" yaml:"ipv4PrimaryCidrBlock"`
	// Configuration of the VPC's primary IPv4 CIDR block via IPAM.
	//
	// Conflicts with `ipv4_primary_cidr_block`.
	// One of `ipv4_primary_cidr_block` or `ipv4_primary_cidr_block_association` must be set.
	// Additional CIDR blocks can be set via `ipv4_additional_cidr_block_associations`.
	Ipv4PrimaryCidrBlockAssociation interface{} `field:"optional" json:"ipv4PrimaryCidrBlockAssociation" yaml:"ipv4PrimaryCidrBlockAssociation"`
	// IPv6 CIDR blocks to assign to the VPC (in addition to the autogenerated one).
	//
	// `ipv6_cidr_block` can be set explicitly, or set to `null` with the CIDR block derived from `ipv6_ipam_pool_id` using `ipv6_netmask_length`.
	// Map keys must be known at `plan` time and are used solely to prevent unnecessary changes.
	Ipv6AdditionalCidrBlockAssociations interface{} `field:"optional" json:"ipv6AdditionalCidrBlockAssociations" yaml:"ipv6AdditionalCidrBlockAssociations"`
	// Timeouts (in `go` duration format) for creating and destroying IPv6 CIDR block associations.
	Ipv6CidrBlockAssociationTimeouts interface{} `field:"optional" json:"ipv6CidrBlockAssociationTimeouts" yaml:"ipv6CidrBlockAssociationTimeouts"`
	// Set this to restrict advertisement of public addresses to a specific Network Border Group such as a LocalZone.
	//
	// Requires `assign_generated_ipv6_cidr_block` to be set to `true`.
	Ipv6CidrBlockNetworkBorderGroup *string `field:"optional" json:"ipv6CidrBlockNetworkBorderGroup" yaml:"ipv6CidrBlockNetworkBorderGroup"`
	// Set `true` to create an IPv6 Egress-Only Internet Gateway for the VPC.
	Ipv6EgressOnlyInternetGatewayEnabled *bool `field:"optional" json:"ipv6EgressOnlyInternetGatewayEnabled" yaml:"ipv6EgressOnlyInternetGatewayEnabled"`
	// Primary IPv6 CIDR block to assign to the VPC.
	//
	// Conflicts with `assign_generated_ipv6_cidr_block`.
	// `ipv6_cidr_block` can be set explicitly, or set to `null` with the CIDR block derived from `ipv6_ipam_pool_id` using `ipv6_netmask_length`.
	Ipv6PrimaryCidrBlockAssociation interface{} `field:"optional" json:"ipv6PrimaryCidrBlockAssociation" yaml:"ipv6PrimaryCidrBlockAssociation"`
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
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
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
}

