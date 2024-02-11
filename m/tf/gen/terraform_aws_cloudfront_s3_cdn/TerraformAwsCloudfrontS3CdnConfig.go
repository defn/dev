package terraform_aws_cloudfront_s3_cdn

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type TerraformAwsCloudfrontS3CdnConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// DEPRECATED.
	//
	// Use `s3_access_log_bucket_name` instead.
	AccessLogBucketName *string `field:"optional" json:"accessLogBucketName" yaml:"accessLogBucketName"`
	// Existing ACM Certificate ARN.
	AcmCertificateArn *string `field:"optional" json:"acmCertificateArn" yaml:"acmCertificateArn"`
	// Additional policies for the bucket.
	//
	// If included in the policies, the variables `$${bucket_name}`, `$${origin_path}` and `$${cloudfront_origin_access_identity_iam_arn}` will be substituted.
	// It is also possible to override the default policy statements by providing statements with `S3GetObjectForCloudFront` and `S3ListBucketForCloudFront` sid.
	//
	// {}.
	AdditionalBucketPolicy *string `field:"optional" json:"additionalBucketPolicy" yaml:"additionalBucketPolicy"`
	// Additional key-value pairs to add to each map in `tags_as_list_of_maps`.
	//
	// Not added to `tags` or `id`.
	// This is for some rare cases where resources want additional configuration of tags
	// and therefore take a list of maps with tag key, value, and additional configuration.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	AdditionalTagMap *map[string]*string `field:"optional" json:"additionalTagMap" yaml:"additionalTagMap"`
	// List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront.
	Aliases *[]*string `field:"optional" json:"aliases" yaml:"aliases"`
	// List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront DELETE GET HEAD OPTIONS PATCH POST PUT.
	AllowedMethods *[]*string `field:"optional" json:"allowedMethods" yaml:"allowedMethods"`
	// Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL).
	//
	// This will explicitly deny access to HTTP requests
	// true.
	AllowSslRequestsOnly *bool `field:"optional" json:"allowSslRequestsOnly" yaml:"allowSslRequestsOnly"`
	// ID element.
	//
	// Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
	// in the order they appear in the list. New attributes are appended to the
	// end of the list. The elements of the list are joined by the `delimiter`
	// and treated as a single ID element.
	Attributes *[]*string `field:"optional" json:"attributes" yaml:"attributes"`
	// When set to 'true' the s3 origin bucket will have public access block enabled.
	BlockOriginPublicAccessEnabled *bool `field:"optional" json:"blockOriginPublicAccessEnabled" yaml:"blockOriginPublicAccessEnabled"`
	// List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD) GET HEAD.
	CachedMethods *[]*string `field:"optional" json:"cachedMethods" yaml:"cachedMethods"`
	// The unique identifier of the existing cache policy to attach to the default cache behavior.
	//
	// If not provided, this module will add a default cache policy using other provided inputs.
	CachePolicyId *string `field:"optional" json:"cachePolicyId" yaml:"cachePolicyId"`
	// When `cloudfront_access_log_create_bucket` is `false`, this is the name of the existing S3 Bucket where Cloudfront Access Logs are to be delivered and is required.
	//
	// IGNORED when `cloudfront_access_log_create_bucket` is `true`.
	CloudfrontAccessLogBucketName *string `field:"optional" json:"cloudfrontAccessLogBucketName" yaml:"cloudfrontAccessLogBucketName"`
	// When `true` and `cloudfront_access_logging_enabled` is also true, this module will create a new, separate S3 bucket to receive Cloudfront Access Logs.
	//
	// true.
	CloudfrontAccessLogCreateBucket *bool `field:"optional" json:"cloudfrontAccessLogCreateBucket" yaml:"cloudfrontAccessLogCreateBucket"`
	// Set true to enable delivery of Cloudfront Access Logs to an S3 bucket true.
	CloudfrontAccessLoggingEnabled *bool `field:"optional" json:"cloudfrontAccessLoggingEnabled" yaml:"cloudfrontAccessLoggingEnabled"`
	// Set true to include cookies in Cloudfront Access Logs.
	CloudfrontAccessLogIncludeCookies *bool `field:"optional" json:"cloudfrontAccessLogIncludeCookies" yaml:"cloudfrontAccessLogIncludeCookies"`
	// Prefix to use for Cloudfront Access Log object keys.
	//
	// Defaults to no prefix.
	CloudfrontAccessLogPrefix *string `field:"optional" json:"cloudfrontAccessLogPrefix" yaml:"cloudfrontAccessLogPrefix"`
	// Existing cloudfront origin access identity iam arn that is supplied in the s3 bucket policy.
	CloudfrontOriginAccessIdentityIamArn *string `field:"optional" json:"cloudfrontOriginAccessIdentityIamArn" yaml:"cloudfrontOriginAccessIdentityIamArn"`
	// Existing cloudfront origin access identity path used in the cloudfront distribution's s3_origin_config content.
	CloudfrontOriginAccessIdentityPath *string `field:"optional" json:"cloudfrontOriginAccessIdentityPath" yaml:"cloudfrontOriginAccessIdentityPath"`
	// Comment for the CloudFront distribution Managed by Terraform.
	Comment *string `field:"optional" json:"comment" yaml:"comment"`
	// Compress content for web requests that include Accept-Encoding: gzip in the request header true.
	Compress *bool `field:"optional" json:"compress" yaml:"compress"`
	// Single object for setting entire context at once.
	//
	// See description of individual variables for details.
	// Leave string and numeric variables as `null` to use default value.
	// Individual variable settings (non-null) override settings in context object,
	// except for attributes, tags, and additional_tag_map, which are merged.
	Context interface{} `field:"optional" json:"context" yaml:"context"`
	// List of allowed headers for S3 bucket *.
	CorsAllowedHeaders *[]*string `field:"optional" json:"corsAllowedHeaders" yaml:"corsAllowedHeaders"`
	// List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for S3 bucket GET.
	CorsAllowedMethods *[]*string `field:"optional" json:"corsAllowedMethods" yaml:"corsAllowedMethods"`
	// List of allowed origins (e.g. example.com, test.com) for S3 bucket.
	CorsAllowedOrigins *[]*string `field:"optional" json:"corsAllowedOrigins" yaml:"corsAllowedOrigins"`
	// List of expose header in the response for S3 bucket ETag.
	CorsExposeHeaders *[]*string `field:"optional" json:"corsExposeHeaders" yaml:"corsExposeHeaders"`
	// Time in seconds that browser can cache the response for S3 bucket 3,600.
	CorsMaxAgeSeconds *float64 `field:"optional" json:"corsMaxAgeSeconds" yaml:"corsMaxAgeSeconds"`
	// List of one or more custom error response element maps.
	CustomErrorResponse interface{} `field:"optional" json:"customErrorResponse" yaml:"customErrorResponse"`
	// A list of origin header parameters that will be sent to origin.
	CustomOriginHeaders *[]interface{} `field:"optional" json:"customOriginHeaders" yaml:"customOriginHeaders"`
	// A list of additional custom website [origins](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-arguments) for this distribution.
	CustomOrigins interface{} `field:"optional" json:"customOrigins" yaml:"customOrigins"`
	// Object that CloudFront return when requests the root URL index.html.
	DefaultRootObject *string `field:"optional" json:"defaultRootObject" yaml:"defaultRootObject"`
	// Default amount of time (in seconds) that an object is in a CloudFront cache 60.
	DefaultTtl *float64 `field:"optional" json:"defaultTtl" yaml:"defaultTtl"`
	// Delimiter to be used between ID elements.
	//
	// Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
	Delimiter *string `field:"optional" json:"delimiter" yaml:"delimiter"`
	// List of actions to permit `deployment_principal_arns` to perform on bucket and bucket prefixes (see `deployment_principal_arns`) s3:PutObject s3:PutObjectAcl s3:GetObject s3:DeleteObject s3:ListBucket s3:ListBucketMultipartUploads s3:GetBucketLocation s3:AbortMultipartUpload.
	DeploymentActions *[]*string `field:"optional" json:"deploymentActions" yaml:"deploymentActions"`
	// (Optional) Map of IAM Principal ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions.
	//
	// Resource list will include the bucket itself along with all the prefixes. Prefixes should not begin with '/'.
	//
	// The property type contains a map, they have special handling, please see {@link cdk.tf /module-map-inputs the docs}
	DeploymentPrincipalArns *map[string]*[]*string `field:"optional" json:"deploymentPrincipalArns" yaml:"deploymentPrincipalArns"`
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
	// Set to `false` to create the distribution but still prevent CloudFront from serving requests.
	//
	// true.
	DistributionEnabled *bool `field:"optional" json:"distributionEnabled" yaml:"distributionEnabled"`
	// Create a DNS alias for the CDN.
	//
	// Requires `parent_zone_id` or `parent_zone_name`.
	DnsAliasEnabled *bool `field:"optional" json:"dnsAliasEnabled" yaml:"dnsAliasEnabled"`
	// Allow creation of DNS records in Terraform to overwrite an existing record, if any.
	//
	// This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record. false by default. This configuration is not recommended for most environments
	DnsAllowOverwrite *bool `field:"optional" json:"dnsAllowOverwrite" yaml:"dnsAllowOverwrite"`
	// Set to false to prevent the module from creating any resources.
	Enabled *bool `field:"optional" json:"enabled" yaml:"enabled"`
	// When set to 'true' the resource will have aes256 encryption enabled by default true.
	EncryptionEnabled *bool `field:"optional" json:"encryptionEnabled" yaml:"encryptionEnabled"`
	// ID element.
	//
	// Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'
	Environment *string `field:"optional" json:"environment" yaml:"environment"`
	// An absolute path to the document to return in case of a 4XX error.
	ErrorDocument *string `field:"optional" json:"errorDocument" yaml:"errorDocument"`
	// List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront.
	//
	// No new route53 records will be created for these.
	ExternalAliases *[]*string `field:"optional" json:"externalAliases" yaml:"externalAliases"`
	// Additional attributes to add to the end of the generated Cloudfront Access Log S3 Bucket name.
	//
	// Only effective if `cloudfront_access_log_create_bucket` is `true`.
	//
	// logs.
	ExtraLogsAttributes *[]*string `field:"optional" json:"extraLogsAttributes" yaml:"extraLogsAttributes"`
	// Additional attributes to put onto the origin label origin.
	ExtraOriginAttributes *[]*string `field:"optional" json:"extraOriginAttributes" yaml:"extraOriginAttributes"`
	// Specifies whether you want CloudFront to forward all or no cookies to the origin.
	//
	// Can be 'all' or 'none'
	// none.
	ForwardCookies *string `field:"optional" json:"forwardCookies" yaml:"forwardCookies"`
	// A list of whitelisted header values to forward to the origin (incompatible with `cache_policy_id`) Access-Control-Request-Headers Access-Control-Request-Method Origin.
	ForwardHeaderValues *[]*string `field:"optional" json:"forwardHeaderValues" yaml:"forwardHeaderValues"`
	// Forward query strings to the origin that is associated with this cache behavior (incompatible with `cache_policy_id`).
	ForwardQueryString *bool `field:"optional" json:"forwardQueryString" yaml:"forwardQueryString"`
	// A config block that triggers a CloudFront function with specific actions.
	//
	// See the [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#function-association)
	// documentation for more information.
	FunctionAssociation interface{} `field:"optional" json:"functionAssociation" yaml:"functionAssociation"`
	// List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist).
	GeoRestrictionLocations *[]*string `field:"optional" json:"geoRestrictionLocations" yaml:"geoRestrictionLocations"`
	// Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist` none.
	GeoRestrictionType *string `field:"optional" json:"geoRestrictionType" yaml:"geoRestrictionType"`
	// The maximum HTTP version to support on the distribution.
	//
	// Allowed values are http1.1, http2, http2and3 and http3
	// http2.
	HttpVersion *string `field:"optional" json:"httpVersion" yaml:"httpVersion"`
	// Limit `id` to this many characters (minimum 6).
	//
	// Set to `0` for unlimited length.
	// Set to `null` for keep the existing setting, which defaults to `0`.
	// Does not affect `id_full`.
	IdLengthLimit *float64 `field:"optional" json:"idLengthLimit" yaml:"idLengthLimit"`
	// Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders index.html.
	IndexDocument *string `field:"optional" json:"indexDocument" yaml:"indexDocument"`
	// Set to true to enable an AAAA DNS record to be set as well as the A record true.
	Ipv6Enabled *bool `field:"optional" json:"ipv6Enabled" yaml:"ipv6Enabled"`
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
	// A config block that triggers a lambda@edge function with specific actions.
	LambdaFunctionAssociation interface{} `field:"optional" json:"lambdaFunctionAssociation" yaml:"lambdaFunctionAssociation"`
	// Number of days after object creation to expire Cloudfront Access Log objects. Only effective if `cloudfront_access_log_create_bucket` is `true`.
	//
	// 90.
	LogExpirationDays *float64 `field:"optional" json:"logExpirationDays" yaml:"logExpirationDays"`
	// DEPRECATED.
	//
	// Use `cloudfront_access_logging_enabled` instead.
	LoggingEnabled *bool `field:"optional" json:"loggingEnabled" yaml:"loggingEnabled"`
	// Number of days after object creation to move Cloudfront Access Log objects to the glacier tier.
	//
	// Only effective if `cloudfront_access_log_create_bucket` is `true`.
	//
	// 60.
	LogGlacierTransitionDays *float64 `field:"optional" json:"logGlacierTransitionDays" yaml:"logGlacierTransitionDays"`
	// DEPRECATED.
	//
	// Use `cloudfront_access_log_include_cookies` instead.
	LogIncludeCookies *bool `field:"optional" json:"logIncludeCookies" yaml:"logIncludeCookies"`
	// DEPRECATED.
	//
	// Use `cloudfront_access_log_prefix` instead.
	LogPrefix *string `field:"optional" json:"logPrefix" yaml:"logPrefix"`
	// Number of days after object creation to move Cloudfront Access Log objects to the infrequent access tier.
	//
	// Only effective if `cloudfront_access_log_create_bucket` is `true`.
	//
	// 30.
	LogStandardTransitionDays *float64 `field:"optional" json:"logStandardTransitionDays" yaml:"logStandardTransitionDays"`
	// Set `true` to enable object versioning in the created Cloudfront Access Log S3 Bucket.
	//
	// Only effective if `cloudfront_access_log_create_bucket` is `true`.
	LogVersioningEnabled *bool `field:"optional" json:"logVersioningEnabled" yaml:"logVersioningEnabled"`
	// Maximum amount of time (in seconds) that an object is in a CloudFront cache 31,536,000.
	MaxTtl *float64 `field:"optional" json:"maxTtl" yaml:"maxTtl"`
	// Cloudfront TLS minimum protocol version.
	//
	// If `var.acm_certificate_arn` is unset, only "TLSv1" can be specified. See: [AWS Cloudfront create-distribution documentation](https://docs.aws.amazon.com/cli/latest/reference/cloudfront/create-distribution.html)
	// and [Supported protocols and ciphers between viewers and CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html#secure-connections-supported-ciphers) for more information.
	// Defaults to "TLSv1.2_2019" unless `var.acm_certificate_arn` is unset, in which case it defaults to `TLSv1`
	MinimumProtocolVersion *string `field:"optional" json:"minimumProtocolVersion" yaml:"minimumProtocolVersion"`
	// Minimum amount of time that you want objects to stay in CloudFront caches.
	MinTtl *float64 `field:"optional" json:"minTtl" yaml:"minTtl"`
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
	// An ordered list of [cache behaviors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#cache-behavior-arguments) resource for this distribution. List in order of precedence (first match wins). This is in addition to the default cache policy. Set `target_origin_id` to `""` to specify the S3 bucket origin created by this module.
	OrderedCache interface{} `field:"optional" json:"orderedCache" yaml:"orderedCache"`
	// Name of an existing S3 bucket to use as the origin.
	//
	// If this is not provided, it will create a new s3 bucket using `var.name` and other context related inputs
	OriginBucket *string `field:"optional" json:"originBucket" yaml:"originBucket"`
	// Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`).
	OriginForceDestroy *bool `field:"optional" json:"originForceDestroy" yaml:"originForceDestroy"`
	// List of [Origin Groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#origin-group-arguments) to create in the distribution. The values of `primary_origin_id` and `failover_origin_id` must correspond to origin IDs existing in `var.s3_origins` or `var.custom_origins`.
	//
	// If `primary_origin_id` is set to `null` or `""`, then the origin id of the origin created by this module will be used in its place.
	// This is to allow for the use case of making the origin created by this module the primary origin in an origin group.
	OriginGroups interface{} `field:"optional" json:"originGroups" yaml:"originGroups"`
	// An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin.
	//
	// It must begin with a /. Do not add a / at the end of the path.
	OriginPath *string `field:"optional" json:"originPath" yaml:"originPath"`
	// The unique identifier of the origin request policy that is attached to the behavior.
	//
	// Should be used in conjunction with `cache_policy_id`.
	OriginRequestPolicyId *string `field:"optional" json:"originRequestPolicyId" yaml:"originRequestPolicyId"`
	// If enabled, origin shield will be enabled for the default origin.
	OriginShieldEnabled *bool `field:"optional" json:"originShieldEnabled" yaml:"originShieldEnabled"`
	// The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS.
	//
	// TLSv1
	// TLSv1.1
	// TLSv1.2
	OriginSslProtocols *[]*string `field:"optional" json:"originSslProtocols" yaml:"originSslProtocols"`
	// When using an existing origin bucket (through var.origin_bucket), setting this to 'false' will make it so the existing bucket policy will not be overriden true.
	OverrideOriginBucketPolicy *bool `field:"optional" json:"overrideOriginBucketPolicy" yaml:"overrideOriginBucketPolicy"`
	// ID of the hosted zone to contain this record (or specify `parent_zone_name`).
	//
	// Requires `dns_alias_enabled` set to true.
	ParentZoneId *string `field:"optional" json:"parentZoneId" yaml:"parentZoneId"`
	// Name of the hosted zone to contain this record (or specify `parent_zone_id`).
	//
	// Requires `dns_alias_enabled` set to true.
	ParentZoneName *string `field:"optional" json:"parentZoneName" yaml:"parentZoneName"`
	// Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100` PriceClass_100.
	PriceClass *string `field:"optional" json:"priceClass" yaml:"priceClass"`
	// When `forward_query_string` is enabled, only the query string keys listed in this argument are cached (incompatible with `cache_policy_id`).
	QueryStringCacheKeys *[]*string `field:"optional" json:"queryStringCacheKeys" yaml:"queryStringCacheKeys"`
	// The ARN of the real-time log configuration that is attached to this cache behavior.
	RealtimeLogConfigArn *string `field:"optional" json:"realtimeLogConfigArn" yaml:"realtimeLogConfigArn"`
	// A hostname to redirect all website requests for this distribution to.
	//
	// If this is set, it overrides other website settings.
	RedirectAllRequestsTo *string `field:"optional" json:"redirectAllRequestsTo" yaml:"redirectAllRequestsTo"`
	// Terraform regular expression (regex) string.
	//
	// Characters matching the regex will be removed from the ID elements.
	// If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
	RegexReplaceChars *string `field:"optional" json:"regexReplaceChars" yaml:"regexReplaceChars"`
	// The identifier for a response headers policy.
	ResponseHeadersPolicyId *string `field:"optional" json:"responseHeadersPolicyId" yaml:"responseHeadersPolicyId"`
	// A json array containing routing rules describing redirect behavior and when redirects are applied.
	RoutingRules *string `field:"optional" json:"routingRules" yaml:"routingRules"`
	// Name of the existing S3 bucket where S3 Access Logs will be delivered.
	//
	// Default is not to enable S3 Access Logging.
	S3AccessLogBucketName *string `field:"optional" json:"s3AccessLogBucketName" yaml:"s3AccessLogBucketName"`
	// Set `true` to deliver S3 Access Logs to the `s3_access_log_bucket_name` bucket.
	//
	// Defaults to `false` if `s3_access_log_bucket_name` is empty (the default), `true` otherwise.
	// Must be set explicitly if the access log bucket is being created at the same time as this module is being invoked.
	S3AccessLoggingEnabled *bool `field:"optional" json:"s3AccessLoggingEnabled" yaml:"s3AccessLoggingEnabled"`
	// Prefix to use for S3 Access Log object keys.
	//
	// Defaults to `logs/$${module.this.id}`
	S3AccessLogPrefix *string `field:"optional" json:"s3AccessLogPrefix" yaml:"s3AccessLogPrefix"`
	// Specifies the S3 object ownership control on the origin bucket.
	//
	// Valid values are `ObjectWriter`, `BucketOwnerPreferred`, and 'BucketOwnerEnforced'.
	// ObjectWriter.
	S3ObjectOwnership *string `field:"optional" json:"s3ObjectOwnership" yaml:"s3ObjectOwnership"`
	// A list of S3 [origins](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-arguments) (in addition to the one created by this module) for this distribution. S3 buckets configured as websites are `custom_origins`, not `s3_origins`. Specifying `s3_origin_config.origin_access_identity` as `null` or `""` will have it translated to the `origin_access_identity` used by the origin created by the module.
	S3Origins interface{} `field:"optional" json:"s3Origins" yaml:"s3Origins"`
	// If set to true, and `website_enabled` is also true, a password will be required in the `Referrer` field of the HTTP request in order to access the website, and Cloudfront will be configured to pass this password in its requests.
	//
	// This will make it much harder for people to bypass Cloudfront and access the S3 website directly via its website endpoint.
	S3WebsitePasswordEnabled *bool `field:"optional" json:"s3WebsitePasswordEnabled" yaml:"s3WebsitePasswordEnabled"`
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
	// A list of key group IDs that CloudFront can use to validate signed URLs or signed cookies.
	TrustedKeyGroups *[]*string `field:"optional" json:"trustedKeyGroups" yaml:"trustedKeyGroups"`
	// The AWS accounts, if any, that you want to allow to create signed URLs for private content.
	//
	// 'self' is acceptable.
	TrustedSigners *[]*string `field:"optional" json:"trustedSigners" yaml:"trustedSigners"`
	// When set to 'true' the s3 origin bucket will have versioning enabled true.
	VersioningEnabled *bool `field:"optional" json:"versioningEnabled" yaml:"versioningEnabled"`
	// Limit the protocol users can use to access content.
	//
	// One of `allow-all`, `https-only`, or `redirect-to-https`
	// redirect-to-https.
	ViewerProtocolPolicy *string `field:"optional" json:"viewerProtocolPolicy" yaml:"viewerProtocolPolicy"`
	// When set to 'true' the resource will wait for the distribution status to change from InProgress to Deployed true.
	WaitForDeployment *bool `field:"optional" json:"waitForDeployment" yaml:"waitForDeployment"`
	// ID of the AWS WAF web ACL that is associated with the distribution.
	WebAclId *string `field:"optional" json:"webAclId" yaml:"webAclId"`
	// Set to true to enable the created S3 bucket to serve as a website independently of Cloudfront, and to use that website as the origin.
	//
	// See the README for details and caveats. See also `s3_website_password_enabled`.
	WebsiteEnabled *bool `field:"optional" json:"websiteEnabled" yaml:"websiteEnabled"`
}
