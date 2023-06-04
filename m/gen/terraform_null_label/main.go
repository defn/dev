// terraform_null_label
package terraform_null_label

import (
	"reflect"

	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
)

func init() {
	_jsii_.RegisterClass(
		"terraform_null_label.TerraformNullLabel",
		reflect.TypeOf((*TerraformNullLabel)(nil)).Elem(),
		[]_jsii_.Member{
			_jsii_.MemberProperty{JsiiProperty: "additionalTagMap", GoGetter: "AdditionalTagMap"},
			_jsii_.MemberProperty{JsiiProperty: "additionalTagMapOutput", GoGetter: "AdditionalTagMapOutput"},
			_jsii_.MemberMethod{JsiiMethod: "addOverride", GoMethod: "AddOverride"},
			_jsii_.MemberMethod{JsiiMethod: "addProvider", GoMethod: "AddProvider"},
			_jsii_.MemberProperty{JsiiProperty: "attributes", GoGetter: "Attributes"},
			_jsii_.MemberProperty{JsiiProperty: "attributesOutput", GoGetter: "AttributesOutput"},
			_jsii_.MemberProperty{JsiiProperty: "cdktfStack", GoGetter: "CdktfStack"},
			_jsii_.MemberProperty{JsiiProperty: "constructNodeMetadata", GoGetter: "ConstructNodeMetadata"},
			_jsii_.MemberProperty{JsiiProperty: "context", GoGetter: "Context"},
			_jsii_.MemberProperty{JsiiProperty: "contextOutput", GoGetter: "ContextOutput"},
			_jsii_.MemberProperty{JsiiProperty: "delimiter", GoGetter: "Delimiter"},
			_jsii_.MemberProperty{JsiiProperty: "delimiterOutput", GoGetter: "DelimiterOutput"},
			_jsii_.MemberProperty{JsiiProperty: "dependsOn", GoGetter: "DependsOn"},
			_jsii_.MemberProperty{JsiiProperty: "descriptorFormats", GoGetter: "DescriptorFormats"},
			_jsii_.MemberProperty{JsiiProperty: "descriptorsOutput", GoGetter: "DescriptorsOutput"},
			_jsii_.MemberProperty{JsiiProperty: "enabled", GoGetter: "Enabled"},
			_jsii_.MemberProperty{JsiiProperty: "enabledOutput", GoGetter: "EnabledOutput"},
			_jsii_.MemberProperty{JsiiProperty: "environment", GoGetter: "Environment"},
			_jsii_.MemberProperty{JsiiProperty: "environmentOutput", GoGetter: "EnvironmentOutput"},
			_jsii_.MemberProperty{JsiiProperty: "forEach", GoGetter: "ForEach"},
			_jsii_.MemberProperty{JsiiProperty: "fqn", GoGetter: "Fqn"},
			_jsii_.MemberProperty{JsiiProperty: "friendlyUniqueId", GoGetter: "FriendlyUniqueId"},
			_jsii_.MemberMethod{JsiiMethod: "getString", GoMethod: "GetString"},
			_jsii_.MemberProperty{JsiiProperty: "idFullOutput", GoGetter: "IdFullOutput"},
			_jsii_.MemberProperty{JsiiProperty: "idLengthLimit", GoGetter: "IdLengthLimit"},
			_jsii_.MemberProperty{JsiiProperty: "idLengthLimitOutput", GoGetter: "IdLengthLimitOutput"},
			_jsii_.MemberProperty{JsiiProperty: "idOutput", GoGetter: "IdOutput"},
			_jsii_.MemberMethod{JsiiMethod: "interpolationForOutput", GoMethod: "InterpolationForOutput"},
			_jsii_.MemberProperty{JsiiProperty: "labelKeyCase", GoGetter: "LabelKeyCase"},
			_jsii_.MemberProperty{JsiiProperty: "labelOrder", GoGetter: "LabelOrder"},
			_jsii_.MemberProperty{JsiiProperty: "labelOrderOutput", GoGetter: "LabelOrderOutput"},
			_jsii_.MemberProperty{JsiiProperty: "labelsAsTags", GoGetter: "LabelsAsTags"},
			_jsii_.MemberProperty{JsiiProperty: "labelValueCase", GoGetter: "LabelValueCase"},
			_jsii_.MemberProperty{JsiiProperty: "name", GoGetter: "Name"},
			_jsii_.MemberProperty{JsiiProperty: "nameOutput", GoGetter: "NameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "namespace", GoGetter: "Namespace"},
			_jsii_.MemberProperty{JsiiProperty: "namespaceOutput", GoGetter: "NamespaceOutput"},
			_jsii_.MemberProperty{JsiiProperty: "node", GoGetter: "Node"},
			_jsii_.MemberProperty{JsiiProperty: "normalizedContextOutput", GoGetter: "NormalizedContextOutput"},
			_jsii_.MemberMethod{JsiiMethod: "overrideLogicalId", GoMethod: "OverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "providers", GoGetter: "Providers"},
			_jsii_.MemberProperty{JsiiProperty: "rawOverrides", GoGetter: "RawOverrides"},
			_jsii_.MemberProperty{JsiiProperty: "regexReplaceChars", GoGetter: "RegexReplaceChars"},
			_jsii_.MemberProperty{JsiiProperty: "regexReplaceCharsOutput", GoGetter: "RegexReplaceCharsOutput"},
			_jsii_.MemberMethod{JsiiMethod: "resetOverrideLogicalId", GoMethod: "ResetOverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "skipAssetCreationFromLocalModules", GoGetter: "SkipAssetCreationFromLocalModules"},
			_jsii_.MemberProperty{JsiiProperty: "source", GoGetter: "Source"},
			_jsii_.MemberProperty{JsiiProperty: "stage", GoGetter: "Stage"},
			_jsii_.MemberProperty{JsiiProperty: "stageOutput", GoGetter: "StageOutput"},
			_jsii_.MemberMethod{JsiiMethod: "synthesizeAttributes", GoMethod: "SynthesizeAttributes"},
			_jsii_.MemberProperty{JsiiProperty: "tags", GoGetter: "Tags"},
			_jsii_.MemberProperty{JsiiProperty: "tagsAsListOfMapsOutput", GoGetter: "TagsAsListOfMapsOutput"},
			_jsii_.MemberProperty{JsiiProperty: "tagsOutput", GoGetter: "TagsOutput"},
			_jsii_.MemberProperty{JsiiProperty: "tenant", GoGetter: "Tenant"},
			_jsii_.MemberProperty{JsiiProperty: "tenantOutput", GoGetter: "TenantOutput"},
			_jsii_.MemberMethod{JsiiMethod: "toMetadata", GoMethod: "ToMetadata"},
			_jsii_.MemberMethod{JsiiMethod: "toString", GoMethod: "ToString"},
			_jsii_.MemberMethod{JsiiMethod: "toTerraform", GoMethod: "ToTerraform"},
			_jsii_.MemberProperty{JsiiProperty: "version", GoGetter: "Version"},
		},
		func() interface{} {
			j := jsiiProxy_TerraformNullLabel{}
			_jsii_.InitJsiiProxy(&j.Type__cdktfTerraformModule)
			return &j
		},
	)
	_jsii_.RegisterStruct(
		"terraform_null_label.TerraformNullLabelConfig",
		reflect.TypeOf((*TerraformNullLabelConfig)(nil)).Elem(),
	)
}
