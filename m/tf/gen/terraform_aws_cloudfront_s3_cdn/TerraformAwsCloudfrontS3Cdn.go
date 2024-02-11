package terraform_aws_cloudfront_s3_cdn

import (
	_jsii_ "github.com/aws/jsii-runtime-go/runtime"
	_init_ "github.com/defn/dev/m/tf/gen/terraform_aws_cloudfront_s3_cdn/jsii"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/defn/dev/m/tf/gen/terraform_aws_cloudfront_s3_cdn/internal"
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

// Defines an TerraformAwsCloudfrontS3Cdn based on a Terraform module.
//
// Source at ../../mod/terraform-aws-cloudfront-s3-cdn
type TerraformAwsCloudfrontS3Cdn interface {
	cdktf.TerraformModule
	AccessLogBucketName() *string
	SetAccessLogBucketName(val *string)
	AcmCertificateArn() *string
	SetAcmCertificateArn(val *string)
	AdditionalBucketPolicy() *string
	SetAdditionalBucketPolicy(val *string)
	AdditionalTagMap() *map[string]*string
	SetAdditionalTagMap(val *map[string]*string)
	Aliases() *[]*string
	SetAliases(val *[]*string)
	AliasesOutput() *string
	AllowedMethods() *[]*string
	SetAllowedMethods(val *[]*string)
	AllowSslRequestsOnly() *bool
	SetAllowSslRequestsOnly(val *bool)
	Attributes() *[]*string
	SetAttributes(val *[]*string)
	BlockOriginPublicAccessEnabled() *bool
	SetBlockOriginPublicAccessEnabled(val *bool)
	CachedMethods() *[]*string
	SetCachedMethods(val *[]*string)
	CachePolicyId() *string
	SetCachePolicyId(val *string)
	// Experimental.
	CdktfStack() cdktf.TerraformStack
	CfArnOutput() *string
	CfDomainNameOutput() *string
	CfEtagOutput() *string
	CfHostedZoneIdOutput() *string
	CfIdentityIamArnOutput() *string
	CfIdOutput() *string
	CfOriginGroupsOutput() *string
	CfOriginIdsOutput() *string
	CfPrimaryOriginIdOutput() *string
	CfS3CanonicalUserIdOutput() *string
	CfStatusOutput() *string
	CloudfrontAccessLogBucketName() *string
	SetCloudfrontAccessLogBucketName(val *string)
	CloudfrontAccessLogCreateBucket() *bool
	SetCloudfrontAccessLogCreateBucket(val *bool)
	CloudfrontAccessLoggingEnabled() *bool
	SetCloudfrontAccessLoggingEnabled(val *bool)
	CloudfrontAccessLogIncludeCookies() *bool
	SetCloudfrontAccessLogIncludeCookies(val *bool)
	CloudfrontAccessLogPrefix() *string
	SetCloudfrontAccessLogPrefix(val *string)
	CloudfrontOriginAccessIdentityIamArn() *string
	SetCloudfrontOriginAccessIdentityIamArn(val *string)
	CloudfrontOriginAccessIdentityPath() *string
	SetCloudfrontOriginAccessIdentityPath(val *string)
	Comment() *string
	SetComment(val *string)
	Compress() *bool
	SetCompress(val *bool)
	// Experimental.
	ConstructNodeMetadata() *map[string]interface{}
	Context() interface{}
	SetContext(val interface{})
	CorsAllowedHeaders() *[]*string
	SetCorsAllowedHeaders(val *[]*string)
	CorsAllowedMethods() *[]*string
	SetCorsAllowedMethods(val *[]*string)
	CorsAllowedOrigins() *[]*string
	SetCorsAllowedOrigins(val *[]*string)
	CorsExposeHeaders() *[]*string
	SetCorsExposeHeaders(val *[]*string)
	CorsMaxAgeSeconds() *float64
	SetCorsMaxAgeSeconds(val *float64)
	CustomErrorResponse() interface{}
	SetCustomErrorResponse(val interface{})
	CustomOriginHeaders() *[]interface{}
	SetCustomOriginHeaders(val *[]interface{})
	CustomOrigins() interface{}
	SetCustomOrigins(val interface{})
	DefaultRootObject() *string
	SetDefaultRootObject(val *string)
	DefaultTtl() *float64
	SetDefaultTtl(val *float64)
	Delimiter() *string
	SetDelimiter(val *string)
	// Experimental.
	DependsOn() *[]*string
	// Experimental.
	SetDependsOn(val *[]*string)
	DeploymentActions() *[]*string
	SetDeploymentActions(val *[]*string)
	DeploymentPrincipalArns() *map[string]*[]*string
	SetDeploymentPrincipalArns(val *map[string]*[]*string)
	DescriptorFormats() interface{}
	SetDescriptorFormats(val interface{})
	DistributionEnabled() *bool
	SetDistributionEnabled(val *bool)
	DnsAliasEnabled() *bool
	SetDnsAliasEnabled(val *bool)
	DnsAllowOverwrite() *bool
	SetDnsAllowOverwrite(val *bool)
	Enabled() *bool
	SetEnabled(val *bool)
	EncryptionEnabled() *bool
	SetEncryptionEnabled(val *bool)
	Environment() *string
	SetEnvironment(val *string)
	ErrorDocument() *string
	SetErrorDocument(val *string)
	ExternalAliases() *[]*string
	SetExternalAliases(val *[]*string)
	ExtraLogsAttributes() *[]*string
	SetExtraLogsAttributes(val *[]*string)
	ExtraOriginAttributes() *[]*string
	SetExtraOriginAttributes(val *[]*string)
	// Experimental.
	ForEach() cdktf.ITerraformIterator
	// Experimental.
	SetForEach(val cdktf.ITerraformIterator)
	ForwardCookies() *string
	SetForwardCookies(val *string)
	ForwardHeaderValues() *[]*string
	SetForwardHeaderValues(val *[]*string)
	ForwardQueryString() *bool
	SetForwardQueryString(val *bool)
	// Experimental.
	Fqn() *string
	// Experimental.
	FriendlyUniqueId() *string
	FunctionAssociation() interface{}
	SetFunctionAssociation(val interface{})
	GeoRestrictionLocations() *[]*string
	SetGeoRestrictionLocations(val *[]*string)
	GeoRestrictionType() *string
	SetGeoRestrictionType(val *string)
	HttpVersion() *string
	SetHttpVersion(val *string)
	IdLengthLimit() *float64
	SetIdLengthLimit(val *float64)
	IndexDocument() *string
	SetIndexDocument(val *string)
	Ipv6Enabled() *bool
	SetIpv6Enabled(val *bool)
	LabelKeyCase() *string
	SetLabelKeyCase(val *string)
	LabelOrder() *[]*string
	SetLabelOrder(val *[]*string)
	LabelsAsTags() *[]*string
	SetLabelsAsTags(val *[]*string)
	LabelValueCase() *string
	SetLabelValueCase(val *string)
	LambdaFunctionAssociation() interface{}
	SetLambdaFunctionAssociation(val interface{})
	LogExpirationDays() *float64
	SetLogExpirationDays(val *float64)
	LoggingEnabled() *bool
	SetLoggingEnabled(val *bool)
	LogGlacierTransitionDays() *float64
	SetLogGlacierTransitionDays(val *float64)
	LogIncludeCookies() *bool
	SetLogIncludeCookies(val *bool)
	LogPrefix() *string
	SetLogPrefix(val *string)
	LogsOutput() *string
	LogStandardTransitionDays() *float64
	SetLogStandardTransitionDays(val *float64)
	LogVersioningEnabled() *bool
	SetLogVersioningEnabled(val *bool)
	MaxTtl() *float64
	SetMaxTtl(val *float64)
	MinimumProtocolVersion() *string
	SetMinimumProtocolVersion(val *string)
	MinTtl() *float64
	SetMinTtl(val *float64)
	Name() *string
	SetName(val *string)
	Namespace() *string
	SetNamespace(val *string)
	// The tree node.
	Node() constructs.Node
	OrderedCache() interface{}
	SetOrderedCache(val interface{})
	OriginBucket() *string
	SetOriginBucket(val *string)
	OriginForceDestroy() *bool
	SetOriginForceDestroy(val *bool)
	OriginGroups() interface{}
	SetOriginGroups(val interface{})
	OriginPath() *string
	SetOriginPath(val *string)
	OriginRequestPolicyId() *string
	SetOriginRequestPolicyId(val *string)
	OriginShieldEnabled() *bool
	SetOriginShieldEnabled(val *bool)
	OriginSslProtocols() *[]*string
	SetOriginSslProtocols(val *[]*string)
	OverrideOriginBucketPolicy() *bool
	SetOverrideOriginBucketPolicy(val *bool)
	ParentZoneId() *string
	SetParentZoneId(val *string)
	ParentZoneName() *string
	SetParentZoneName(val *string)
	PriceClass() *string
	SetPriceClass(val *string)
	// Experimental.
	Providers() *[]interface{}
	QueryStringCacheKeys() *[]*string
	SetQueryStringCacheKeys(val *[]*string)
	// Experimental.
	RawOverrides() interface{}
	RealtimeLogConfigArn() *string
	SetRealtimeLogConfigArn(val *string)
	RedirectAllRequestsTo() *string
	SetRedirectAllRequestsTo(val *string)
	RegexReplaceChars() *string
	SetRegexReplaceChars(val *string)
	ResponseHeadersPolicyId() *string
	SetResponseHeadersPolicyId(val *string)
	RoutingRules() *string
	SetRoutingRules(val *string)
	S3AccessLogBucketName() *string
	SetS3AccessLogBucketName(val *string)
	S3AccessLoggingEnabled() *bool
	SetS3AccessLoggingEnabled(val *bool)
	S3AccessLogPrefix() *string
	SetS3AccessLogPrefix(val *string)
	S3BucketArnOutput() *string
	S3BucketDomainNameOutput() *string
	S3BucketOutput() *string
	S3BucketPolicyOutput() *string
	S3ObjectOwnership() *string
	SetS3ObjectOwnership(val *string)
	S3Origins() interface{}
	SetS3Origins(val interface{})
	S3WebsitePasswordEnabled() *bool
	SetS3WebsitePasswordEnabled(val *bool)
	// Experimental.
	SkipAssetCreationFromLocalModules() *bool
	// Experimental.
	Source() *string
	Stage() *string
	SetStage(val *string)
	Tags() *map[string]*string
	SetTags(val *map[string]*string)
	Tenant() *string
	SetTenant(val *string)
	TrustedKeyGroups() *[]*string
	SetTrustedKeyGroups(val *[]*string)
	TrustedSigners() *[]*string
	SetTrustedSigners(val *[]*string)
	// Experimental.
	Version() *string
	VersioningEnabled() *bool
	SetVersioningEnabled(val *bool)
	ViewerProtocolPolicy() *string
	SetViewerProtocolPolicy(val *string)
	WaitForDeployment() *bool
	SetWaitForDeployment(val *bool)
	WebAclId() *string
	SetWebAclId(val *string)
	WebsiteEnabled() *bool
	SetWebsiteEnabled(val *bool)
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

// The jsii proxy struct for TerraformAwsCloudfrontS3Cdn
type jsiiProxy_TerraformAwsCloudfrontS3Cdn struct {
	internal.Type__cdktfTerraformModule
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AccessLogBucketName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"accessLogBucketName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AcmCertificateArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"acmCertificateArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AdditionalBucketPolicy() *string {
	var returns *string
	_jsii_.Get(
		j,
		"additionalBucketPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AdditionalTagMap() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"additionalTagMap",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Aliases() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"aliases",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AliasesOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"aliasesOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AllowedMethods() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"allowedMethods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AllowSslRequestsOnly() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"allowSslRequestsOnly",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Attributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"attributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) BlockOriginPublicAccessEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"blockOriginPublicAccessEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CachedMethods() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"cachedMethods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CachePolicyId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cachePolicyId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CdktfStack() cdktf.TerraformStack {
	var returns cdktf.TerraformStack
	_jsii_.Get(
		j,
		"cdktfStack",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfDomainNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfDomainNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfEtagOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfEtagOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfHostedZoneIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfHostedZoneIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfIdentityIamArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfIdentityIamArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfOriginGroupsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfOriginGroupsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfOriginIdsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfOriginIdsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfPrimaryOriginIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfPrimaryOriginIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfS3CanonicalUserIdOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfS3CanonicalUserIdOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CfStatusOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cfStatusOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontAccessLogBucketName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudfrontAccessLogBucketName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontAccessLogCreateBucket() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"cloudfrontAccessLogCreateBucket",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontAccessLoggingEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"cloudfrontAccessLoggingEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontAccessLogIncludeCookies() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"cloudfrontAccessLogIncludeCookies",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontAccessLogPrefix() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudfrontAccessLogPrefix",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontOriginAccessIdentityIamArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudfrontOriginAccessIdentityIamArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CloudfrontOriginAccessIdentityPath() *string {
	var returns *string
	_jsii_.Get(
		j,
		"cloudfrontOriginAccessIdentityPath",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Comment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"comment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Compress() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"compress",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ConstructNodeMetadata() *map[string]interface{} {
	var returns *map[string]interface{}
	_jsii_.Get(
		j,
		"constructNodeMetadata",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Context() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"context",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CorsAllowedHeaders() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"corsAllowedHeaders",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CorsAllowedMethods() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"corsAllowedMethods",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CorsAllowedOrigins() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"corsAllowedOrigins",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CorsExposeHeaders() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"corsExposeHeaders",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CorsMaxAgeSeconds() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"corsMaxAgeSeconds",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CustomErrorResponse() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"customErrorResponse",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CustomOriginHeaders() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"customOriginHeaders",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) CustomOrigins() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"customOrigins",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DefaultRootObject() *string {
	var returns *string
	_jsii_.Get(
		j,
		"defaultRootObject",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DefaultTtl() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"defaultTtl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Delimiter() *string {
	var returns *string
	_jsii_.Get(
		j,
		"delimiter",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DependsOn() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"dependsOn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DeploymentActions() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"deploymentActions",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DeploymentPrincipalArns() *map[string]*[]*string {
	var returns *map[string]*[]*string
	_jsii_.Get(
		j,
		"deploymentPrincipalArns",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DescriptorFormats() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"descriptorFormats",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DistributionEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"distributionEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DnsAliasEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"dnsAliasEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) DnsAllowOverwrite() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"dnsAllowOverwrite",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) EncryptionEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"encryptionEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Environment() *string {
	var returns *string
	_jsii_.Get(
		j,
		"environment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ErrorDocument() *string {
	var returns *string
	_jsii_.Get(
		j,
		"errorDocument",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ExternalAliases() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"externalAliases",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ExtraLogsAttributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"extraLogsAttributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ExtraOriginAttributes() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"extraOriginAttributes",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ForEach() cdktf.ITerraformIterator {
	var returns cdktf.ITerraformIterator
	_jsii_.Get(
		j,
		"forEach",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ForwardCookies() *string {
	var returns *string
	_jsii_.Get(
		j,
		"forwardCookies",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ForwardHeaderValues() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"forwardHeaderValues",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ForwardQueryString() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"forwardQueryString",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Fqn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"fqn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) FriendlyUniqueId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"friendlyUniqueId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) FunctionAssociation() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"functionAssociation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) GeoRestrictionLocations() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"geoRestrictionLocations",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) GeoRestrictionType() *string {
	var returns *string
	_jsii_.Get(
		j,
		"geoRestrictionType",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) HttpVersion() *string {
	var returns *string
	_jsii_.Get(
		j,
		"httpVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) IdLengthLimit() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"idLengthLimit",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) IndexDocument() *string {
	var returns *string
	_jsii_.Get(
		j,
		"indexDocument",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Ipv6Enabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"ipv6Enabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LabelKeyCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelKeyCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LabelOrder() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelOrder",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LabelsAsTags() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"labelsAsTags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LabelValueCase() *string {
	var returns *string
	_jsii_.Get(
		j,
		"labelValueCase",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LambdaFunctionAssociation() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"lambdaFunctionAssociation",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogExpirationDays() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"logExpirationDays",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LoggingEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"loggingEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogGlacierTransitionDays() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"logGlacierTransitionDays",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogIncludeCookies() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"logIncludeCookies",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogPrefix() *string {
	var returns *string
	_jsii_.Get(
		j,
		"logPrefix",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogsOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"logsOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogStandardTransitionDays() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"logStandardTransitionDays",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) LogVersioningEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"logVersioningEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) MaxTtl() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"maxTtl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) MinimumProtocolVersion() *string {
	var returns *string
	_jsii_.Get(
		j,
		"minimumProtocolVersion",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) MinTtl() *float64 {
	var returns *float64
	_jsii_.Get(
		j,
		"minTtl",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Name() *string {
	var returns *string
	_jsii_.Get(
		j,
		"name",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Namespace() *string {
	var returns *string
	_jsii_.Get(
		j,
		"namespace",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Node() constructs.Node {
	var returns constructs.Node
	_jsii_.Get(
		j,
		"node",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OrderedCache() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"orderedCache",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginBucket() *string {
	var returns *string
	_jsii_.Get(
		j,
		"originBucket",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginForceDestroy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"originForceDestroy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginGroups() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"originGroups",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginPath() *string {
	var returns *string
	_jsii_.Get(
		j,
		"originPath",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginRequestPolicyId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"originRequestPolicyId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginShieldEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"originShieldEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OriginSslProtocols() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"originSslProtocols",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OverrideOriginBucketPolicy() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"overrideOriginBucketPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ParentZoneId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"parentZoneId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ParentZoneName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"parentZoneName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) PriceClass() *string {
	var returns *string
	_jsii_.Get(
		j,
		"priceClass",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Providers() *[]interface{} {
	var returns *[]interface{}
	_jsii_.Get(
		j,
		"providers",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) QueryStringCacheKeys() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"queryStringCacheKeys",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) RawOverrides() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"rawOverrides",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) RealtimeLogConfigArn() *string {
	var returns *string
	_jsii_.Get(
		j,
		"realtimeLogConfigArn",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) RedirectAllRequestsTo() *string {
	var returns *string
	_jsii_.Get(
		j,
		"redirectAllRequestsTo",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) RegexReplaceChars() *string {
	var returns *string
	_jsii_.Get(
		j,
		"regexReplaceChars",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ResponseHeadersPolicyId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"responseHeadersPolicyId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) RoutingRules() *string {
	var returns *string
	_jsii_.Get(
		j,
		"routingRules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3AccessLogBucketName() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3AccessLogBucketName",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3AccessLoggingEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"s3AccessLoggingEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3AccessLogPrefix() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3AccessLogPrefix",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3BucketArnOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketArnOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3BucketDomainNameOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketDomainNameOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3BucketOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3BucketPolicyOutput() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3BucketPolicyOutput",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3ObjectOwnership() *string {
	var returns *string
	_jsii_.Get(
		j,
		"s3ObjectOwnership",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3Origins() interface{} {
	var returns interface{}
	_jsii_.Get(
		j,
		"s3Origins",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) S3WebsitePasswordEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"s3WebsitePasswordEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SkipAssetCreationFromLocalModules() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"skipAssetCreationFromLocalModules",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Source() *string {
	var returns *string
	_jsii_.Get(
		j,
		"source",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Stage() *string {
	var returns *string
	_jsii_.Get(
		j,
		"stage",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Tags() *map[string]*string {
	var returns *map[string]*string
	_jsii_.Get(
		j,
		"tags",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Tenant() *string {
	var returns *string
	_jsii_.Get(
		j,
		"tenant",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) TrustedKeyGroups() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"trustedKeyGroups",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) TrustedSigners() *[]*string {
	var returns *[]*string
	_jsii_.Get(
		j,
		"trustedSigners",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) Version() *string {
	var returns *string
	_jsii_.Get(
		j,
		"version",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) VersioningEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"versioningEnabled",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ViewerProtocolPolicy() *string {
	var returns *string
	_jsii_.Get(
		j,
		"viewerProtocolPolicy",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) WaitForDeployment() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"waitForDeployment",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) WebAclId() *string {
	var returns *string
	_jsii_.Get(
		j,
		"webAclId",
		&returns,
	)
	return returns
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) WebsiteEnabled() *bool {
	var returns *bool
	_jsii_.Get(
		j,
		"websiteEnabled",
		&returns,
	)
	return returns
}

func NewTerraformAwsCloudfrontS3Cdn(scope constructs.Construct, id *string, config *TerraformAwsCloudfrontS3CdnConfig) TerraformAwsCloudfrontS3Cdn {
	_init_.Initialize()

	if err := validateNewTerraformAwsCloudfrontS3CdnParameters(scope, id, config); err != nil {
		panic(err)
	}
	j := jsiiProxy_TerraformAwsCloudfrontS3Cdn{}

	_jsii_.Create(
		"terraform_aws_cloudfront_s3_cdn.TerraformAwsCloudfrontS3Cdn",
		[]interface{}{scope, id, config},
		&j,
	)

	return &j
}

func NewTerraformAwsCloudfrontS3Cdn_Override(t TerraformAwsCloudfrontS3Cdn, scope constructs.Construct, id *string, config *TerraformAwsCloudfrontS3CdnConfig) {
	_init_.Initialize()

	_jsii_.Create(
		"terraform_aws_cloudfront_s3_cdn.TerraformAwsCloudfrontS3Cdn",
		[]interface{}{scope, id, config},
		t,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAccessLogBucketName(val *string) {
	_jsii_.Set(
		j,
		"accessLogBucketName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAcmCertificateArn(val *string) {
	_jsii_.Set(
		j,
		"acmCertificateArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAdditionalBucketPolicy(val *string) {
	_jsii_.Set(
		j,
		"additionalBucketPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAdditionalTagMap(val *map[string]*string) {
	_jsii_.Set(
		j,
		"additionalTagMap",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAliases(val *[]*string) {
	_jsii_.Set(
		j,
		"aliases",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAllowedMethods(val *[]*string) {
	_jsii_.Set(
		j,
		"allowedMethods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAllowSslRequestsOnly(val *bool) {
	_jsii_.Set(
		j,
		"allowSslRequestsOnly",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"attributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetBlockOriginPublicAccessEnabled(val *bool) {
	_jsii_.Set(
		j,
		"blockOriginPublicAccessEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCachedMethods(val *[]*string) {
	_jsii_.Set(
		j,
		"cachedMethods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCachePolicyId(val *string) {
	_jsii_.Set(
		j,
		"cachePolicyId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontAccessLogBucketName(val *string) {
	_jsii_.Set(
		j,
		"cloudfrontAccessLogBucketName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontAccessLogCreateBucket(val *bool) {
	_jsii_.Set(
		j,
		"cloudfrontAccessLogCreateBucket",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontAccessLoggingEnabled(val *bool) {
	_jsii_.Set(
		j,
		"cloudfrontAccessLoggingEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontAccessLogIncludeCookies(val *bool) {
	_jsii_.Set(
		j,
		"cloudfrontAccessLogIncludeCookies",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontAccessLogPrefix(val *string) {
	_jsii_.Set(
		j,
		"cloudfrontAccessLogPrefix",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontOriginAccessIdentityIamArn(val *string) {
	_jsii_.Set(
		j,
		"cloudfrontOriginAccessIdentityIamArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCloudfrontOriginAccessIdentityPath(val *string) {
	_jsii_.Set(
		j,
		"cloudfrontOriginAccessIdentityPath",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetComment(val *string) {
	_jsii_.Set(
		j,
		"comment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCompress(val *bool) {
	_jsii_.Set(
		j,
		"compress",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetContext(val interface{}) {
	if err := j.validateSetContextParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"context",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCorsAllowedHeaders(val *[]*string) {
	_jsii_.Set(
		j,
		"corsAllowedHeaders",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCorsAllowedMethods(val *[]*string) {
	_jsii_.Set(
		j,
		"corsAllowedMethods",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCorsAllowedOrigins(val *[]*string) {
	_jsii_.Set(
		j,
		"corsAllowedOrigins",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCorsExposeHeaders(val *[]*string) {
	_jsii_.Set(
		j,
		"corsExposeHeaders",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCorsMaxAgeSeconds(val *float64) {
	_jsii_.Set(
		j,
		"corsMaxAgeSeconds",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCustomErrorResponse(val interface{}) {
	if err := j.validateSetCustomErrorResponseParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"customErrorResponse",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCustomOriginHeaders(val *[]interface{}) {
	_jsii_.Set(
		j,
		"customOriginHeaders",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetCustomOrigins(val interface{}) {
	if err := j.validateSetCustomOriginsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"customOrigins",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDefaultRootObject(val *string) {
	_jsii_.Set(
		j,
		"defaultRootObject",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDefaultTtl(val *float64) {
	_jsii_.Set(
		j,
		"defaultTtl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDelimiter(val *string) {
	_jsii_.Set(
		j,
		"delimiter",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDependsOn(val *[]*string) {
	_jsii_.Set(
		j,
		"dependsOn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDeploymentActions(val *[]*string) {
	_jsii_.Set(
		j,
		"deploymentActions",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDeploymentPrincipalArns(val *map[string]*[]*string) {
	_jsii_.Set(
		j,
		"deploymentPrincipalArns",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDescriptorFormats(val interface{}) {
	if err := j.validateSetDescriptorFormatsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"descriptorFormats",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDistributionEnabled(val *bool) {
	_jsii_.Set(
		j,
		"distributionEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDnsAliasEnabled(val *bool) {
	_jsii_.Set(
		j,
		"dnsAliasEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetDnsAllowOverwrite(val *bool) {
	_jsii_.Set(
		j,
		"dnsAllowOverwrite",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetEnabled(val *bool) {
	_jsii_.Set(
		j,
		"enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetEncryptionEnabled(val *bool) {
	_jsii_.Set(
		j,
		"encryptionEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetEnvironment(val *string) {
	_jsii_.Set(
		j,
		"environment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetErrorDocument(val *string) {
	_jsii_.Set(
		j,
		"errorDocument",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetExternalAliases(val *[]*string) {
	_jsii_.Set(
		j,
		"externalAliases",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetExtraLogsAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"extraLogsAttributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetExtraOriginAttributes(val *[]*string) {
	_jsii_.Set(
		j,
		"extraOriginAttributes",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetForEach(val cdktf.ITerraformIterator) {
	_jsii_.Set(
		j,
		"forEach",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetForwardCookies(val *string) {
	_jsii_.Set(
		j,
		"forwardCookies",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetForwardHeaderValues(val *[]*string) {
	_jsii_.Set(
		j,
		"forwardHeaderValues",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetForwardQueryString(val *bool) {
	_jsii_.Set(
		j,
		"forwardQueryString",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetFunctionAssociation(val interface{}) {
	if err := j.validateSetFunctionAssociationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"functionAssociation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetGeoRestrictionLocations(val *[]*string) {
	_jsii_.Set(
		j,
		"geoRestrictionLocations",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetGeoRestrictionType(val *string) {
	_jsii_.Set(
		j,
		"geoRestrictionType",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetHttpVersion(val *string) {
	_jsii_.Set(
		j,
		"httpVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetIdLengthLimit(val *float64) {
	_jsii_.Set(
		j,
		"idLengthLimit",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetIndexDocument(val *string) {
	_jsii_.Set(
		j,
		"indexDocument",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetIpv6Enabled(val *bool) {
	_jsii_.Set(
		j,
		"ipv6Enabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLabelKeyCase(val *string) {
	_jsii_.Set(
		j,
		"labelKeyCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLabelOrder(val *[]*string) {
	_jsii_.Set(
		j,
		"labelOrder",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLabelsAsTags(val *[]*string) {
	_jsii_.Set(
		j,
		"labelsAsTags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLabelValueCase(val *string) {
	_jsii_.Set(
		j,
		"labelValueCase",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLambdaFunctionAssociation(val interface{}) {
	if err := j.validateSetLambdaFunctionAssociationParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"lambdaFunctionAssociation",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogExpirationDays(val *float64) {
	_jsii_.Set(
		j,
		"logExpirationDays",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLoggingEnabled(val *bool) {
	_jsii_.Set(
		j,
		"loggingEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogGlacierTransitionDays(val *float64) {
	_jsii_.Set(
		j,
		"logGlacierTransitionDays",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogIncludeCookies(val *bool) {
	_jsii_.Set(
		j,
		"logIncludeCookies",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogPrefix(val *string) {
	_jsii_.Set(
		j,
		"logPrefix",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogStandardTransitionDays(val *float64) {
	_jsii_.Set(
		j,
		"logStandardTransitionDays",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetLogVersioningEnabled(val *bool) {
	_jsii_.Set(
		j,
		"logVersioningEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetMaxTtl(val *float64) {
	_jsii_.Set(
		j,
		"maxTtl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetMinimumProtocolVersion(val *string) {
	_jsii_.Set(
		j,
		"minimumProtocolVersion",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetMinTtl(val *float64) {
	_jsii_.Set(
		j,
		"minTtl",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetName(val *string) {
	_jsii_.Set(
		j,
		"name",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetNamespace(val *string) {
	_jsii_.Set(
		j,
		"namespace",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOrderedCache(val interface{}) {
	if err := j.validateSetOrderedCacheParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"orderedCache",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginBucket(val *string) {
	_jsii_.Set(
		j,
		"originBucket",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginForceDestroy(val *bool) {
	_jsii_.Set(
		j,
		"originForceDestroy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginGroups(val interface{}) {
	if err := j.validateSetOriginGroupsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"originGroups",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginPath(val *string) {
	_jsii_.Set(
		j,
		"originPath",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginRequestPolicyId(val *string) {
	_jsii_.Set(
		j,
		"originRequestPolicyId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginShieldEnabled(val *bool) {
	_jsii_.Set(
		j,
		"originShieldEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOriginSslProtocols(val *[]*string) {
	_jsii_.Set(
		j,
		"originSslProtocols",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetOverrideOriginBucketPolicy(val *bool) {
	_jsii_.Set(
		j,
		"overrideOriginBucketPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetParentZoneId(val *string) {
	_jsii_.Set(
		j,
		"parentZoneId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetParentZoneName(val *string) {
	_jsii_.Set(
		j,
		"parentZoneName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetPriceClass(val *string) {
	_jsii_.Set(
		j,
		"priceClass",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetQueryStringCacheKeys(val *[]*string) {
	_jsii_.Set(
		j,
		"queryStringCacheKeys",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetRealtimeLogConfigArn(val *string) {
	_jsii_.Set(
		j,
		"realtimeLogConfigArn",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetRedirectAllRequestsTo(val *string) {
	_jsii_.Set(
		j,
		"redirectAllRequestsTo",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetRegexReplaceChars(val *string) {
	_jsii_.Set(
		j,
		"regexReplaceChars",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetResponseHeadersPolicyId(val *string) {
	_jsii_.Set(
		j,
		"responseHeadersPolicyId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetRoutingRules(val *string) {
	_jsii_.Set(
		j,
		"routingRules",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3AccessLogBucketName(val *string) {
	_jsii_.Set(
		j,
		"s3AccessLogBucketName",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3AccessLoggingEnabled(val *bool) {
	_jsii_.Set(
		j,
		"s3AccessLoggingEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3AccessLogPrefix(val *string) {
	_jsii_.Set(
		j,
		"s3AccessLogPrefix",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3ObjectOwnership(val *string) {
	_jsii_.Set(
		j,
		"s3ObjectOwnership",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3Origins(val interface{}) {
	if err := j.validateSetS3OriginsParameters(val); err != nil {
		panic(err)
	}
	_jsii_.Set(
		j,
		"s3Origins",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetS3WebsitePasswordEnabled(val *bool) {
	_jsii_.Set(
		j,
		"s3WebsitePasswordEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetStage(val *string) {
	_jsii_.Set(
		j,
		"stage",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetTags(val *map[string]*string) {
	_jsii_.Set(
		j,
		"tags",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetTenant(val *string) {
	_jsii_.Set(
		j,
		"tenant",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetTrustedKeyGroups(val *[]*string) {
	_jsii_.Set(
		j,
		"trustedKeyGroups",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetTrustedSigners(val *[]*string) {
	_jsii_.Set(
		j,
		"trustedSigners",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetVersioningEnabled(val *bool) {
	_jsii_.Set(
		j,
		"versioningEnabled",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetViewerProtocolPolicy(val *string) {
	_jsii_.Set(
		j,
		"viewerProtocolPolicy",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetWaitForDeployment(val *bool) {
	_jsii_.Set(
		j,
		"waitForDeployment",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetWebAclId(val *string) {
	_jsii_.Set(
		j,
		"webAclId",
		val,
	)
}

func (j *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SetWebsiteEnabled(val *bool) {
	_jsii_.Set(
		j,
		"websiteEnabled",
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
func TerraformAwsCloudfrontS3Cdn_IsConstruct(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsCloudfrontS3Cdn_IsConstructParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_cloudfront_s3_cdn.TerraformAwsCloudfrontS3Cdn",
		"isConstruct",
		[]interface{}{x},
		&returns,
	)

	return returns
}

// Experimental.
func TerraformAwsCloudfrontS3Cdn_IsTerraformElement(x interface{}) *bool {
	_init_.Initialize()

	if err := validateTerraformAwsCloudfrontS3Cdn_IsTerraformElementParameters(x); err != nil {
		panic(err)
	}
	var returns *bool

	_jsii_.StaticInvoke(
		"terraform_aws_cloudfront_s3_cdn.TerraformAwsCloudfrontS3Cdn",
		"isTerraformElement",
		[]interface{}{x},
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AddOverride(path *string, value interface{}) {
	if err := t.validateAddOverrideParameters(path, value); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addOverride",
		[]interface{}{path, value},
	)
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) AddProvider(provider interface{}) {
	if err := t.validateAddProviderParameters(provider); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"addProvider",
		[]interface{}{provider},
	)
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) GetString(output *string) *string {
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

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) InterpolationForOutput(moduleOutput *string) cdktf.IResolvable {
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

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) OverrideLogicalId(newLogicalId *string) {
	if err := t.validateOverrideLogicalIdParameters(newLogicalId); err != nil {
		panic(err)
	}
	_jsii_.InvokeVoid(
		t,
		"overrideLogicalId",
		[]interface{}{newLogicalId},
	)
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ResetOverrideLogicalId() {
	_jsii_.InvokeVoid(
		t,
		"resetOverrideLogicalId",
		nil, // no parameters
	)
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SynthesizeAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) SynthesizeHclAttributes() *map[string]interface{} {
	var returns *map[string]interface{}

	_jsii_.Invoke(
		t,
		"synthesizeHclAttributes",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ToHclTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toHclTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ToMetadata() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toMetadata",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ToString() *string {
	var returns *string

	_jsii_.Invoke(
		t,
		"toString",
		nil, // no parameters
		&returns,
	)

	return returns
}

func (t *jsiiProxy_TerraformAwsCloudfrontS3Cdn) ToTerraform() interface{} {
	var returns interface{}

	_jsii_.Invoke(
		t,
		"toTerraform",
		nil, // no parameters
		&returns,
	)

	return returns
}
