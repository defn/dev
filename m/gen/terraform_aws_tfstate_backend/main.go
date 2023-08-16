// terraform_aws_tfstate_backend
package terraform_aws_tfstate_backend

import (
	"reflect"

	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
)

func init() {
	_jsii_.RegisterClass(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackend",
		reflect.TypeOf((*TerraformAwsTfstateBackend)(nil)).Elem(),
		[]_jsii_.Member{
			_jsii_.MemberProperty{JsiiProperty: "acl", GoGetter: "Acl"},
			_jsii_.MemberProperty{JsiiProperty: "additionalTagMap", GoGetter: "AdditionalTagMap"},
			_jsii_.MemberMethod{JsiiMethod: "addOverride", GoMethod: "AddOverride"},
			_jsii_.MemberMethod{JsiiMethod: "addProvider", GoMethod: "AddProvider"},
			_jsii_.MemberProperty{JsiiProperty: "arnFormat", GoGetter: "ArnFormat"},
			_jsii_.MemberProperty{JsiiProperty: "attributes", GoGetter: "Attributes"},
			_jsii_.MemberProperty{JsiiProperty: "billingMode", GoGetter: "BillingMode"},
			_jsii_.MemberProperty{JsiiProperty: "blockPublicAcls", GoGetter: "BlockPublicAcls"},
			_jsii_.MemberProperty{JsiiProperty: "blockPublicPolicy", GoGetter: "BlockPublicPolicy"},
			_jsii_.MemberProperty{JsiiProperty: "bucketEnabled", GoGetter: "BucketEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "bucketOwnershipEnforcedEnabled", GoGetter: "BucketOwnershipEnforcedEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "cdktfStack", GoGetter: "CdktfStack"},
			_jsii_.MemberProperty{JsiiProperty: "constructNodeMetadata", GoGetter: "ConstructNodeMetadata"},
			_jsii_.MemberProperty{JsiiProperty: "context", GoGetter: "Context"},
			_jsii_.MemberProperty{JsiiProperty: "delimiter", GoGetter: "Delimiter"},
			_jsii_.MemberProperty{JsiiProperty: "dependsOn", GoGetter: "DependsOn"},
			_jsii_.MemberProperty{JsiiProperty: "descriptorFormats", GoGetter: "DescriptorFormats"},
			_jsii_.MemberProperty{JsiiProperty: "dynamodbEnabled", GoGetter: "DynamodbEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "dynamodbTableArnOutput", GoGetter: "DynamodbTableArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "dynamodbTableIdOutput", GoGetter: "DynamodbTableIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "dynamodbTableName", GoGetter: "DynamodbTableName"},
			_jsii_.MemberProperty{JsiiProperty: "dynamodbTableNameOutput", GoGetter: "DynamodbTableNameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "enabled", GoGetter: "Enabled"},
			_jsii_.MemberProperty{JsiiProperty: "enablePointInTimeRecovery", GoGetter: "EnablePointInTimeRecovery"},
			_jsii_.MemberProperty{JsiiProperty: "enablePublicAccessBlock", GoGetter: "EnablePublicAccessBlock"},
			_jsii_.MemberProperty{JsiiProperty: "environment", GoGetter: "Environment"},
			_jsii_.MemberProperty{JsiiProperty: "forceDestroy", GoGetter: "ForceDestroy"},
			_jsii_.MemberProperty{JsiiProperty: "forEach", GoGetter: "ForEach"},
			_jsii_.MemberProperty{JsiiProperty: "fqn", GoGetter: "Fqn"},
			_jsii_.MemberProperty{JsiiProperty: "friendlyUniqueId", GoGetter: "FriendlyUniqueId"},
			_jsii_.MemberMethod{JsiiMethod: "getString", GoMethod: "GetString"},
			_jsii_.MemberProperty{JsiiProperty: "idLengthLimit", GoGetter: "IdLengthLimit"},
			_jsii_.MemberProperty{JsiiProperty: "ignorePublicAcls", GoGetter: "IgnorePublicAcls"},
			_jsii_.MemberMethod{JsiiMethod: "interpolationForOutput", GoMethod: "InterpolationForOutput"},
			_jsii_.MemberProperty{JsiiProperty: "labelKeyCase", GoGetter: "LabelKeyCase"},
			_jsii_.MemberProperty{JsiiProperty: "labelOrder", GoGetter: "LabelOrder"},
			_jsii_.MemberProperty{JsiiProperty: "labelsAsTags", GoGetter: "LabelsAsTags"},
			_jsii_.MemberProperty{JsiiProperty: "labelValueCase", GoGetter: "LabelValueCase"},
			_jsii_.MemberProperty{JsiiProperty: "logging", GoGetter: "Logging"},
			_jsii_.MemberProperty{JsiiProperty: "mfaDelete", GoGetter: "MfaDelete"},
			_jsii_.MemberProperty{JsiiProperty: "name", GoGetter: "Name"},
			_jsii_.MemberProperty{JsiiProperty: "namespace", GoGetter: "Namespace"},
			_jsii_.MemberProperty{JsiiProperty: "node", GoGetter: "Node"},
			_jsii_.MemberMethod{JsiiMethod: "overrideLogicalId", GoMethod: "OverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "permissionsBoundary", GoGetter: "PermissionsBoundary"},
			_jsii_.MemberProperty{JsiiProperty: "preventUnencryptedUploads", GoGetter: "PreventUnencryptedUploads"},
			_jsii_.MemberProperty{JsiiProperty: "profile", GoGetter: "Profile"},
			_jsii_.MemberProperty{JsiiProperty: "providers", GoGetter: "Providers"},
			_jsii_.MemberProperty{JsiiProperty: "rawOverrides", GoGetter: "RawOverrides"},
			_jsii_.MemberProperty{JsiiProperty: "readCapacity", GoGetter: "ReadCapacity"},
			_jsii_.MemberProperty{JsiiProperty: "regexReplaceChars", GoGetter: "RegexReplaceChars"},
			_jsii_.MemberMethod{JsiiMethod: "resetOverrideLogicalId", GoMethod: "ResetOverrideLogicalId"},
			_jsii_.MemberProperty{JsiiProperty: "restrictPublicBuckets", GoGetter: "RestrictPublicBuckets"},
			_jsii_.MemberProperty{JsiiProperty: "roleArn", GoGetter: "RoleArn"},
			_jsii_.MemberProperty{JsiiProperty: "s3BucketArnOutput", GoGetter: "S3BucketArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "s3BucketDomainNameOutput", GoGetter: "S3BucketDomainNameOutput"},
			_jsii_.MemberProperty{JsiiProperty: "s3BucketIdOutput", GoGetter: "S3BucketIdOutput"},
			_jsii_.MemberProperty{JsiiProperty: "s3BucketName", GoGetter: "S3BucketName"},
			_jsii_.MemberProperty{JsiiProperty: "s3ReplicaBucketArn", GoGetter: "S3ReplicaBucketArn"},
			_jsii_.MemberProperty{JsiiProperty: "s3ReplicationEnabled", GoGetter: "S3ReplicationEnabled"},
			_jsii_.MemberProperty{JsiiProperty: "s3ReplicationRoleArnOutput", GoGetter: "S3ReplicationRoleArnOutput"},
			_jsii_.MemberProperty{JsiiProperty: "skipAssetCreationFromLocalModules", GoGetter: "SkipAssetCreationFromLocalModules"},
			_jsii_.MemberProperty{JsiiProperty: "source", GoGetter: "Source"},
			_jsii_.MemberProperty{JsiiProperty: "stage", GoGetter: "Stage"},
			_jsii_.MemberMethod{JsiiMethod: "synthesizeAttributes", GoMethod: "SynthesizeAttributes"},
			_jsii_.MemberProperty{JsiiProperty: "tags", GoGetter: "Tags"},
			_jsii_.MemberProperty{JsiiProperty: "tenant", GoGetter: "Tenant"},
			_jsii_.MemberProperty{JsiiProperty: "terraformBackendConfigFileName", GoGetter: "TerraformBackendConfigFileName"},
			_jsii_.MemberProperty{JsiiProperty: "terraformBackendConfigFilePath", GoGetter: "TerraformBackendConfigFilePath"},
			_jsii_.MemberProperty{JsiiProperty: "terraformBackendConfigOutput", GoGetter: "TerraformBackendConfigOutput"},
			_jsii_.MemberProperty{JsiiProperty: "terraformBackendConfigTemplateFile", GoGetter: "TerraformBackendConfigTemplateFile"},
			_jsii_.MemberProperty{JsiiProperty: "terraformStateFile", GoGetter: "TerraformStateFile"},
			_jsii_.MemberProperty{JsiiProperty: "terraformVersion", GoGetter: "TerraformVersion"},
			_jsii_.MemberMethod{JsiiMethod: "toMetadata", GoMethod: "ToMetadata"},
			_jsii_.MemberMethod{JsiiMethod: "toString", GoMethod: "ToString"},
			_jsii_.MemberMethod{JsiiMethod: "toTerraform", GoMethod: "ToTerraform"},
			_jsii_.MemberProperty{JsiiProperty: "version", GoGetter: "Version"},
			_jsii_.MemberProperty{JsiiProperty: "writeCapacity", GoGetter: "WriteCapacity"},
		},
		func() interface{} {
			j := jsiiProxy_TerraformAwsTfstateBackend{}
			_jsii_.InitJsiiProxy(&j.Type__cdktfTerraformModule)
			return &j
		},
	)
	_jsii_.RegisterStruct(
		"terraform_aws_tfstate_backend.TerraformAwsTfstateBackendConfig",
		reflect.TypeOf((*TerraformAwsTfstateBackendConfig)(nil)).Elem(),
	)
}
