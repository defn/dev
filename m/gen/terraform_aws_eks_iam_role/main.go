// terraform_aws_eks_iam_role
package terraform_aws_eks_iam_role

import (
	"reflect"

	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
)

func init() {
	_jsii_.RegisterClass(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRole",
		reflect.TypeOf((*TerraformAwsEksIamRole)(nil)).Elem(),
		[]_jsii_.Member{
			_jsii_.MemberProperty{JsiiProperty: "additionalTagMap", GoGetter: "AdditionalTagMap"},
			_jsii_.MemberMethod{JsiiMethod: "addOverride", GoMethod: "AddOverride"},
			_jsii_.MemberMethod{JsiiMethod: "addProvider", GoMethod: "AddProvider"},
			_jsii_.MemberProperty{JsiiProperty: "attributes", GoGetter: "Attributes"},
			_jsii_.MemberProperty{JsiiProperty: "awsAccountNumber", GoGetter: "AwsAccountNumber"},
			_jsii_.MemberProperty{JsiiProperty: "awsIamPolicyDocument", GoGetter: "AwsIamPolicyDocument"},
			_jsii_.MemberProperty{JsiiProperty: "awsPartition", GoGetter: "AwsPartition"},
			_jsii_.MemberProperty{JsiiProperty: "cdktfStack", GoGetter: "CdktfStack"},
			_jsii_.MemberProperty{JsiiProperty: "constructNodeMetadata", GoGetter: "ConstructNodeMetadata"},
			_jsii_.MemberProperty{JsiiProperty: "context", GoGetter: "Context"},
			_jsii_.MemberProperty{JsiiProperty: "delimiter", GoGetter: "Delimiter"},
			_jsii_.MemberProperty{JsiiProperty: "dependsOn", GoGetter: "DependsOn"},
			_jsii_.MemberProperty{JsiiProperty: "descriptorFormats", GoGetter: "DescriptorFormats"},
			_jsii_.MemberProperty{JsiiProperty: "eksClusterOidcIssuerUrl", GoGetter: "EksClusterOidcIssuerUrl"},
			_jsii_.MemberProperty{JsiiProperty: "enabled", GoGetter: "Enabled"},
			_jsii_.MemberProperty{JsiiProperty: "environment", GoGetter: "Environment"},
			_jsii_.MemberProperty{JsiiProperty: "forEach", GoGetter: "ForEach"},
			_jsii_.MemberProperty{JsiiProperty: "fqn", GoGetter: "Fqn"},
			_jsii_.MemberProperty{JsiiProperty: "friendlyUniqueId", GoGetter: "FriendlyUniqueId"},
			_jsii_.MemberMethod{JsiiMethod: "getString", GoMethod: "GetString"},
			_jsii_.MemberProperty{JsiiProperty: "idLengthLimit", GoGetter: "IdLengthLimit"},
			_jsii_.MemberMethod{JsiiMethod: "interpolationForOutput", GoMethod: "InterpolationForOutput"},
			_jsii_.MemberProperty{JsiiProperty: "labelKeyCase", GoGetter: "LabelKeyCase"},
			_jsii_.MemberProperty{JsiiProperty: "labelOrder", GoGetter: "LabelOrder"},
			_jsii_.MemberProperty{JsiiProperty: "labelsAsTags", GoGetter: "LabelsAsTags"},
			_jsii_.MemberProperty{JsiiProperty: "labelValueCase", GoGetter: "LabelValueCase"},
			_jsii_.MemberProperty{JsiiProperty: "name", GoGetter: "Name"},
			_jsii_.MemberProperty{JsiiProperty: "namespace", GoGetter: "Namespace"},
			_jsii_.MemberProperty{JsiiProperty: "node", GoGetter: "Node"},
			_jsii_.MemberMethod{JsiiMethod: "overrideLogicalId", GoMethod: "OverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "permissionsBoundary", GoGetter: "PermissionsBoundary"},
			_jsii_.MemberProperty{JsiiProperty: "providers", GoGetter: "Providers"},
			_jsii_.MemberProperty{JsiiProperty: "rawOverrides", GoGetter: "RawOverrides"},
			_jsii_.MemberProperty{JsiiProperty: "regexReplaceChars", GoGetter: "RegexReplaceChars"},
			_jsii_.MemberMethod{JsiiMethod: "resetOverrideLogicalId", GoMethod: "ResetOverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountListQualifier", GoGetter: "ServiceAccountListQualifier"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountName", GoGetter: "ServiceAccountName"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountNameOutput", GoGetter: "ServiceAccountNameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountNamespace", GoGetter: "ServiceAccountNamespace"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountNamespaceNameList", GoGetter: "ServiceAccountNamespaceNameList"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountNamespaceOutput", GoGetter: "ServiceAccountNamespaceOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountPolicyArnOutput", GoGetter: "ServiceAccountPolicyArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountPolicyIdOutput", GoGetter: "ServiceAccountPolicyIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountPolicyNameOutput", GoGetter: "ServiceAccountPolicyNameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountRoleArnOutput", GoGetter: "ServiceAccountRoleArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountRoleNameOutput", GoGetter: "ServiceAccountRoleNameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "serviceAccountRoleUniqueIdOutput", GoGetter: "ServiceAccountRoleUniqueIdOutput"},
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
		},
		func() interface{} {
			j := jsiiProxy_TerraformAwsEksIamRole{}
			_jsii_.InitJsiiProxy(&j.Type__cdktfTerraformModule)
			return &j
		},
	)
	_jsii_.RegisterStruct(
		"terraform_aws_eks_iam_role.TerraformAwsEksIamRoleConfig",
		reflect.TypeOf((*TerraformAwsEksIamRoleConfig)(nil)).Elem(),
	)
}
