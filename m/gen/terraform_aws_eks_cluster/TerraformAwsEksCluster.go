package terraform_aws_eks_cluster

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/gen/terraform_aws_eks_cluster/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/gen/terraform_aws_eks_cluster/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsEksCluster based on a Terraform module.
//
// Source at ./tf/mod/terraform-aws-eks-cluster
type TerraformAwsEksCluster interface {
	cdktf.TerraformModule
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	Addons() interface{}
	SetAddons(val interface{})
	AddonsDependsOn() interface{}
	SetAddonsDependsOn(val interface{})
	AllowedCidrBlocks() *[]*string
	SetAllowedCidrBlocks(val *[]*string)
	AllowedSecurityGroupIds() *[]*string
	SetAllowedSecurityGroupIds(val *[]*string)
	AllowedSecurityGroups() *[]*string
	SetAllowedSecurityGroups(val *[]*string)
	ApplyConfigMapAwsAuth() *bool
	SetApplyConfigMapAwsAuth(val *bool)
	AssociatedSecurityGroupIds() *[]*string
	SetAssociatedSecurityGroupIds(val *[]*string)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	AwsAuthYamlStripQuotes() *bool
	SetAwsAuthYamlStripQuotes(val *bool)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	CloudwatchLogGroupKmsKeyId() *string
	SetCloudwatchLogGroupKmsKeyId(val *string)
	CloudwatchLogGroupKmsKeyIdOutput() *string
	CloudwatchLogGroupNameOutput() *string
	ClusterAttributes() *[]*string
	SetClusterAttributes(val *[]*string)
	ClusterDependsOn() interface{}
	SetClusterDependsOn(val interface{})
	ClusterEncryptionConfigEnabled() *bool
	SetClusterEncryptionConfigEnabled(val *bool)
	ClusterEncryptionConfigEnabledOutput() *string
	ClusterEncryptionConfigKmsKeyDeletionWindowInDays() *float64
	SetClusterEncryptionConfigKmsKeyDeletionWindowInDays(val *float64)
	ClusterEncryptionConfigKmsKeyEnableKeyRotation() *bool
	SetClusterEncryptionConfigKmsKeyEnableKeyRotation(val *bool)
	ClusterEncryptionConfigKmsKeyId() *string
	SetClusterEncryptionConfigKmsKeyId(val *string)
	ClusterEncryptionConfigKmsKeyPolicy() *string
	SetClusterEncryptionConfigKmsKeyPolicy(val *string)
	ClusterEncryptionConfigProviderKeyAliasOutput() *string
	ClusterEncryptionConfigProviderKeyArnOutput() *string
	ClusterEncryptionConfigResources() *[]interface{}
	SetClusterEncryptionConfigResources(val *[]interface{})
	ClusterEncryptionConfigResourcesOutput() *string
	ClusterLogRetentionPeriod() *float64
	SetClusterLogRetentionPeriod(val *float64)
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	CreateEksServiceRole() *bool
	SetCreateEksServiceRole(val *bool)
	CreateSecurityGroup() *bool
	SetCreateSecurityGroup(val *bool)
	CustomIngressRules() interface{}
	SetCustomIngressRules(val interface{})
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DummyKubeapiServer() *string
	SetDummyKubeapiServer(val *string)
	EksClusterArnOutput() *string
	EksClusterCertificateAuthorityDataOutput() *string
	EksClusterEndpointOutput() *string
	EksClusterIdentityOidcIssuerArnOutput() *string
	EksClusterIdentityOidcIssuerOutput() *string
	EksClusterIdOutput() *string
	EksClusterManagedSecurityGroupIdOutput() *string
	EksClusterRoleArnOutput() *string
	EksClusterServiceRoleArn() *string
	SetEksClusterServiceRoleArn(val *string)
	EksClusterVersionOutput() *string
	Enabled() *bool
	SetEnabled(val *bool)
	EnabledClusterLogTypes() *[]*string
	SetEnabledClusterLogTypes(val *[]*string)
	EndpointPrivateAccess() *bool
	SetEndpointPrivateAccess(val *bool)
	EndpointPublicAccess() *bool
	SetEndpointPublicAccess(val *bool)
	Environment() *string
	SetEnvironment(val *string)
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	KubeconfigContext() *string
	SetKubeconfigContext(val *string)
	KubeconfigPath() *string
	SetKubeconfigPath(val *string)
	KubeconfigPathEnabled() *bool
	SetKubeconfigPathEnabled(val *bool)
	KubeDataAuthEnabled() *bool
	SetKubeDataAuthEnabled(val *bool)
	KubeExecAuthAwsProfile() *string
	SetKubeExecAuthAwsProfile(val *string)
	KubeExecAuthAwsProfileEnabled() *bool
	SetKubeExecAuthAwsProfileEnabled(val *bool)
	KubeExecAuthEnabled() *bool
	SetKubeExecAuthEnabled(val *bool)
	KubeExecAuthRoleArn() *string
	SetKubeExecAuthRoleArn(val *string)
	KubeExecAuthRoleArnEnabled() *bool
	SetKubeExecAuthRoleArnEnabled(val *bool)
	KubernetesConfigMapIdOutput() *string
	KubernetesConfigMapIgnoreRoleChanges() *bool
	SetKubernetesConfigMapIgnoreRoleChanges(val *bool)
	KubernetesNetworkIpv6Enabled() *bool
	SetKubernetesNetworkIpv6Enabled(val *bool)
	KubernetesVersion() *string
	SetKubernetesVersion(val *string)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LocalExecInterpreter() *[]*string
	SetLocalExecInterpreter(val *[]*string)
	ManagedSecurityGroupRulesEnabled() *bool
	SetManagedSecurityGroupRulesEnabled(val *bool)
	MapAdditionalAwsAccounts() *[]*string
	SetMapAdditionalAwsAccounts(val *[]*string)
	MapAdditionalIamRoles() interface{}
	SetMapAdditionalIamRoles(val interface{})
	MapAdditionalIamUsers() interface{}
	SetMapAdditionalIamUsers(val interface{})
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	OidcProviderEnabled() *bool
	SetOidcProviderEnabled(val *bool)
	PermissionsBoundary() *string
	SetPermissionsBoundary(val *string)
	// Experimental.
	Providers() *[]interface{}
	PublicAccessCidrs() *[]*string
	SetPublicAccessCidrs(val *[]*string)
	// Experimental.
	RawOverrides() interface{}
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	Region() *string
	SetRegion(val *string)
	SecurityGroupArnOutput() *string
	SecurityGroupIdOutput() *string
	SecurityGroupNameOutput() *string
	ServiceIpv4Cidr() *string
	SetServiceIpv4Cidr(val *string)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	SubnetIds() *[]*string
	SetSubnetIds(val *[]*string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	// Experimental.
	Version() *string
	VpcId() *string
	SetVpcId(val *string)
	WaitForClusterCommand() *string
	SetWaitForClusterCommand(val *string)
	WorkersRoleArns() *[]*string
	SetWorkersRoleArns(val *[]*string)
	WorkersSecurityGroupIds() *[]*string
	SetWorkersSecurityGroupIds(val *[]*string)
	// Experimental.
	AddOverride(path *string, value interface{})
	// Experimental.
	AddProvider(provider interface{})
	// Experimental.
	GetString(output *string) *string
	// Experimental.
	InterpolationForOutput(moduleOutput *string) cdktf.IResolvable
	// Overrides the auto-generated logical ID with a specific ID.
	// Experimental.
	OverrideLogicalId(newLogicalId *string)
	// Resets a previously passed logical Id to use the auto-generated logical id again.
	// Experimental.
	ResetOverrideLogicalId()
	SynthesizeAttributes() *map[string]interface{}
	SynthesizeHclAttributes() *map[string]interface{}
	// Experimental.
	ToHclTerraform() interface{}
	// Experimental.
	ToMetadata() interface{}
	// Returns a string representation of this construct.
	ToString() *string
	// Experimental.
	ToTerraform() interface{}
}

// The jsii proxy struct for TerraformAwsEksCluster
type jsiiProxy_TerraformAwsEksCluster struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsEksCluster) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Addons() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"addons",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AddonsDependsOn() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"addonsDependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AllowedCidrBlocks() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedCidrBlocks",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AllowedSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedSecurityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AllowedSecurityGroups() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedSecurityGroups",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ApplyConfigMapAwsAuth() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"applyConfigMapAwsAuth",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AssociatedSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"associatedSecurityGroupIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) AwsAuthYamlStripQuotes() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"awsAuthYamlStripQuotes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CloudwatchLogGroupKmsKeyId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudwatchLogGroupKmsKeyId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CloudwatchLogGroupKmsKeyIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudwatchLogGroupKmsKeyIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CloudwatchLogGroupNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudwatchLogGroupNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterAttributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"clusterAttributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterDependsOn() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"clusterDependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"clusterEncryptionConfigEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigEnabledOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigEnabledOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigKmsKeyDeletionWindowInDays() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"clusterEncryptionConfigKmsKeyDeletionWindowInDays",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigKmsKeyEnableKeyRotation() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"clusterEncryptionConfigKmsKeyEnableKeyRotation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigKmsKeyId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigKmsKeyId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigKmsKeyPolicy() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigKmsKeyPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigProviderKeyAliasOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigProviderKeyAliasOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigProviderKeyArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigProviderKeyArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigResources() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"clusterEncryptionConfigResources",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterEncryptionConfigResourcesOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"clusterEncryptionConfigResourcesOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ClusterLogRetentionPeriod() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"clusterLogRetentionPeriod",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CreateEksServiceRole() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"createEksServiceRole",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CreateSecurityGroup() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"createSecurityGroup",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) CustomIngressRules() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"customIngressRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) DummyKubeapiServer() *string {
	var returns *string
	_jsii_.Get(
		j,
		"dummyKubeapiServer",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterCertificateAuthorityDataOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterCertificateAuthorityDataOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterEndpointOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterEndpointOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterIdentityOidcIssuerArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterIdentityOidcIssuerArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterIdentityOidcIssuerOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterIdentityOidcIssuerOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterManagedSecurityGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterManagedSecurityGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterRoleArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterRoleArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterServiceRoleArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterServiceRoleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EksClusterVersionOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"eksClusterVersionOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EnabledClusterLogTypes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"enabledClusterLogTypes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EndpointPrivateAccess() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"endpointPrivateAccess",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) EndpointPublicAccess() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"endpointPublicAccess",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeconfigContext() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubeconfigContext",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeconfigPath() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubeconfigPath",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeconfigPathEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubeconfigPathEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeDataAuthEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubeDataAuthEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeExecAuthAwsProfile() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubeExecAuthAwsProfile",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeExecAuthAwsProfileEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubeExecAuthAwsProfileEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeExecAuthEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubeExecAuthEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeExecAuthRoleArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubeExecAuthRoleArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubeExecAuthRoleArnEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubeExecAuthRoleArnEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubernetesConfigMapIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubernetesConfigMapIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubernetesConfigMapIgnoreRoleChanges() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubernetesConfigMapIgnoreRoleChanges",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubernetesNetworkIpv6Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"kubernetesNetworkIpv6Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) KubernetesVersion() *string {
	var returns *string
	_jsii_.Get(
		j,
		"kubernetesVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) LocalExecInterpreter() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"localExecInterpreter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ManagedSecurityGroupRulesEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"managedSecurityGroupRulesEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) MapAdditionalAwsAccounts() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"mapAdditionalAwsAccounts",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) MapAdditionalIamRoles() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"mapAdditionalIamRoles",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) MapAdditionalIamUsers() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"mapAdditionalIamUsers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) OidcProviderEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"oidcProviderEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) PermissionsBoundary() *string {
	var returns *string
	_jsii_.Get(
		j,
		"permissionsBoundary",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) PublicAccessCidrs() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"publicAccessCidrs",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Region() *string {
	var returns *string
	_jsii_.Get(
		j,
		"region",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) SecurityGroupArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) SecurityGroupIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) SecurityGroupNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"securityGroupNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) ServiceIpv4Cidr() *string {
	var returns *string
	_jsii_.Get(
		j,
		"serviceIpv4Cidr",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) SubnetIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"subnetIds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) VpcId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"vpcId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) WaitForClusterCommand() *string {
	var returns *string
	_jsii_.Get(
		j,
		"waitForClusterCommand",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) WorkersRoleArns() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"workersRoleArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsEksCluster) WorkersSecurityGroupIds() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"workersSecurityGroupIds",
		&returns,
	)
	return returns
}


func NewTerraformAwsEksCluster(scope constructs.Construct, id *string, config *TerraformAwsEksClusterConfig) TerraformAwsEksCluster {
	_init_.Initialize()

	if err := validateNewTerraformAwsEksClusterParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsEksCluster{}

	_jsii_.Create(
		"terraform_aws_eks_cluster.TerraformAwsEksCluster",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsEksCluster_Override(t TerraformAwsEksCluster, scope constructs.Construct, id *string, config *TerraformAwsEksClusterConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_eks_cluster.TerraformAwsEksCluster",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAddons(val interface{}) {
	if err := j.validateSetAddonsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"addons",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAddonsDependsOn(val interface{}) {
	if err := j.validateSetAddonsDependsOnParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"addonsDependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAllowedCidrBlocks(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedCidrBlocks",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAllowedSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedSecurityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAllowedSecurityGroups(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedSecurityGroups",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetApplyConfigMapAwsAuth(val *bool) {
	_jsii_.Set(
		j,
		"applyConfigMapAwsAuth",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAssociatedSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"associatedSecurityGroupIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetAwsAuthYamlStripQuotes(val *bool) {
	_jsii_.Set(
		j,
		"awsAuthYamlStripQuotes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetCloudwatchLogGroupKmsKeyId(val *string) {
	_jsii_.Set(
		j,
		"cloudwatchLogGroupKmsKeyId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"clusterAttributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterDependsOn(val interface{}) {
	if err := j.validateSetClusterDependsOnParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"clusterDependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigEnabled(val *bool) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigKmsKeyDeletionWindowInDays(val *float64) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigKmsKeyDeletionWindowInDays",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigKmsKeyEnableKeyRotation(val *bool) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigKmsKeyEnableKeyRotation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigKmsKeyId(val *string) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigKmsKeyId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigKmsKeyPolicy(val *string) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigKmsKeyPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterEncryptionConfigResources(val *[]interface{}) {
	_jsii_.Set(
		j,
		"clusterEncryptionConfigResources",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetClusterLogRetentionPeriod(val *float64) {
	_jsii_.Set(
		j,
		"clusterLogRetentionPeriod",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetCreateEksServiceRole(val *bool) {
	_jsii_.Set(
		j,
		"createEksServiceRole",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetCreateSecurityGroup(val *bool) {
	_jsii_.Set(
		j,
		"createSecurityGroup",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetCustomIngressRules(val interface{}) {
	if err := j.validateSetCustomIngressRulesParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"customIngressRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetDummyKubeapiServer(val *string) {
	_jsii_.Set(
		j,
		"dummyKubeapiServer",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEksClusterServiceRoleArn(val *string) {
	_jsii_.Set(
		j,
		"eksClusterServiceRoleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEnabledClusterLogTypes(val *[]*string) {
	_jsii_.Set(
		j,
		"enabledClusterLogTypes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEndpointPrivateAccess(val *bool) {
	_jsii_.Set(
		j,
		"endpointPrivateAccess",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEndpointPublicAccess(val *bool) {
	_jsii_.Set(
		j,
		"endpointPublicAccess",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeconfigContext(val *string) {
	_jsii_.Set(
		j,
		"kubeconfigContext",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeconfigPath(val *string) {
	_jsii_.Set(
		j,
		"kubeconfigPath",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeconfigPathEnabled(val *bool) {
	_jsii_.Set(
		j,
		"kubeconfigPathEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeDataAuthEnabled(val *bool) {
	_jsii_.Set(
		j,
		"kubeDataAuthEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeExecAuthAwsProfile(val *string) {
	_jsii_.Set(
		j,
		"kubeExecAuthAwsProfile",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeExecAuthAwsProfileEnabled(val *bool) {
	_jsii_.Set(
		j,
		"kubeExecAuthAwsProfileEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeExecAuthEnabled(val *bool) {
	_jsii_.Set(
		j,
		"kubeExecAuthEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeExecAuthRoleArn(val *string) {
	_jsii_.Set(
		j,
		"kubeExecAuthRoleArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubeExecAuthRoleArnEnabled(val *bool) {
	_jsii_.Set(
		j,
		"kubeExecAuthRoleArnEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubernetesConfigMapIgnoreRoleChanges(val *bool) {
	_jsii_.Set(
		j,
		"kubernetesConfigMapIgnoreRoleChanges",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubernetesNetworkIpv6Enabled(val *bool) {
	_jsii_.Set(
		j,
		"kubernetesNetworkIpv6Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetKubernetesVersion(val *string) {
	_jsii_.Set(
		j,
		"kubernetesVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetLocalExecInterpreter(val *[]*string) {
	_jsii_.Set(
		j,
		"localExecInterpreter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetManagedSecurityGroupRulesEnabled(val *bool) {
	_jsii_.Set(
		j,
		"managedSecurityGroupRulesEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetMapAdditionalAwsAccounts(val *[]*string) {
	_jsii_.Set(
		j,
		"mapAdditionalAwsAccounts",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetMapAdditionalIamRoles(val interface{}) {
	if err := j.validateSetMapAdditionalIamRolesParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"mapAdditionalIamRoles",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetMapAdditionalIamUsers(val interface{}) {
	if err := j.validateSetMapAdditionalIamUsersParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"mapAdditionalIamUsers",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetOidcProviderEnabled(val *bool) {
	_jsii_.Set(
		j,
		"oidcProviderEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetPermissionsBoundary(val *string) {
	_jsii_.Set(
		j,
		"permissionsBoundary",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetPublicAccessCidrs(val *[]*string) {
	_jsii_.Set(
		j,
		"publicAccessCidrs",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetRegion(val *string) {
	_jsii_.Set(
		j,
		"region",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetServiceIpv4Cidr(val *string) {
	_jsii_.Set(
		j,
		"serviceIpv4Cidr",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetSubnetIds(val *[]*string) {
	if err := j.validateSetSubnetIdsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"subnetIds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetVpcId(val *string) {
	if err := j.validateSetVpcIdParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"vpcId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetWaitForClusterCommand(val *string) {
	_jsii_.Set(
		j,
		"waitForClusterCommand",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetWorkersRoleArns(val *[]*string) {
	_jsii_.Set(
		j,
		"workersRoleArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsEksCluster)SetWorkersSecurityGroupIds(val *[]*string) {
	_jsii_.Set(
		j,
		"workersSecurityGroupIds",
		val,
	)
}

// Checks if `x` is a construct.
//
// Use this method instead of `instanceof` to properly detect `Construct`
// instances, even when the construct library is symlinked.
//
// Explanation: in JavaScript, multiple copies of the `constructs` library on
// disk are seen as independent, completely different libraries. As a
// consequence, the class `Construct` in each copy of the `constructs` library
// is seen as a different class, and an instance of one class will not test as
// `instanceof` the other class. `npm install` will not create installations
// like this, but users may manually symlink construct libraries together or
// use a monorepo tool: in those cases, multiple copies of the `constructs`
// library can be accidentally installed, and `instanceof` will behave
// unpredictably. It is safest to avoid using `instanceof`, and using
// this type-testing method instead.
//
// Returns: true if `x` is an object created from a class which extends `Construct`.
func TerraformAwsEksCluster_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksCluster_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_cluster.TerraformAwsEksCluster",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsEksCluster_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsEksCluster_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_eks_cluster.TerraformAwsEksCluster",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsEksCluster) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsEksCluster) GetString(output *string) *string {
	if err := t.validateGetStringParameters(output); err != nil {
		panic(err)
	}
	var returns *string

	_jsii_.Invoke(
		t,
		"getString",
		[]interface{}{output},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
	if err := t.validateInterpolationForOutputParameters(moduleOutput); err != nil {
		panic(err)
	}
	var returns cdktf.IResolvable

	_jsii_.Invoke(
		t,
		"interpolationForOutput",
		[]interface{}{moduleOutput},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsEksCluster) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsEksCluster) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsEksCluster) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

