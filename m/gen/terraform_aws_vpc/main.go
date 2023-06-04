// terraform_aws_vpc
package terraform_aws_vpc

import (
	"reflect"

	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
)

func init() {
	_jsii_.RegisterClass(
		"terraform_aws_vpc.TerraformAwsVpc",
		reflect.TypeOf((*TerraformAwsVpc)(nil)).Elem(),
		[]_jsii_.Member{
			_jsii_.MemberProperty{JsiiProperty: "additionalCidrBlocksOutput", GoGetter: "AdditionalCidrBlocksOutput"},
			_jsii_.MemberProperty{JsiiProperty: "additionalCidrBlocksToAssociationIdsOutput", GoGetter: "AdditionalCidrBlocksToAssociationIdsOutput"},
			_jsii_.MemberProperty{JsiiProperty: "additionalIpv6CidrBlocksOutput", GoGetter: "AdditionalIpv6CidrBlocksOutput"},
			_jsii_.MemberProperty{JsiiProperty: "additionalIpv6CidrBlocksToAssociationIdsOutput", GoGetter: "AdditionalIpv6CidrBlocksToAssociationIdsOutput"},
			_jsii_.MemberProperty{JsiiProperty: "additionalTagMap", GoGetter: "AdditionalTagMap"},
			_jsii_.MemberMethod{JsiiMethod: "addOverride", GoMethod: "AddOverride"},
			_jsii_.MemberMethod{JsiiMethod: "addProvider", GoMethod: "AddProvider"},
			_jsii_.MemberProperty{JsiiProperty: "assignGeneratedIpv6CidrBlock", GoGetter: "AssignGeneratedIpv6CidrBlock"},
			_jsii_.MemberProperty{JsiiProperty: "attributes", GoGetter: "Attributes"},
			_jsii_.MemberProperty{JsiiProperty: "cdktfStack", GoGetter: "CdktfStack"},
			_jsii_.MemberProperty{JsiiProperty: "constructNodeMetadata", GoGetter: "ConstructNodeMetadata"},
			_jsii_.MemberProperty{JsiiProperty: "context", GoGetter: "Context"},
			_jsii_.MemberProperty{JsiiProperty: "defaultNetworkAclDenyAll", GoGetter: "DefaultNetworkAclDenyAll"},
			_jsii_.MemberProperty{JsiiProperty: "defaultRouteTableNoRoutes", GoGetter: "DefaultRouteTableNoRoutes"},
			_jsii_.MemberProperty{JsiiProperty: "defaultSecurityGroupDenyAll", GoGetter: "DefaultSecurityGroupDenyAll"},
			_jsii_.MemberProperty{JsiiProperty: "delimiter", GoGetter: "Delimiter"},
			_jsii_.MemberProperty{JsiiProperty: "dependsOn", GoGetter: "DependsOn"},
			_jsii_.MemberProperty{JsiiProperty: "descriptorFormats", GoGetter: "DescriptorFormats"},
			_jsii_.MemberProperty{JsiiProperty: "dnsHostnamesEnabled", GoGetter: "DnsHostnamesEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "dnsSupportEnabled", GoGetter: "DnsSupportEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "enabled", GoGetter: "Enabled"},
			_jsii_.MemberProperty{JsiiProperty: "environment", GoGetter: "Environment"},
			_jsii_.MemberProperty{JsiiProperty: "forEach", GoGetter: "ForEach"},
			_jsii_.MemberProperty{JsiiProperty: "fqn", GoGetter: "Fqn"},
			_jsii_.MemberProperty{JsiiProperty: "friendlyUniqueId", GoGetter: "FriendlyUniqueId"},
			_jsii_.MemberMethod{JsiiMethod: "getString", GoMethod: "GetString"},
			_jsii_.MemberProperty{JsiiProperty: "idLengthLimit", GoGetter: "IdLengthLimit"},
			_jsii_.MemberProperty{JsiiProperty: "igwIdOutput", GoGetter: "IgwIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "instanceTenancy", GoGetter: "InstanceTenancy"},
			_jsii_.MemberProperty{JsiiProperty: "internetGatewayEnabled", GoGetter: "InternetGatewayEnabled"},
			_jsii_.MemberMethod{JsiiMethod: "interpolationForOutput", GoMethod: "InterpolationForOutput"},
			_jsii_.MemberProperty{JsiiProperty: "ipv4AdditionalCidrBlockAssociations", GoGetter: "Ipv4AdditionalCidrBlockAssociations"},
			_jsii_.MemberProperty{JsiiProperty: "ipv4CidrBlockAssociationTimeouts", GoGetter: "Ipv4CidrBlockAssociationTimeouts"},
			_jsii_.MemberProperty{JsiiProperty: "ipv4PrimaryCidrBlock", GoGetter: "Ipv4PrimaryCidrBlock"},
			_jsii_.MemberProperty{JsiiProperty: "ipv4PrimaryCidrBlockAssociation", GoGetter: "Ipv4PrimaryCidrBlockAssociation"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6AdditionalCidrBlockAssociations", GoGetter: "Ipv6AdditionalCidrBlockAssociations"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6CidrBlockAssociationTimeouts", GoGetter: "Ipv6CidrBlockAssociationTimeouts"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6CidrBlockNetworkBorderGroup", GoGetter: "Ipv6CidrBlockNetworkBorderGroup"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6CidrBlockNetworkBorderGroupOutput", GoGetter: "Ipv6CidrBlockNetworkBorderGroupOutput"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6EgressOnlyIgwIdOutput", GoGetter: "Ipv6EgressOnlyIgwIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6EgressOnlyInternetGatewayEnabled", GoGetter: "Ipv6EgressOnlyInternetGatewayEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "ipv6PrimaryCidrBlockAssociation", GoGetter: "Ipv6PrimaryCidrBlockAssociation"},
			_jsii_.MemberProperty{JsiiProperty: "labelKeyCase", GoGetter: "LabelKeyCase"},
			_jsii_.MemberProperty{JsiiProperty: "labelOrder", GoGetter: "LabelOrder"},
			_jsii_.MemberProperty{JsiiProperty: "labelsAsTags", GoGetter: "LabelsAsTags"},
			_jsii_.MemberProperty{JsiiProperty: "labelValueCase", GoGetter: "LabelValueCase"},
			_jsii_.MemberProperty{JsiiProperty: "name", GoGetter: "Name"},
			_jsii_.MemberProperty{JsiiProperty: "namespace", GoGetter: "Namespace"},
			_jsii_.MemberProperty{JsiiProperty: "node", GoGetter: "Node"},
			_jsii_.MemberMethod{JsiiMethod: "overrideLogicalId", GoMethod: "OverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "providers", GoGetter: "Providers"},
			_jsii_.MemberProperty{JsiiProperty: "rawOverrides", GoGetter: "RawOverrides"},
			_jsii_.MemberProperty{JsiiProperty: "regexReplaceChars", GoGetter: "RegexReplaceChars"},
			_jsii_.MemberMethod{JsiiMethod: "resetOverrideLogicalId", GoMethod: "ResetOverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "skipAssetCreationFromLocalModules", GoGetter: "SkipAssetCreationFromLocalModules"},
			_jsii_.MemberProperty{JsiiProperty: "source", GoGetter: "Source"},
			_jsii_.MemberProperty{JsiiProperty: "stage", GoGetter: "Stage"},
			_jsii_.MemberMethod{JsiiMethod: "synthesizeAttributes", GoMethod: "SynthesizeAttributes"},
			_jsii_.MemberProperty{JsiiProperty: "tags", GoGetter: "Tags"},
			_jsii_.MemberProperty{JsiiProperty: "tenant", GoGetter: "Tenant"},
			_jsii_.MemberMethod{JsiiMethod: "toMetadata", GoMethod: "ToMetadata"},
			_jsii_.MemberMethod{JsiiMethod: "toString", GoMethod: "ToString"},
			_jsii_.MemberMethod{JsiiMethod: "toTerraform", GoMethod: "ToTerraform"},
			_jsii_.MemberProperty{JsiiProperty: "version", GoGetter: "Version"},
			_jsii_.MemberProperty{JsiiProperty: "vpcArnOutput", GoGetter: "VpcArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcCidrBlockOutput", GoGetter: "VpcCidrBlockOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcDefaultNetworkAclIdOutput", GoGetter: "VpcDefaultNetworkAclIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcDefaultRouteTableIdOutput", GoGetter: "VpcDefaultRouteTableIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcDefaultSecurityGroupIdOutput", GoGetter: "VpcDefaultSecurityGroupIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcIdOutput", GoGetter: "VpcIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcIpv6AssociationIdOutput", GoGetter: "VpcIpv6AssociationIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcIpv6CidrBlockOutput", GoGetter: "VpcIpv6CidrBlockOutput"},
			_jsii_.MemberProperty{JsiiProperty: "vpcMainRouteTableIdOutput", GoGetter: "VpcMainRouteTableIdOutput"},
		},
		func() interface{} {
			j := jsiiProxy_TerraformAwsVpc{}
			_jsii_.InitJsiiProxy(&j.Type__cdktfTerraformModule)
			return &j
		},
	)
	_jsii_.RegisterStruct(
		"terraform_aws_vpc.TerraformAwsVpcConfig",
		reflect.TypeOf((*TerraformAwsVpcConfig)(nil)).Elem(),
	)
}
