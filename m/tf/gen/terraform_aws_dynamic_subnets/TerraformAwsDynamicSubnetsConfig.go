package terraform_aws_dynamic_subnets

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsDynamicSubnetsConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// VPC ID where subnets will be created (e.g. `vpc-aceb2723`).
	VpcId *string `field:"required" json:"vpcId" yaml:"vpcId"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// The style of Availability Zone code to use in tags and names.
	//
	// One of `full`, `short`, or `fixed`.
	// When using `availability_zone_ids`, IDs will first be translated into AZ names.
	//
	// short.
	AvailabilityZoneAttributeStyle *string `field:"optional" json:"availabilityZoneAttributeStyle" yaml:"availabilityZoneAttributeStyle"`
	// List of Availability Zones IDs where subnets will be created.
	//
	// Overrides `availability_zones`.
	// Useful in some regions when using only some AZs and you want to use the same ones across multiple accounts.
	AvailabilityZoneIds *[]*string `field:"optional" json:"availabilityZoneIds" yaml:"availabilityZoneIds"`
	// List of Availability Zones (AZs) where subnets will be created.
	//
	// Ignored when `availability_zone_ids` is set.
	// The order of zones in the list ***must be stable*** or else Terraform will continually make changes.
	// If no AZs are specified, then `max_subnet_count` AZs will be selected in alphabetical order.
	// If `max_subnet_count > 0` and `length(var.availability_zones) > max_subnet_count`, the list
	// will be truncated. We recommend setting `availability_zones` and `max_subnet_count` explicitly as constant
	// (not computed) values for predictability, consistency, and stability.
	AvailabilityZones *[]*string `field:"optional" json:"availabilityZones" yaml:"availabilityZones"`
	// DEPRECATED: Use `route_create_timeout` instead.
	//
	// Time to wait for AWS route creation, specified as a Go Duration, e.g. `2m`
	AwsRouteCreateTimeout *string `field:"optional" json:"awsRouteCreateTimeout" yaml:"awsRouteCreateTimeout"`
	// DEPRECATED: Use `route_delete_timeout` instead.
	//
	// Time to wait for AWS route deletion, specified as a Go Duration, e.g. `2m`
	AwsRouteDeleteTimeout *string `field:"optional" json:"awsRouteDeleteTimeout" yaml:"awsRouteDeleteTimeout"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
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
	// The Internet Gateway ID that the public subnets will route traffic to.
	//
	// Used if `public_route_table_enabled` is `true`, ignored otherwise.
	IgwId *[]*string `field:"optional" json:"igwId" yaml:"igwId"`
	// Base IPv4 CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`). Ignored if `ipv4_cidrs` is set. If no CIDR block is provided, the VPC's default IPv4 CIDR block will be used.
	Ipv4CidrBlock *[]*string `field:"optional" json:"ipv4CidrBlock" yaml:"ipv4CidrBlock"`
	// Lists of CIDRs to assign to subnets.
	//
	// Order of CIDRs in the lists must not change over time.
	// Lists may contain more CIDRs than needed.
	Ipv4Cidrs interface{} `field:"optional" json:"ipv4Cidrs" yaml:"ipv4Cidrs"`
	// Set `true` to enable IPv4 addresses in the subnets true.
	Ipv4Enabled *bool `field:"optional" json:"ipv4Enabled" yaml:"ipv4Enabled"`
	// If `true`, DNS queries for instance hostnames in the private subnets will be answered with A (IPv4) records.
	Ipv4PrivateInstanceHostnamesEnabled *bool `field:"optional" json:"ipv4PrivateInstanceHostnamesEnabled" yaml:"ipv4PrivateInstanceHostnamesEnabled"`
	// How to generate the DNS name for the instances in the private subnets.
	//
	// Either `ip-name` to generate it from the IPv4 address, or
	// `resource-name` to generate it from the instance ID.
	//
	// ip-name.
	Ipv4PrivateInstanceHostnameType *string `field:"optional" json:"ipv4PrivateInstanceHostnameType" yaml:"ipv4PrivateInstanceHostnameType"`
	// If `true`, DNS queries for instance hostnames in the public subnets will be answered with A (IPv4) records.
	Ipv4PublicInstanceHostnamesEnabled *bool `field:"optional" json:"ipv4PublicInstanceHostnamesEnabled" yaml:"ipv4PublicInstanceHostnamesEnabled"`
	// How to generate the DNS name for the instances in the public subnets.
	//
	// Either `ip-name` to generate it from the IPv4 address, or
	// `resource-name` to generate it from the instance ID.
	//
	// ip-name.
	Ipv4PublicInstanceHostnameType *string `field:"optional" json:"ipv4PublicInstanceHostnameType" yaml:"ipv4PublicInstanceHostnameType"`
	// Base IPv6 CIDR block from which `/64` subnet CIDRs will be assigned.
	//
	// Must be `/56`. (e.g. `2600:1f16:c52:ab00::/56`).
	// Ignored if `ipv6_cidrs` is set. If no CIDR block is provided, the VPC's default IPv6 CIDR block will be used.
	Ipv6CidrBlock *[]*string `field:"optional" json:"ipv6CidrBlock" yaml:"ipv6CidrBlock"`
	// Lists of CIDRs to assign to subnets.
	//
	// Order of CIDRs in the lists must not change over time.
	// Lists may contain more CIDRs than needed.
	Ipv6Cidrs interface{} `field:"optional" json:"ipv6Cidrs" yaml:"ipv6Cidrs"`
	// The Egress Only Internet Gateway ID the private IPv6 subnets will route traffic to.
	//
	// Used if `private_route_table_enabled` is `true` and `ipv6_enabled` is `true`, ignored otherwise.
	Ipv6EgressOnlyIgwId *[]*string `field:"optional" json:"ipv6EgressOnlyIgwId" yaml:"ipv6EgressOnlyIgwId"`
	// Set `true` to enable IPv6 addresses in the subnets.
	Ipv6Enabled *bool `field:"optional" json:"ipv6Enabled" yaml:"ipv6Enabled"`
	// If `true` (or if `ipv4_enabled` is `false`), DNS queries for instance hostnames in the private subnets will be answered with AAAA (IPv6) records.
	Ipv6PrivateInstanceHostnamesEnabled *bool `field:"optional" json:"ipv6PrivateInstanceHostnamesEnabled" yaml:"ipv6PrivateInstanceHostnamesEnabled"`
	// If `true` (or if `ipv4_enabled` is false), DNS queries for instance hostnames in the public subnets will be answered with AAAA (IPv6) records.
	Ipv6PublicInstanceHostnamesEnabled *bool `field:"optional" json:"ipv6PublicInstanceHostnamesEnabled" yaml:"ipv6PublicInstanceHostnamesEnabled"`
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
	// If `true`, instances launched into a public subnet will be assigned a public IPv4 address true.
	MapPublicIpOnLaunch *bool `field:"optional" json:"mapPublicIpOnLaunch" yaml:"mapPublicIpOnLaunch"`
	// Upper limit on number of NAT Gateways/Instances to create.
	//
	// Set to 1 or 2 for cost savings at the expense of availability.
	//
	// 999.
	MaxNats *float64 `field:"optional" json:"maxNats" yaml:"maxNats"`
	// Sets the maximum number of each type (public or private) of subnet to deploy.
	//
	// `0` will reserve a CIDR for every Availability Zone (excluding Local Zones) in the region, and
	// deploy a subnet in each availability zone specified in `availability_zones` or `availability_zone_ids`,
	// or every zone if none are specified. We recommend setting this equal to the maximum number of AZs you anticipate using,
	// to avoid causing subnets to be destroyed and recreated with smaller IPv4 CIDRs when AWS adds an availability zone.
	// Due to Terraform limitations, you can not set `max_subnet_count` from a computed value, you have to set it
	// from an explicit constant. For most cases, `3` is a good choice.
	MaxSubnetCount *float64 `field:"optional" json:"maxSubnetCount" yaml:"maxSubnetCount"`
	// Whether the metadata service is available on the created NAT instances true.
	MetadataHttpEndpointEnabled *bool `field:"optional" json:"metadataHttpEndpointEnabled" yaml:"metadataHttpEndpointEnabled"`
	// The desired HTTP PUT response hop limit (between 1 and 64) for instance metadata requests on the created NAT instances 1.
	MetadataHttpPutResponseHopLimit *float64 `field:"optional" json:"metadataHttpPutResponseHopLimit" yaml:"metadataHttpPutResponseHopLimit"`
	// Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2, on the created NAT instances true.
	MetadataHttpTokensRequired *bool `field:"optional" json:"metadataHttpTokensRequired" yaml:"metadataHttpTokensRequired"`
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
	// Existing Elastic IPs (not EIP IDs) to attach to the NAT Gateway(s) or Instance(s) instead of creating new ones.
	NatElasticIps *[]*string `field:"optional" json:"natElasticIps" yaml:"natElasticIps"`
	// Set `true` to create NAT Gateways to perform IPv4 NAT and NAT64 as needed.
	//
	// Defaults to `true` unless `nat_instance_enabled` is `true`.
	NatGatewayEnabled *bool `field:"optional" json:"natGatewayEnabled" yaml:"natGatewayEnabled"`
	// A list optionally containing the ID of the AMI to use for the NAT instance.
	//
	// If the list is empty (the default), the latest official AWS NAT instance AMI
	// will be used. NOTE: The Official NAT instance AMI is being phased out and
	// does not support NAT64. Use of a NAT gateway is recommended instead.
	NatInstanceAmiId *[]*string `field:"optional" json:"natInstanceAmiId" yaml:"natInstanceAmiId"`
	// NAT Instance credit option for CPU usage.
	//
	// Valid values are "standard" or "unlimited".
	// T3 and later instances are launched as unlimited by default. T2 instances are launched as standard by default.
	NatInstanceCpuCreditsOverride *string `field:"optional" json:"natInstanceCpuCreditsOverride" yaml:"natInstanceCpuCreditsOverride"`
	// Set `true` to create NAT Instances to perform IPv4 NAT.
	//
	// Defaults to `false`.
	NatInstanceEnabled *bool `field:"optional" json:"natInstanceEnabled" yaml:"natInstanceEnabled"`
	// Whether to encrypt the root block device on the created NAT instances true.
	NatInstanceRootBlockDeviceEncrypted *bool `field:"optional" json:"natInstanceRootBlockDeviceEncrypted" yaml:"natInstanceRootBlockDeviceEncrypted"`
	// NAT Instance type t3.micro.
	NatInstanceType *string `field:"optional" json:"natInstanceType" yaml:"natInstanceType"`
	// The `rule_no` assigned to the network ACL rules for IPv4 traffic generated by this module 100.
	OpenNetworkAclIpv4RuleNumber *float64 `field:"optional" json:"openNetworkAclIpv4RuleNumber" yaml:"openNetworkAclIpv4RuleNumber"`
	// The `rule_no` assigned to the network ACL rules for IPv6 traffic generated by this module 111.
	OpenNetworkAclIpv6RuleNumber *float64 `field:"optional" json:"openNetworkAclIpv6RuleNumber" yaml:"openNetworkAclIpv6RuleNumber"`
	// If `true`, network interfaces created in a private subnet will be assigned an IPv6 address true.
	PrivateAssignIpv6AddressOnCreation *bool `field:"optional" json:"privateAssignIpv6AddressOnCreation" yaml:"privateAssignIpv6AddressOnCreation"`
	// If `true` and IPv6 is enabled, DNS queries made to the Amazon-provided DNS Resolver in private subnets will return synthetic IPv6 addresses for IPv4-only destinations, and these addresses will be routed to the NAT Gateway.
	//
	// Requires `public_subnets_enabled`, `nat_gateway_enabled`, and `private_route_table_enabled` to be `true` to be fully operational.
	// Defaults to `true` unless there is no public IPv4 subnet for egress, in which case it defaults to `false`.
	PrivateDns64Nat64Enabled *bool `field:"optional" json:"privateDns64Nat64Enabled" yaml:"privateDns64Nat64Enabled"`
	// The string to use in IDs and elsewhere to identify resources for the private subnets and distinguish them from resources for the public subnets private.
	PrivateLabel *string `field:"optional" json:"privateLabel" yaml:"privateLabel"`
	// If `true`, a single network ACL be created and it will be associated with every private subnet, and a rule (number 100) will be created allowing all ingress and all egress.
	//
	// You can add additional rules to this network ACL
	// using the `aws_network_acl_rule` resource.
	// If `false`, you will need to manage the network ACL outside of this module.
	//
	// true.
	PrivateOpenNetworkAclEnabled *bool `field:"optional" json:"privateOpenNetworkAclEnabled" yaml:"privateOpenNetworkAclEnabled"`
	// If `true`, a network route table and default route to the NAT gateway, NAT instance, or egress-only gateway will be created for each private subnet (1:1).
	//
	// If false, you will need to create your own route table(s) and route(s).
	//
	// true.
	PrivateRouteTableEnabled *bool `field:"optional" json:"privateRouteTableEnabled" yaml:"privateRouteTableEnabled"`
	// Additional tags to be added to private subnets The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}.
	PrivateSubnetsAdditionalTags *map[string]*string `field:"optional" json:"privateSubnetsAdditionalTags" yaml:"privateSubnetsAdditionalTags"`
	// If false, do not create private subnets (or NAT gateways or instances) true.
	PrivateSubnetsEnabled *bool `field:"optional" json:"privateSubnetsEnabled" yaml:"privateSubnetsEnabled"`
	// If `true`, network interfaces created in a public subnet will be assigned an IPv6 address true.
	PublicAssignIpv6AddressOnCreation *bool `field:"optional" json:"publicAssignIpv6AddressOnCreation" yaml:"publicAssignIpv6AddressOnCreation"`
	// If `true` and IPv6 is enabled, DNS queries made to the Amazon-provided DNS Resolver in public subnets will return synthetic IPv6 addresses for IPv4-only destinations, and these addresses will be routed to the NAT Gateway.
	//
	// Requires `nat_gateway_enabled` and `public_route_table_enabled` to be `true` to be fully operational.
	PublicDns64Nat64Enabled *bool `field:"optional" json:"publicDns64Nat64Enabled" yaml:"publicDns64Nat64Enabled"`
	// The string to use in IDs and elsewhere to identify resources for the public subnets and distinguish them from resources for the private subnets public.
	PublicLabel *string `field:"optional" json:"publicLabel" yaml:"publicLabel"`
	// If `true`, a single network ACL be created and it will be associated with every public subnet, and a rule will be created allowing all ingress and all egress.
	//
	// You can add additional rules to this network ACL
	// using the `aws_network_acl_rule` resource.
	// If `false`, you will need to manage the network ACL outside of this module.
	//
	// true.
	PublicOpenNetworkAclEnabled *bool `field:"optional" json:"publicOpenNetworkAclEnabled" yaml:"publicOpenNetworkAclEnabled"`
	// If `true`, network route table(s) will be created as determined by `public_route_table_per_subnet_enabled` and appropriate routes will be added to destinations this module knows about.
	//
	// If `false`, you will need to create your own route table(s) and route(s).
	// Ignored if `public_route_table_ids` is non-empty.
	//
	// true.
	PublicRouteTableEnabled *bool `field:"optional" json:"publicRouteTableEnabled" yaml:"publicRouteTableEnabled"`
	// List optionally containing the ID of a single route table shared by all public subnets or exactly one route table ID for each public subnet.
	//
	// If provided, it overrides `public_route_table_per_subnet_enabled`.
	// If omitted and `public_route_table_enabled` is `true`,
	// one or more network route tables will be created for the public subnets,
	// according to the setting of `public_route_table_per_subnet_enabled`.
	PublicRouteTableIds *[]*string `field:"optional" json:"publicRouteTableIds" yaml:"publicRouteTableIds"`
	// If `true` (and `public_route_table_enabled` is `true`), a separate network route table will be created for and associated with each public subnet.
	//
	// If `false` (and `public_route_table_enabled` is `true`), a single network route table will be created and it will be associated with every public subnet.
	// If not set, it will be set to the value of `public_dns64_nat64_enabled`.
	PublicRouteTablePerSubnetEnabled *bool `field:"optional" json:"publicRouteTablePerSubnetEnabled" yaml:"publicRouteTablePerSubnetEnabled"`
	// Additional tags to be added to public subnets The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}.
	PublicSubnetsAdditionalTags *map[string]*string `field:"optional" json:"publicSubnetsAdditionalTags" yaml:"publicSubnetsAdditionalTags"`
	// If false, do not create public subnets.
	//
	// Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
	//
	// true.
	PublicSubnetsEnabled *bool `field:"optional" json:"publicSubnetsEnabled" yaml:"publicSubnetsEnabled"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// DEPRECATED: use `nat_instance_root_block_device_encrypted` instead.
	//
	// Whether to encrypt the root block device on the created NAT instances.
	RootBlockDeviceEncrypted *bool `field:"optional" json:"rootBlockDeviceEncrypted" yaml:"rootBlockDeviceEncrypted"`
	// Time to wait for a network routing table entry to be created, specified as a Go Duration, e.g. `2m`. Use `null` for proivder default.
	RouteCreateTimeout *string `field:"optional" json:"routeCreateTimeout" yaml:"routeCreateTimeout"`
	// Time to wait for a network routing table entry to be deleted, specified as a Go Duration, e.g. `2m`. Use `null` for proivder default.
	RouteDeleteTimeout *string `field:"optional" json:"routeDeleteTimeout" yaml:"routeDeleteTimeout"`
	// ID element.
	//
	// Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'
	Stage *string `field:"optional" json:"stage" yaml:"stage"`
	// Time to wait for a subnet to be created, specified as a Go Duration, e.g. `2m`. Use `null` for proivder default.
	SubnetCreateTimeout *string `field:"optional" json:"subnetCreateTimeout" yaml:"subnetCreateTimeout"`
	// Time to wait for a subnet to be deleted, specified as a Go Duration, e.g. `5m`. Use `null` for proivder default.
	SubnetDeleteTimeout *string `field:"optional" json:"subnetDeleteTimeout" yaml:"subnetDeleteTimeout"`
	// The number of subnet of each type (public or private) to provision per Availability Zone.
	//
	// 1.
	SubnetsPerAzCount *float64 `field:"optional" json:"subnetsPerAzCount" yaml:"subnetsPerAzCount"`
	// The subnet names of each type (public or private) to provision per Availability Zone.
	//
	// This variable is optional.
	// If a list of names is provided, the list items will be used as keys in the outputs `named_private_subnets_map`, `named_public_subnets_map`,
	// `named_private_route_table_ids_map` and `named_public_route_table_ids_map`
	//
	// common.
	SubnetsPerAzNames *[]*string `field:"optional" json:"subnetsPerAzNames" yaml:"subnetsPerAzNames"`
	// DEPRECATED: Use `public_subnets_additional_tags` and `private_subnets_additional_tags` instead Key for subnet type tag to provide information about the type of subnets, e.g. `cpco.io/subnet/type: private` or `cpco.io/subnet/type: public`.
	SubnetTypeTagKey *string `field:"optional" json:"subnetTypeTagKey" yaml:"subnetTypeTagKey"`
	// DEPRECATED: Use `public_subnets_additional_tags` and `private_subnets_additional_tags` instead.
	//
	// The value of the `subnet_type_tag_key` will be set to `format(var.subnet_type_tag_value_format, <type>)`
	// where `<type>` is either `public` or `private`.
	//
	// %s.
	SubnetTypeTagValueFormat *string `field:"optional" json:"subnetTypeTagValueFormat" yaml:"subnetTypeTagValueFormat"`
	// Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	Tags *map[string]*string `field:"optional" json:"tags" yaml:"tags"`
	// ID element _(Rarely used, not included by default)_.
	//
	// A customer identifier, indicating who this instance of a resource is for.
	Tenant *string `field:"optional" json:"tenant" yaml:"tenant"`
}

